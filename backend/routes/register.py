from fastapi import APIRouter, HTTPException, Request
from firebase_admin import auth, firestore
from pydantic import BaseModel
from backend.firebase.config import db
import firebase_admin

import os

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "C:/Users/Fabian/Downloads/app-movil-mascotas-39716d81f712.json"
# Inicializa Firebase si no se ha hecho aún
if not firebase_admin._apps:
    firebase_admin.initialize_app()

router = APIRouter()

#db = firestore.client() no es necesario, ya que se inicializa en config.py, solo hay que importar la variable db

class RegisterRequest(BaseModel):
    first_name: str
    last_name: str
    rut: str
    birth_date: str
    phone: str
    email: str
    gender: str
    password: str

@router.post("/register")
async def register_user(req: RegisterRequest):
    try:
      
        try:
            user_record = auth.create_user(
                email=req.email,
                password=req.password
            )
            uid = user_record.uid
        except Exception as auth_error:
            
            print(f"Auth error: {auth_error}")
            raise HTTPException(status_code=400, detail=f"Error en autenticación: {auth_error}")
        
        # Try to save data to Firestore
        try:
            user = db.collection("users").document(uid)
            user_data = {
                "first_name": req.first_name,
                "last_name": req.last_name,
                "rut": req.rut,
                "birth_date": req.birth_date,
                "phone": req.phone,
                "email": req.email,
                "gender": req.gender,
                "uid": uid,
                "created_at": firestore.SERVER_TIMESTAMP
            }
            user.set(user_data)
        except Exception as db_error:
            print(f"Firestore error: {db_error}")
            try:
                auth.delete_user(uid)
            except:
                pass  
            raise HTTPException(status_code=400, detail=f"Error en base de datos: {db_error}")

        return {"message": "✅ Usuario registrado correctamente"}

    except HTTPException:
        raise  
    except Exception as e:

        print(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail=f"Error inesperado: {e}")