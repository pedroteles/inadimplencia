import azure.functions as func
import logging
import threading
from extractor import run_extraction

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

@app.route(route="inadimplencia_elt_http_trigger")
def inadimplencia_elt_http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    try:
        logging.info('Iniciando o processo de extração em uma thread separada...')
        
        # Cria e inicia a execução da sua função em uma thread de segundo plano
        thread = threading.Thread(target=run_extraction)
        thread.start()# Retorna uma resposta IMEDIATAMENTE, sem esperar a conclusão
        return func.HttpResponse(
             "O processo de extração foi iniciado com sucesso. A execução continuará em segundo plano.",
             status_code=202 # "Accepted" é o código de status HTTP ideal para este cenário
        )
    except Exception as e:
        logging.error(f"Ocorreu um erro ao tentar iniciar a thread de extração: {e}", exc_info=True)
        return func.HttpResponse(
             f"Ocorreu um erro interno no servidor ao iniciar o processo: {e}",
             status_code=500
        )