import os
import zipfile
import pandas as pd
from google.cloud import bigquery, storage
from io import BytesIO
from concurrent.futures import ThreadPoolExecutor, as_completed

# --- CONFIGURAÇÕES ---
PROJECT_ID = "portifolio-475317"
BUCKET_NAME = "inadimplencia_raw_data"
GCS_FOLDER = "scr_raw_data_parquet"
DATASET_ID = "inadimplencia_db_stg"
TABLE_ID = "scr_raw_data"
LOCAL_DATA_PATH = r"C:\Users\pedro\OneDrive - Sunflow\Documentos\SmartSun\Portifólio\inadimplencia\bases\bcb"

# --- INICIALIZAÇÃO DOS CLIENTES GCP ---
storage_client = storage.Client(project=PROJECT_ID)
bq_client = bigquery.Client(project=PROJECT_ID)
bucket = storage_client.bucket(BUCKET_NAME)

def process_and_upload(zip_path: str, csv_filename_in_zip: str):
    """
    Lê um CSV de um ZIP, converte para Parquet sem transformações
    e faz o upload para o GCS.
    """
    try:
        with zipfile.ZipFile(zip_path, 'r') as zf:
            with zf.open(csv_filename_in_zip) as csv_file:
                # Etapa 1: Ler o CSV com todas as colunas como string. Nenhuma validação.
                df = pd.read_csv(
                    csv_file, 
                    sep=';', 
                    encoding='utf-8', 
                    dtype=str, 
                    keep_default_na=False, 
                    na_values=['']
                )

                if 'data_base' not in df.columns:
                    print(f"AVISO: Coluna 'data_base' não encontrada. Pulando arquivo: {csv_filename_in_zip}")
                    return None
                
                # Adiciona a conversão de tipo para a coluna de data
                df['data_base'] = pd.to_datetime(df['data_base']).dt.date

                # Etapa 2: Converter para Parquet em memória e fazer o upload.
                parquet_filename = f"{os.path.splitext(csv_filename_in_zip)[0]}.parquet"
                gcs_path = f"{GCS_FOLDER}/{parquet_filename}"
                
                blob = bucket.blob(gcs_path)
                parquet_buffer = BytesIO()
                df.to_parquet(parquet_buffer, engine='pyarrow', index=False)
                
                blob.upload_from_file(parquet_buffer, rewind=True, content_type='application/octet-stream')
                
                print(f"✔ Upload concluído: {gcs_path}")
                return gcs_path
    except Exception as e:
        print(f"ERRO ao processar {csv_filename_in_zip} de {zip_path}: {e}")
        return None

def main():
    """Orquestra todo o processo de ELT."""
    
    print("--- Iniciando Etapa 1: Processamento local e Upload para GCS ---")
    
    tasks = []
    zip_files = [f for f in os.listdir(LOCAL_DATA_PATH) if f.lower().endswith('.zip')]

    for zip_filename in zip_files:
        zip_path = os.path.join(LOCAL_DATA_PATH, zip_filename)
        try:
            with zipfile.ZipFile(zip_path, 'r') as zf:
                for csv_filename_in_zip in zf.namelist():
                    if csv_filename_in_zip.lower().endswith('.csv'):
                        tasks.append((zip_path, csv_filename_in_zip))
        except zipfile.BadZipFile:
            print(f"AVISO: Arquivo corrompido ou não é um ZIP válido. Pulando: {zip_filename}")

    if not tasks:
        print("Nenhum arquivo CSV encontrado nos arquivos ZIP. Verifique a estrutura de pastas e arquivos.")
        return

    # Processamento e upload em paralelo
    uploaded_files_count = 0
    with ThreadPoolExecutor(max_workers=os.cpu_count()) as executor:
        futures = [executor.submit(process_and_upload, zip_path, csv_name) for zip_path, csv_name in tasks]
        for future in as_completed(futures):
            if future.result():
                uploaded_files_count += 1
    
    if uploaded_files_count == 0:
        print("Nenhum arquivo foi processado com sucesso. Verifique os logs de erro.")
        return

    print(f"\n--- Etapa 1 Concluída: {uploaded_files_count} arquivos processados e enviados para o GCS. ---")

    # --- Etapa 2: Carregar dados do GCS para o BigQuery ---
    print("\n--- Iniciando Etapa 2: Carga em massa do GCS para o BigQuery ---")
    
    table_ref = bq_client.dataset(DATASET_ID).table(TABLE_ID)
    
    # O schema da tabela de destino no BigQuery espera 'data_base' como DATE.
    # O BigQuery consegue converter automaticamente a string 'YYYY-MM-DD' do Parquet para DATE.
    schema = [
        bigquery.SchemaField("data_base", "DATE"),
        # Adicione as outras colunas como STRING
        bigquery.SchemaField("uf", "STRING"),
        bigquery.SchemaField("tcb", "STRING"),
        bigquery.SchemaField("sr", "STRING"),
        bigquery.SchemaField("cliente", "STRING"),
        bigquery.SchemaField("ocupacao", "STRING"),
        bigquery.SchemaField("cnae_secao", "STRING"),
        bigquery.SchemaField("cnae_subclasse", "STRING"),
        bigquery.SchemaField("porte", "STRING"),
        bigquery.SchemaField("modalidade", "STRING"),
        bigquery.SchemaField("origem", "STRING"),
        bigquery.SchemaField("indexador", "STRING"),
        bigquery.SchemaField("numero_de_operacoes", "STRING"),
        bigquery.SchemaField("a_vencer_ate_90_dias", "STRING"),
        bigquery.SchemaField("a_vencer_de_91_ate_360_dias", "STRING"),
        bigquery.SchemaField("a_vencer_de_361_ate_1080_dias", "STRING"),
        bigquery.SchemaField("a_vencer_de_1081_ate_1800_dias", "STRING"),
        bigquery.SchemaField("a_vencer_de_1801_ate_5400_dias", "STRING"),
        bigquery.SchemaField("a_vencer_acima_de_5400_dias", "STRING"),
        bigquery.SchemaField("vencido_acima_de_15_dias", "STRING"),
        bigquery.SchemaField("carteira_ativa", "STRING"),
        bigquery.SchemaField("carteira_inadimplida_arrastada", "STRING"),
        bigquery.SchemaField("ativo_problematico", "STRING"),
    ]

    job_config = bigquery.LoadJobConfig(
        schema=schema, # Especificar o schema ajuda o BigQuery
        source_format=bigquery.SourceFormat.PARQUET,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
        time_partitioning=bigquery.TimePartitioning(
            type_=bigquery.TimePartitioningType.MONTH,
            field="data_base",
        ),
        # Adiciona a configuração de clusterização para corresponder à tabela de destino
        clustering_fields=["uf", "porte", "modalidade"]
    )

    uri = f"gs://{BUCKET_NAME}/{GCS_FOLDER}/*.parquet"
    load_job = bq_client.load_table_from_uri(uri, table_ref, job_config=job_config)
    print(f"Disparando Load Job {load_job.job_id}...")

    load_job.result()
    
    destination_table = bq_client.get_table(table_ref)
    print(f"--- Etapa 2 Concluída: {destination_table.num_rows} linhas carregadas na tabela {TABLE_ID}. ---")

if __name__ == "__main__":
    main()