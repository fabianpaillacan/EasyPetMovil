from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from firebase_admin import auth

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


@router.get("/pet_profile/{pet_id}")
async def get_pet_profile(
    pet_id: str,
    user_id: str = Depends(get_current_user),
):
    try:
        pet_ref = db.collection("pets").document(pet_id)
        pet_doc = pet_ref.get()

        if not pet_doc.exists:
            raise HTTPException(status_code=404, detail="Mascota no encontrada")

        pet_data = pet_doc.to_dict()

        if pet_data["owner_id"] != user_id:
            raise HTTPException(status_code=403, detail="Acceso no autorizado")

        pet_data["id"] = pet_doc.id
        return pet_data

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
