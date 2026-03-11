from datetime import datetime

def get_processed_months(conn, year):
    with conn.cursor() as cur:
        cur.execute("SELECT mes FROM stg.extracao_log WHERE ano = %s AND status = 'sucesso'", (year,))
        return {row[0] for row in cur.fetchall()}

def log_extraction(conn, year, month, status):
    with conn.cursor() as cur:
        cur.execute("""
            INSERT INTO stg.extracao_log (ano, mes, status, data_execucao)
            VALUES (%s, %s, %s, %s)
            ON CONFLICT (ano, mes) DO UPDATE SET status = EXCLUDED.status, data_execucao = EXCLUDED.data_execucao
        """, (year, month, status, datetime.now()))
        conn.commit()