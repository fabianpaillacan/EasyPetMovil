# from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# from backend.firebase import config
from backend.routes import (auth, user, pets, updatePassword)

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
app.include_router(auth.router) #ya esta listo la modificacion del endopoint /auth/user/ping
app.include_router(user.router) 
app.include_router(pets.router)
#app.include_router(petRegister.router) #ya esta listo la modificacion del endopoint /pets/register
#app.include_router(petsListForUser.router) #ya esta listo la modificacion del endopoint /my/pets
app.include_router(updatePassword.router) #ya esta listo la modificacion del endopoint /update/password
#app.include_router(petProfile.router) #ya esta listo la modificacion del endopoint /{pet_id} con GET y DELETE