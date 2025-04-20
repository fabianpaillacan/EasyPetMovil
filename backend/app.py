from fastapi import FastAPI,Header, HTTPException, Depends
from google.cloud import firestore
from google.oauth2 import service_account
from rich.logging import RichHandler
from pprint import pformat
import logging
import firebase_admin #este es nuevo
from firebase_admin import credentials, firestore, auth #este es nuevo
import os
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime

# Configure logging with Rich
logging.basicConfig(
    level=logging.DEBUG,
    format="%(message)s",
    datefmt="[%X]",
    handlers=[RichHandler()]
)
logger = logging.getLogger("rich")

# Path to your service account key file
SERVICE_ACCOUNT_KEY_PATH = os.path.abspath('./app-movil-mascotas-39716d81f712.json')
firebase_admin.initialize_app(credentials.Certificate(SERVICE_ACCOUNT_KEY_PATH))
logger.info(f"Using service account key at: {SERVICE_ACCOUNT_KEY_PATH}")

# Create credentials explicitly
credentials = service_account.Credentials.from_service_account_file(SERVICE_ACCOUNT_KEY_PATH)

# Create Firestore client with explicit credentials
db = firestore.Client(
    project='app-movil-mascotas',
    credentials=credentials,
    database='easypet'
)

# Initialize FastAPI app
app = FastAPI()

# CORS (para que Flutter pueda acceder desde otro origen)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_headers=["*"],
    allow_methods=["*"],
)

def verify_token(authorization: str = Header(...)):
    try:
        scheme, token = authorization.split()
        decoded = auth.verify_id_token(token)
        return decoded["uid"]
    except Exception as e:
        raise HTTPException(status_code=401, detail="Token inválido")

@app.get("/ping")
def ping(user_id: str = Depends(verify_token)):
    return {"message": f"Hola, tu UID es {user_id}"}