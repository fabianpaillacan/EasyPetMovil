from pydantic import BaseModel
from typing import Optional

class RegisterRequest(BaseModel):
    first_name: str
    last_name: str
    rut: str
    birth_date: str
    phone: str
    email: str
    gender: str
    password: str

class PartialUserUpdateRequest(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    birth_date: Optional[str] = None
    email: Optional[str] = None
    phone: Optional[str] = None
    gender: Optional[str] = None
