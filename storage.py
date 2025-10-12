import os
from azure.storage.blob import BlobServiceClient
import io

def save_zip_to_blob(zip_bytes, year):
    try:
        connect_str = os.getenv('AZURE_STORAGE_CONNECTION_STRING')
        container_name = os.getenv('AZURE_STORAGE_CONTAINER_NAME')
        blob_name = f"planilha_{year}.zip" # NOME CORRIGIDO E PADRONIZADO

        blob_service_client = BlobServiceClient.from_connection_string(connect_str)
        blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)
        
        # Garante que o objeto BytesIO está no início antes de ler
        if isinstance(zip_bytes, io.BytesIO):
            zip_bytes.seek(0)

        blob_client.upload_blob(zip_bytes, overwrite=True)
        print(f"Arquivo '{blob_name}' salvo com sucesso no Azure Blob Storage.")
    except Exception as e:
        print(f"Erro ao salvar ZIP no blob storage: {e}")

def load_zip_from_blob(year):
    """
    Tenta carregar um arquivo ZIP do Azure Blob Storage.

    Retorna:
        Um objeto io.BytesIO com o conteúdo do arquivo se encontrado, ou None caso contrário.
    """
    try:
        connect_str = os.getenv('AZURE_STORAGE_CONNECTION_STRING')
        container_name = os.getenv('AZURE_STORAGE_CONTAINER_NAME')
        blob_name = f"planilha_{year}.zip"

        if not connect_str or not container_name:
            print("Aviso: Credenciais do Azure Storage não configuradas. Não é possível carregar do cache.")
            return None

        blob_service_client = BlobServiceClient.from_connection_string(connect_str)
        blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)

        if blob_client.exists():
            print(f"Arquivo ZIP para o ano {year} encontrado no cache do Azure. Carregando...")
            downloader = blob_client.download_blob()
            return io.BytesIO(downloader.readall())
        else:
            return None
            
    except Exception as e:
        print(f"Erro ao carregar ZIP do blob storage para o ano {year}: {e}")
        return None
    
def delete_zip_from_blob(year):
    """
    Exclui um arquivo ZIP do Azure Blob Storage.
    """
    try:
        connect_str = os.getenv('AZURE_STORAGE_CONNECTION_STRING')
        container_name = os.getenv('AZURE_STORAGE_CONTAINER_NAME')
        blob_name = f"planilha_{year}.zip"

        if not connect_str or not container_name:
            print("Aviso: Credenciais do Azure Storage não configuradas. Não é possível excluir do cache.")
            return

        blob_service_client = BlobServiceClient.from_connection_string(connect_str)
        blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)

        if blob_client.exists():
            blob_client.delete_blob()
            print(f"Arquivo '{blob_name}' processado com sucesso e excluído do cache do Azure.")
            
    except Exception as e:
        print(f"Erro ao excluir ZIP do blob storage para o ano {year}: {e}")