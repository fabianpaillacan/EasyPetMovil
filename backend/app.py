from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import logging
from rich.logging import RichHandler
from backend.firebase import config
from backend.routes import auth

# Logger bonito
logging.basicConfig(
    level=logging.DEBUG,
    format="%(message)s",
    datefmt="[%X]",
    handlers=[RichHandler()]
)
logger = logging.getLogger("rich")

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
#app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(auth.router)