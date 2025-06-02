from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from firebase_admin import auth

from backend.firebase.config import db

router = APIRouter(prefix="/my", tags=["my"])
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


@router.get("/pets")
async def pets_list_for_user(user_id: str = Depends(get_current_user)):
    try:
        user_ref = db.collection("users").document(user_id)
        user_doc = user_ref.get()

        if not user_doc.exists:
            raise HTTPException(
                status_code=404, detail="Usuario no encontrado"
            )

        pets_ids = user_doc.to_dict().get("pets", [])

        if not pets_ids:
            return {"pets": []}

        pets_data = []
        for pet_id in pets_ids:
            pet_ref = db.collection("pets").document(pet_id)
            pet_doc = pet_ref.get()

            if pet_doc.exists:
                pet_data = pet_doc.to_dict()
                pet_data['id'] = pet_doc.id  # ✅ Se incluye el ID
                pets_data.append(pet_data)

        return {"pets": pets_data}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))