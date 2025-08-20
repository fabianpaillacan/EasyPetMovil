from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class RegisterRequestPets (BaseModel):
    name: str #obligatorio
    age: str 
    species: Optional[str] = None #opcional
    breed: Optional[str] = None #raza
    owner_id: str
    color: Optional[str] = None #opcional
    #weight: str
    gender: str
    #image: str  #investigar como subir una imagen a firebase 
    birth_date: str #nuevo campo
    #description: Optional[str] = None
    created_at: datetime = datetime.now()
    #updated_at: datetime = datetime.now()

    #tengo que ajustarlo en el frontend para que pida los tipos de datos correctos