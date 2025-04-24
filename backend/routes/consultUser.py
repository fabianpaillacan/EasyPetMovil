from fastapi import APIRouter, Body, Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from firebase_admin import auth
from pydantic import BaseModel

from backend.firebase.config import db

router = APIRouter()
security = HTTPBearer()


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
):
    try:
        token = credentials.credentials
        decoded_token = auth.verify_id_token(token)
        return decoded_token["uid"]
    except Exception as e:
        raise HTTPException(
            status_code=401, detail="Token inválido o expirado"
        )


@router.get("/consult_user")
async def consult_user(user_id: str = Depends(get_current_user)):
    try:
        # Obtener los datos del usuario
        user_ref = db.collection("users").document(user_id)
        user_doc = user_ref.get()

        if not user_doc.exists:
            raise HTTPException(
                status_code=404, detail="Usuario no encontrado"
            )

        user_data = user_doc.to_dict()

        return {
            "user": user_data
        }  # esto hace que se devuelva al frontend como map<>
        # return {[user_data]} #esto hace que se devuelva al frontend como list<>
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


class UserUpdateRequest(BaseModel):
    first_name: str
    last_name: str
    birth_date: str
    email: str
    phone: str
    gender: str


@router.put("/update_user")
async def update_user(
    user_id: str = Depends(get_current_user),
    data: UserUpdateRequest = Body(...),
):
    try:
        user_ref = db.collection("users").document(user_id)
        user_ref.update(data.model_dump())  # si usas Pydantic v2
        return {"message": "Usuario actualizado correctamente"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
