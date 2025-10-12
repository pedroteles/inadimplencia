import io
import re
import zipfile
import requests
from datetime import datetime

from db import get_connection, insert_csv_data
from storage import save_zip_to_blob, load_zip_from_blob, delete_zip_from_blob
from logger import get_processed_months, log_extraction

BASE_URL = "https://www.bcb.gov.br/pda/desig/planilha_{ano}.zip"

def get_current_year():
    return datetime.now().year

def download_zip(year):
    url = BASE_URL.format(ano=year)
    try:
        response = requests.get(url)
        response.raise_for_status()
        return io.BytesIO(response.content)
    except requests.exceptions.HTTPError as e:
        # Se o erro for 404, o arquivo simplesmente não existe ainda.
        if e.response.status_code == 404:
            print(f"Arquivo para o ano {year} não encontrado no servidor (HTTP 404).")
            return "NOT_FOUND"
        # Para outros erros HTTP, tratamos como uma falha de download.
        print(f"Erro HTTP ao baixar ZIP do ano {year}: {e}")
        return None
    except Exception as e:
        # Para outros erros (ex: rede, DNS), tratamos como falha de download.
        print(f"Erro de conexão ao baixar ZIP do ano {year}: {e}")
        return None

def extract_and_insert(zip_bytes, year, conn, processed_months):
    """
    Extrai, processa e insere os dados dos arquivos CSV contidos no ZIP.
    Retorna True se ocorreu algum erro de inserção durante a execução, False caso contrário.
    """
    had_errors_this_run = False
    try:
        with zipfile.ZipFile(zip_bytes) as z:
            # 1. Primeiro, descobre quais meses estão disponíveis no ZIP
            available_months_in_zip = set()
            for file_name in z.namelist():
                if file_name.endswith(".csv"):                    
                    match = re.search(r'_(\d{4})(\d{2})\.csv$', file_name)                        
                    if match:
                        available_months_in_zip.add(int(match.group(2)))

            # 2. Determina quais meses realmente precisam ser processados
            months_to_process = available_months_in_zip - processed_months
            if not months_to_process:
                print(f"Todos os meses disponíveis para o ano {year} já foram processados. Nada a fazer.")
                return False # Nenhum erro, pois não havia nada a fazer            

            print(f"Meses a serem processados para o ano {year}: {sorted(list(months_to_process))}")
            
            # 3. Itera novamente e processa apenas os meses necessários
            for file_name in z.namelist():
                if file_name.endswith(".csv"):
                    match = re.search(r'_(\d{4})(\d{2})\.csv$', file_name)
                    if match:
                        file_year = int(match.group(1))
                        month = int(match.group(2))

                        # Processa apenas se o mês estiver na nossa lista de tarefas
                        if month in months_to_process:
                            try:
                                if file_year == year:
                                    with z.open(file_name) as f:
                                        log_extraction(conn, year, month, 'andamento')
                                        csv_content = f.read().decode("utf-8")
                                        insert_csv_data(conn, csv_content, year, month)
                                        log_extraction(conn, year, month, 'sucesso')
                                        print(f"Mês {month}/{year} processado com sucesso.")
                                else:
                                    print(f"Aviso: Ano do arquivo ({file_year}) não corresponde ao ano esperado ({year}). Arquivo ignorado: {file_name}")
                            except Exception as e:
                                print(f"Erro ao inserir dados de {month}/{year}: {e}")
                                log_extraction(conn, year, month, 'erro_insercao')
                                had_errors_this_run = True # Sinaliza que um erro ocorreu
                    else:
                        print(f"Aviso: Formato de nome de arquivo não reconhecido. Arquivo ignorado: {file_name}")
    except Exception as e:
        print(f"Erro crítico ao extrair ZIP do ano {year}: {e}")
        had_errors_this_run = True
    
    return had_errors_this_run

def run_extraction():
    conn = None  # Inicializa a conexão como None
    try:
        conn = get_connection()
        print("Conexão com o banco de dados estabelecida com sucesso.")

        first_year = 2012
        #first_year = 2024  # Para testes locais, definir um ano fixo
        current_year = get_current_year()
        #current_year = 2012  # Para testes locais, definir um ano fixo

        for year in range(first_year, current_year + 1):
            processed_months = get_processed_months(conn, year)
            if len(processed_months) == 12:
                print(f"Ano {year} já completamente processado. Pulando.")
                continue

            print(f"Iniciando extração para o ano {year}...")    

            loaded_from_blob = False # Flag para rastrear a origem do arquivo
            # 1. Tenta carregar o ZIP do cache (Blob Storage) primeiro
            zip_bytes = load_zip_from_blob(year)
            if zip_bytes:
                loaded_from_blob = True

            # 2. Se não encontrou no cache, faz o download
            if zip_bytes is None:
                print(f"Nenhum cache encontrado para {year}. Baixando do site do BCB...")
                download_result = download_zip(year)

                # Se o arquivo não existe, encerra o loop para os anos futuros.
                if download_result == "NOT_FOUND":
                    print(f"Arquivo para o ano {year} ainda não foi publicado. Finalizando a extração.")
                    break # Interrompe o loop 'for year in ...'

                # Se o download falhou por outro motivo, loga o erro e continua para o próximo ano.
                if download_result is None:
                    for month in range(1, 13):
                        if month not in processed_months:
                            log_extraction(conn, year, month, 'erro_download')
                    continue # Pula para o próximo ano
                
                # Se o download foi bem-sucedido, atribui o conteúdo.
                zip_bytes = download_result

            # Se chegamos aqui, temos o conteúdo do ZIP (do blob ou do download)
            had_errors = extract_and_insert(zip_bytes, year, conn, processed_months)

            # Salva o ZIP no Blob Storage APENAS se uma tentativa de inserção falhou
            if had_errors and not loaded_from_blob:
                print(f"Houveram erros de inserção para o ano {year}. Salvando o arquivo ZIP para análise.")
                save_zip_to_blob(zip_bytes, year)
            # EXCLUI o ZIP do Blob Storage se foi carregado de lá e processado com SUCESSO
            elif loaded_from_blob and not had_errors:
                delete_zip_from_blob(year)

    except Exception as e:
        print(f"ERRO CRÍTICO: Não foi possível conectar ao banco de dados. {e}")
        
    finally:
        if conn:
            conn.close()
            print("Conexão com o banco de dados encerrada.")       

# Executar a extração
if __name__ == "__main__":
    run_extraction()