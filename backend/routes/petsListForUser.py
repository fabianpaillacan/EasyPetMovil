from fastapi import APIRouter, HTTPException, Depends
from firebase_admin import auth, firestore
from pydantic import BaseModel
from backend.firebase.config import db
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import firebase_admin

import os

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "C:/Users/Fabian/Downloads/app-movil-mascotas-39716d81f712.json"
# Inicializa Firebase si no se ha hecho aún
if not firebase_admin._apps:
    firebase_admin.initialize_app()

router = APIRouter()
security = HTTPBearer()

async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    try:
        token = credentials.credentials
        decoded_token = auth.verify_id_token(token)
        return decoded_token['uid']
    except Exception as e:
        raise HTTPException(status_code=401, detail="Token inválido o expirado")
    
@router.get("/pets_list_for_user")
async def pets_list_for_user(user_id: str = Depends(get_current_user)):
    try:
        # Obtener la lista de mascotas del usuario
        user_ref = db.collection("users").document(user_id)
        user_doc = user_ref.get()
        
        if not user_doc.exists:
            raise HTTPException(status_code=404, detail="Usuario no encontrado")
        
        pets_ids = user_doc.to_dict().get("pets", [])
        
        if not pets_ids:
            return {"pets": []}
        
        # Obtener los datos de las mascotas
        pets_data = []
        for pet_id in pets_ids:
            pet_ref = db.collection("pets").document(pet_id)
            pet_doc = pet_ref.get()
            
            if pet_doc.exists:
                pets_data.append(pet_doc.to_dict())
        
        return {"pets": pets_data}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))