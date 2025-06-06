from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class RegisterRequestPets (BaseModel):
    name: str
    age: str
    species: Optional[str] = None
    breed: Optional[str] = None
    owner_id: str
    color: str
    weight: str
    gender: str
    #description: Optional[str] = None
    created_at: datetime = datetime.now()
    #updated_at: datetime = datetime.now()

    #tengo que ajustarlo en el frontend para que pida los tipos de datos correctos