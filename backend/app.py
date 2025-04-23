from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.routes import auth, register, petRegister, petsListForUser
import os
from backend.firebase import config
from dotenv import load_dotenv
# Cargar las variables de entorno desde el archivo .env
load_dotenv()

# Obtener la variable desde el archivo .env
GCP_SERVICE_ACCOUNT_KEY_PATH = os.getenv("GCP_SERVICE_ACCOUNT_KEY_PATH")

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = GCP_SERVICE_ACCOUNT_KEY_PATH

# App
app = FastAPI()

# CORS para que Flutter acceda
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_headers=["*"],
    allow_methods=["*"],
)

# Registrar rutas
app.include_router(auth.router)
app.include_router(register.router)
app.include_router(petRegister.router)
app.include_router(petsListForUser.router)