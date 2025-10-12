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

def insert_csv_data(conn, csv_content, year, month):
    """
    Usa o comando COPY do PostgreSQL para inserir dados de um CSV em massa,
    que é o método mais performático.

    Args:
        conn: Objeto de conexão com o banco de dados.
        csv_content (str): String contendo todo o CSV.
        year (int): Ano para ser inserido em cada linha.
        month (int): Mês para ser inserido em cada linha.
    """
    
    csv_file = io.StringIO(csv_content)

    # Pega o cabeçalho para extrair os nomes das colunas
    try:
        header_line = csv_file.readline()
        # Usa csv.reader em apenas uma linha para tratar aspas no cabeçalho, se houver
        header = next(csv.reader([header_line], delimiter=';'))
        
        # Limpeza e sanitização dos nomes das colunas
        # Remove o BOM (Byte Order Mark) do primeiro item, se existir
        header[0] = header[0].lstrip('\ufeff')
        # Garante que os nomes são válidos para colunas SQL (entre aspas)
        sanitized_columns = [f'"{col.strip()}"' for col in header]
        
    except (StopIteration, IndexError):
        print("Aviso: CSV vazio ou sem cabeçalho. Nenhum dado para inserir.")
        # Lança uma nova exceção para que a função chamadora possa tratá-la.
        raise ValueError("CSV vazio ou sem cabeçalho, a inserção foi abortada.")

    try:
        with conn.cursor() as cur:
            # 1. Cria uma tabela temporária dinamicamente com base no cabeçalho
            temp_table_cols_def = ", ".join([f'{col} TEXT' for col in sanitized_columns])
            cur.execute(f"CREATE TEMP TABLE temp_raw_data ({temp_table_cols_def}) ON COMMIT DROP;")

            # 2. Usa copy_expert com FORMAT CSV para carregar o restante do CSV na tabela temporária
            # O formato CSV lida corretamente com delimitadores dentro de campos entre aspas.
            # O csv_file já está posicionado após o cabeçalho.
            print(f"Carregando dados do CSV para a tabela temporária (ano {year}, mês {month})...")
            
            # Monta o comando COPY para usar o formato CSV explícito
            copy_sql = "COPY temp_raw_data FROM STDIN WITH (FORMAT CSV, DELIMITER ';', HEADER FALSE)"
            cur.copy_expert(sql=copy_sql, file=csv_file)
            
            # 3. Insere na tabela final a partir da tabela temporária, adicionando ano e mês
            target_cols_str = ", ".join(sanitized_columns)
            select_cols_str = ", ".join([f'NULLIF(TRIM({col}), \'\')' for col in sanitized_columns])

            print("Movendo dados para a tabela de destino 'stg.scr_raw_data'...")
            insert_query = f"""
                INSERT INTO stg.scr_raw_data (ano, mes, {target_cols_str})
                SELECT %s, %s, {select_cols_str}
                FROM temp_raw_data;
            """
            cur.execute(insert_query, (year, month))
            
            row_count = cur.rowcount
            print("Dados inseridos, realizando commit...")
            conn.commit()
            print(f"Sucesso: {row_count} linhas inseridas no banco de dados.")

    except Exception as e:
        print(f"Erro ao inserir dados no banco com COPY: {e}")
        conn.rollback() # Desfaz a transação em caso de erro
        raise ValueError("erro terrível na inserção do CSV, a transação foi revertida.")

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