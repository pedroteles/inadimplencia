import azure.functions as func
import logging
import os
import threading
import time
from scr_bacen.main_extractor import run_extraction, get_current_year
from azure.storage.blob import BlobServiceClient
from azure.storage.queue import QueueServiceClient
from azure.core.exceptions import ResourceExistsError, ResourceNotFoundError

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

# --- FUNÇÃO AUXILIAR PARA VERIFICAR O ESTADO ---
def is_process_already_active() -> bool:
    """
    Verifica se um processo já está em execução (via blob lock) ou
    se uma solicitação já está na fila.
    """
    try:
        connect_str = os.getenv('AzureWebJobsStorage')
        if not connect_str:
            logging.error("A string de conexão 'AzureWebJobsStorage' não está configurada.")
            print("A string de conexão 'AzureWebJobsStorage' não está configurada.")
            return True # Falha segura: assume que está ativo para evitar duplicatas.

        # 1. Verifica se um processo está em execução (verificando o blob lease)
        blob_service_client = BlobServiceClient.from_connection_string(connect_str)
        blob_client = blob_service_client.get_blob_client("singleton-locks", "extraction_lock.txt")
        if blob_client.exists():
            properties = blob_client.get_blob_properties()
            if properties.lease.status == 'locked':
                logging.info("Verificação de estado: Um processo já está em execução (lock ativo).")
                print("Um processo já está em execução (lock ativo).")
                return True

        # 2. Verifica se há mensagens na fila
        queue_service_client = QueueServiceClient.from_connection_string(connect_str)
        queue_client = queue_service_client.get_queue_client("extraction-queue")
        properties = queue_client.get_queue_properties()
        if properties.approximate_message_count > 0:
            logging.info("Verificação de estado: Já existe uma solicitação na fila.")
            print("Já existe uma solicitação na fila.")
            return True

    except ResourceNotFoundError:
        # Ocorre se o container ou a fila ainda não existem. É seguro continuar.
        return False
    except Exception as e:
        return True # Falha segura
    return False

# --- GATILHOS INTELIGENTES ---

@app.route(route="start_extraction_http")
@app.queue_output(arg_name="queue_msg", queue_name="extraction-queue", connection="AzureWebJobsStorage")
def start_extraction_http(req: func.HttpRequest, queue_msg: func.Out[str]) -> func.HttpResponse:
    logging.info('Gatilho HTTP acionado.')   

    if is_process_already_active():
        return func.HttpResponse(
            "O processo de extração já está em execução ou na fila. Nenhuma nova solicitação foi adicionada.",
            status_code=409  # Conflict
        )
    
    logging.info('Nenhum processo ativo. Enviando mensagem para a fila de extração.')
    queue_msg.set("start_extraction_http")
    return func.HttpResponse(
        "O processo de extração foi agendado com sucesso.",
        status_code=202  # Accepted
    )

@app.schedule(schedule="0 0 0 * * 1", arg_name="timer", run_on_startup=False)
@app.queue_output(arg_name="queue_msg", queue_name="extraction-queue", connection="AzureWebJobsStorage")
def start_extraction_timer(timer: func.TimerRequest, queue_msg: func.Out[str]) -> None:
    logging.info('Gatilho de Timer acionado.')
    
    if is_process_already_active():
        logging.info("Processo de extração já está em execução ou na fila. O gatilho do timer será ignorado.")
        return
        
    logging.info('Nenhum processo ativo. Enviando mensagem para a fila de extração.')
    queue_msg.set("start_extraction_timer")

# --- O EXECUTOR (permanece o mesmo) ---

