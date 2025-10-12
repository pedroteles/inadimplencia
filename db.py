import os
import psycopg2

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
    Processa o conteúdo de um CSV, ajusta para o formato de inserção em lote
    e insere os dados brutos na tabela de staging.

    Args:
        conn: Objeto de conexão com o banco de dados.
        csv_content (str): String contendo todo o CSV.
        year (int): Ano para ser inserido em cada linha.
        month (int): Mês para ser inserido em cada linha.
    """
    
    # 1. Definição da query com todas as colunas
    # A query é construída para corresponder exatamente à tabela stg.scr_raw_data
    sql_insert_query = """
        INSERT INTO stg.scr_raw_data (
            ano, mes, data_base, uf, tcb, sr, cliente, ocupacao, cnae_secao,
            cnae_subclasse, porte, modalidade, origem, indexador, numero_de_operacoes,
            a_vencer_ate_90_dias, a_vencer_de_91_ate_360_dias, a_vencer_de_361_ate_1080_dias,
            a_vencer_de_1081_ate_1800_dias, a_vencer_de_1801_ate_5400_dias,
            a_vencer_acima_de_5400_dias, vencido_acima_de_15_dias, carteira_ativa,
            carteira_inadimplida_arrastada, ativo_problematico
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
                  %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
    """

    # 2. Preparação dos dados para inserção em lote (bulk insert)
    data_to_insert = []
    # Ignora o cabeçalho (índice 0)
    lines = csv_content.splitlines()[1:]
    
    for line in lines:
        if not line.strip():  # Ignora linhas em branco
            continue
        
        # 3. Alteração do separador para ponto e vírgula
        values = line.split(";")
        
        # Garante que a linha tem o número esperado de colunas
        if len(values) == 23:
            # Monta a tupla com ano, mês e os valores da linha do CSV
            row_tuple = (year, month, *values)
            data_to_insert.append(row_tuple)
        else:
            print(f"Aviso: Linha ignorada por ter número incorreto de colunas ({len(values)}): {line[:80]}...")

    # 4. Execução da inserção em lote
    if not data_to_insert:
        print("Nenhum dado válido para inserir.")
        return

    try:
        with conn.cursor() as cur:
            # Usa executemany para inserir todas as linhas de uma só vez
            cur.executemany(sql_insert_query, data_to_insert)
        conn.commit()
        print(f"Sucesso: {len(data_to_insert)} linhas inseridas no banco de dados.")
    except Exception as e:
        print(f"Erro ao inserir dados no banco: {e}")
        conn.rollback() # Desfaz a transação em caso de erro