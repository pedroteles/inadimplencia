import os
import pandas as pd
from google.cloud import bigquery, storage
import io
from datetime import datetime

# --- CONFIGURAÇÕES ---
PROJECT_ID = "portifolio-475317"
BUCKET_NAME = "inadimplencia_raw_data"
GCS_FOLDER = "aneel_raw_data_parquet"
DATASET_ID = "inadimplencia_db_stg"
TABLE_ID = "aneel_dominio_indicadores"
LOCAL_DATA_PATH = r"C:\Users\pedro\OneDrive - Sunflow\Documentos\SmartSun\Portifólio\inadimplencia\bases\aneel\dominio-indicadores.csv"

# --- INICIALIZAÇÃO DOS CLIENTES GCP ---
storage_client = storage.Client(project=PROJECT_ID)
bucket = storage_client.bucket(BUCKET_NAME)
bq_client = bigquery.Client(project=PROJECT_ID)

def process_csv():
    """Processa o arquivo CSV local e faz o upload para o GCS."""
    try:
        print(f"Processando arquivo: {LOCAL_DATA_PATH}")
        
        # Lê o arquivo CSV
        df = pd.read_csv(
            LOCAL_DATA_PATH,
            sep=';',  # Ajuste o separador se necessário
            encoding='ISO-8859-1',
            dtype={
                'SigIndicador': str,
                'DscIndicador': str
            },
            parse_dates=['DatGeracaoConjuntoDados']
            # Note que não precisamos de dayfirst=True aqui pois o formato já é yyyy-mm-dd
        )
        
        # Converte os nomes das colunas para minúsculas para corresponder ao schema do BigQuery
        df.columns = [col.lower() for col in df.columns]
        
        # Garante que a coluna de data está no formato correto para o BigQuery
        df['datgeracaoconjuntodados'] = pd.to_datetime(df['datgeracaoconjuntodados']).dt.date
        
        # Nome do arquivo Parquet no GCS
        parquet_filename = "aneel_dominio_indicadores.parquet"
        gcs_path = f"{GCS_FOLDER}/{parquet_filename}"
        
        # Converte para Parquet e faz o upload
        parquet_data = io.BytesIO()
        df.to_parquet(parquet_data, engine='pyarrow', index=False)
        parquet_data.seek(0)
        
        # Upload para o GCS
        blob = bucket.blob(gcs_path)
        blob.upload_from_file(parquet_data)
        
        print(f"Arquivo Parquet enviado com sucesso para gs://{BUCKET_NAME}/{gcs_path}")
        
        return f"gs://{BUCKET_NAME}/{gcs_path}"
        
    except Exception as e:
        print(f"Erro ao processar o CSV: {e}")
        raise

def load_to_bigquery(gcs_uri):
    """Carrega os dados do GCS para o BigQuery."""
    try:
        print(f"Carregando dados do GCS para o BigQuery: {DATASET_ID}.{TABLE_ID}")
        
        # Referência para a tabela de destino
        table_ref = bq_client.dataset(DATASET_ID).table(TABLE_ID)
        
        # Configuração do job de carregamento
        job_config = bigquery.LoadJobConfig(
            source_format=bigquery.SourceFormat.PARQUET,
            write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE
            # Não precisamos de clustering para esta tabela pequena de domínio
        )
        
        # Inicia o job de carregamento
        load_job = bq_client.load_table_from_uri(
            gcs_uri,
            table_ref,
            job_config=job_config
        )
        
        print(f"Iniciando job de carregamento: {load_job.job_id}")
        
        # Aguarda a conclusão do job
        load_job.result()
        
        # Verifica o resultado
        table = bq_client.get_table(table_ref)
        print(f"Carregamento concluído. {table.num_rows} linhas carregadas na tabela {DATASET_ID}.{TABLE_ID}")
        
    except Exception as e:
        print(f"Erro ao carregar dados para o BigQuery: {e}")
        raise

def main():
    """Função principal que orquestra todo o processo."""
    try:
        # Etapa 1: Processar o CSV e enviar para o GCS
        gcs_uri = process_csv()
        
        # Etapa 2: Carregar os dados do GCS para o BigQuery
        load_to_bigquery(gcs_uri)
        
        print("Processo concluído com sucesso!")
        
    except Exception as e:
        print(f"Erro no processamento: {e}")

if __name__ == "__main__":
    main()