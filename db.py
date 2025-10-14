import os
import psycopg2
import csv
import io
from dotenv import load_dotenv

load_dotenv()  # Carrega as variáveis de ambiente do arquivo .env

def get_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        port=os.getenv("DB_PORT", 5432)
    )

"""
def insert_csv_data(conn, csv_content, year, month):
    with conn.cursor() as cur:
        for line in csv_content.splitlines()[1:]:  # Ignora o cabeçalho
            values = line.split(",")
            cur.execute(
                "INSERT INTO tabela_dados (ano, mes, coluna1, coluna2) VALUES (%s, %s, %s, %s)",
                (year, month, values[0], values[1])
            )
        conn.commit()
"""

def insert_csv_data(conn, file_stream, year, month):
    """
    Carrega dados de um fluxo de arquivo (file-like object) para o banco de dados
    usando um esquema fixo e o comando COPY com a opção HEADER.
    """    

    try:
        with conn.cursor() as cur:
            

            # 2. Usa COPY para transmitir os dados, instruindo o PG a ignorar o cabeçalho.
            print(f"Carregando dados do CSV para a tabela temporária (ano {year}, mês {month})...")
            copy_sql = f"COPY stg.scr_raw_data FROM STDIN WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE)"
            cur.copy_expert(sql=copy_sql, file=file_stream)            
            
            conn.commit()
            print(f"Sucesso: Dados do CSV inseridos e transação commitada.")

    except Exception as e:
        print(f"Erro ao inserir dados no banco com COPY: {e}")
        conn.rollback() # Desfaz a transação em caso de erro
        raise ValueError("erro terrível na inserção do CSV, a transação foi revertida.")
    
def check_connection_and_permissions():
    """
    Verifica a conexão e garante que o usuário tem permissões de escrita.
    Levanta uma exceção clara se a conexão for somente leitura.
    """
    conn = None
    try:
        conn = get_connection()
        with conn.cursor() as cur:
            # Tenta uma operação de escrita inofensiva dentro de uma transação
            cur.execute("CREATE TEMP TABLE permission_check (id INT);")
            # Se a linha acima falhar, a exceção será capturada
            print("Verificação de permissão de escrita bem-sucedida.")
        # A transação é revertida automaticamente ao sair do 'with' ou no finally
    except psycopg2.Error as e:
        # Captura o erro específico de "read-only" e lança um erro mais claro
        if "read-only" in str(e):
            raise PermissionError("A conexão com o banco de dados é somente leitura. Verifique o host e as permissões do usuário.")
        else:
            print(f"Erro ao conectar ou verificar permissões no banco de dados: {e}")
            raise  # Lança outras exceções de conexão
    finally:
        if conn:
            conn.close()    
def testconnection():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT version();")
    db_version = cur.fetchone()
    print(f"Conexão bem-sucedida. Versão do banco de dados: {db_version[0]}")
    cur.close()
    conn.close()
    
if __name__ == "__main__":
    testconnection()        