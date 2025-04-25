# from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# from backend.firebase import config
from backend.routes import (auth, editInfoUser, petRegister, petsListForUser,
                            register, updatePassword)

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
app.include_router(editInfoUser.router)
app.include_router(updatePassword.router)