@app.queue_trigger(arg_name="msg", queue_name="extraction-queue", connection="AzureWebJobsStorage")
def execute_extraction_from_queue(msg: func.QueueMessage) -> None:
    logging.info(f'Gatilho de Fila acionado pela mensagem: {msg.get_body().decode("utf-8")}')
    print("Gatilho de Fila acionado pela mensagem:", msg.get_body().decode("utf-8"))
    
    lease_client = None
    stop_event = threading.Event()

    # Função que será executada na thread de segundo plano
    def renew_lease_worker(client, event):
        while not event.is_set():
            try:
                client.renew()
                logging.info("Lease renovado com sucesso.")
                print("Lease renovado com sucesso.")
            except Exception as e:
                break # Sai do loop se a renovação falhar
            # Espera por 25 segundos antes da próxima renovação
            print("Dormindo por 25 segundos antes da próxima renovação.")
            time.sleep(25)

    try:
        connect_str = os.getenv('AzureWebJobsStorage')
        blob_service_client = BlobServiceClient.from_connection_string(connect_str)        
        container_client = blob_service_client.get_container_client("singleton-locks")

        try:
            container_client.create_container()
        except ResourceExistsError:
            # O contêiner já existe, o que é esperado.
            pass
        
        blob_client = container_client.get_blob_client("extraction_lock.txt")
        
        try:
            blob_client.upload_blob("lock", overwrite=False)
            logging.info("Blob de lock criado com sucesso.")
        except ResourceExistsError:
            # Se o blob já existe, apenas continue
            logging.info("O blob de lock já existe. Continuando para tentar adquirir o lease.")  
            pass

        # Adquire o lease com uma duração de 60 segundos
        lease_client = blob_client.acquire_lease(lease_duration=60)
        logging.info("Bloqueio adquirido com sucesso. Iniciando o processo de extração...")
        print("Bloqueio adquirido com sucesso. Iniciando o processo de extração...")  

        # Cria e inicia a thread de renovação
        renewal_thread = threading.Thread(target=renew_lease_worker, args=(lease_client, stop_event))
        renewal_thread.start()

        # --- O TRABALHO PESADO ACONTECE AQUI ---
        try:
            print("Iniciando a extração...")
            logging.info('Iniciando a extração...')

            # Para 'first_year', usa a variável de ambiente ou o padrão fixo.
            first_year = int(os.getenv("FIRST_YEAR", 2012))
    
            # Para 'current_year', usa a variável de ambiente ou o padrão dinâmico.
            current_year_str = os.getenv("CURRENT_YEAR")
            if current_year_str:
                current_year = int(current_year_str)
            else:
                current_year = get_current_year()

            # Chama a lógica de negócio com a configuração resolvida.
            run_extraction(first_year, current_year)
            print("Processo de extração finalizado com sucesso.")
            logging.info('Processo de extração finalizado com sucesso.')
        except Exception as e:
            logging.error(f"Ocorreu um erro durante a extração: {e}", exc_info=True)
            print(f"Ocorreu um erro durante a extração: {e}")
            raise
        finally:
            # Garante que a thread de renovação seja parada após o trabalho
            stop_event.set()
            renewal_thread.join() # Espera a thread terminar
        # -----------------------------------------

    except ResourceExistsError:
        # Este erro ocorre se o lease não pôde ser adquirido.
        # Isso é esperado se uma instância falhou e o lease ainda não expirou.
        # Relançamos a exceção para que o Functions Runtime saiba que a execução
        # falhou e deve tentar novamente mais tarde. Isso aciona o backoff exponencial.
        logging.warning("Não foi possível adquirir o bloqueio. Outra instância pode estar em execução ou ter falhado. A mensagem será reenfileirada para nova tentativa.")
        print("Não foi possível adquirir o bloqueio. Outra instância pode estar em execução ou ter falhado. A mensagem será reenfileirada para nova tentativa.")
        
        raise # Sinaliza ao runtime para tentar novamente mais tarde
        
    except Exception as e:
        logging.error(f"Ocorreu um erro crítico durante a extração: {e}", exc_info=True)
        print(f"Ocorreu um erro crítico durante a extração: {e}")
        raise
        
    finally:
        # Garante que o bloqueio seja liberado, não importa o que aconteça
        if lease_client:
            lease_client.release()
            logging.info("Bloqueio liberado.")