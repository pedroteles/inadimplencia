import io
import re
import zipfile
import requests
from datetime import datetime

from db import get_connection, insert_csv_data
from storage import save_zip_to_blob
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
    except Exception as e:
        print(f"Erro ao baixar ZIP do ano {year}: {e}")
        return None

def extract_and_insert(zip_bytes, year, conn):
    try:
        with zipfile.ZipFile(zip_bytes) as z:
            for file_name in z.namelist():
                if file_name.endswith(".csv"):
                    try:
                        match = re.search(r'_(\d{4})(\d{2})\.csv$', file_name)                        
                        if match:
                            file_year = int(match.group(1)) # Captura AAAA
                            month = int(match.group(2))     # Captura mm
                            # Validação adicional (opcional, mas recomendada)
                            if file_year == year:
                                with z.open(file_name) as f:
                                    csv_content = f.read().decode("utf-8")
                                    insert_csv_data(conn, csv_content, year, month)
                                    log_extraction(conn, year, month, 'sucesso')
                                    print(f"Mês {month}/{year} processado com sucesso.")
                            else:
                                print(f"Aviso: Ano do arquivo ({file_year}) não corresponde ao ano esperado ({year}). Arquivo ignorado: {file_name}")        
                        else:
                            print(f"Aviso: Formato de nome de arquivo não reconhecido. Arquivo ignorado: {file_name}")
                    except Exception as e:
                        print(f"Erro ao inserir dados de {month}/{year}: {e}")
                        log_extraction(conn, year, month, 'erro_insercao')
    except Exception as e:
        print(f"Erro ao extrair ZIP do ano {year}: {e}")

def run_extraction():
    conn = None  # Inicializa a conexão como None
    try:
        conn = get_connection()
        print("Conexão com o banco de dados estabelecida com sucesso.")

        first_year = 2012
        first_year = 2024  # Para testes locais, definir um ano fixo
        current_year = get_current_year()
        #current_year = 2012  # Para testes locais, definir um ano fixo

        for year in range(first_year, current_year + 1):
            processed_months = get_processed_months(conn, year)
            if len(processed_months) == 12:
                print(f"Ano {year} já completamente processado. Pulando.")
                continue
            print(f"Iniciando extração para o ano {year}...")    
            zip_bytes = download_zip(year)
            if zip_bytes is None:
                for month in range(1, 13):
                    if month not in processed_months:
                        log_extraction(conn, year, month, 'erro_download')
                continue

            extract_and_insert(zip_bytes, year, conn)

            # Se houve erro de inserção, salvar ZIP no Blob Storage
            remaining_months = get_processed_months(conn, year)
            if len(remaining_months) < 12:
                save_zip_to_blob(zip_bytes, year)
    except Exception as e:
        print(f"ERRO CRÍTICO: Não foi possível conectar ao banco de dados. {e}")
        print("A extração será abortada. Verifique as credenciais e a conexão de rede.")
        
    finally:
        if conn:
            conn.close()
            print("Conexão com o banco de dados encerrada.")       

# Executar a extração
if __name__ == "__main__":
    run_extraction()