import os
from firebase_admin import credentials, initialize_app
from google.cloud import firestore
from google.oauth2 import service_account

# Ruta absoluta del archivo de credenciales
SERVICE_ACCOUNT_KEY_PATH = os.path.abspath("./app-movil-mascotas-39716d81f712.json")

# Inicializar Firebase (solo una vez)
cred = credentials.Certificate(SERVICE_ACCOUNT_KEY_PATH)
initialize_app(cred)

# Cliente Firestore
credentials_gcp = service_account.Credentials.from_service_account_file(
    SERVICE_ACCOUNT_KEY_PATH
)
db = firestore.Client(
    project="app-movil-mascotas", credentials=credentials_gcp, database="easypet"
)
