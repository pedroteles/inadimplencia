import os
from azure.storage.blob import BlobServiceClient

def save_zip_to_blob(zip_bytes, year):
    try:
        blob_service_client = BlobServiceClient.from_connection_string(os.getenv("AZURE_STORAGE_CONNECTION_STRING"))
        blob_client = blob_service_client.get_blob_client(container=os.getenv("AZURE_STORAGE_CONTAINER_NAME"), blob=f"{year}/dados_{year}.zip")
        blob_client.upload_blob(zip_bytes, overwrite=True)
        print(f"ZIP do ano {year} salvo no Blob Storage.")
    except Exception as e:
        print(f"Erro ao salvar ZIP no Blob Storage: {e}")