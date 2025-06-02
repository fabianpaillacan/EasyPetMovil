from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from firebase_admin import auth, firestore
from pydantic import BaseModel

from backend.firebase.config import db

router = APIRouter(prefix="/pets", tags=["pets"])
security = HTTPBearer()


class PetRegisterRequest(BaseModel):
    name: str
    breed: str
    weight: str
    color: str
    gender: str
    age: str
    owner_id: str


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


@router.post("/register", status_code=201)
async def register_pet(
    pet: PetRegisterRequest,
    current_user_uid: str = Depends(get_current_user),
):
    try:
        # Verificar que el owner_id coincida con el usuario autenticado
        if pet.owner_id != current_user_uid:
            raise HTTPException(
                status_code=403,
                detail="No autorizado para registrar mascotas para este usuario",
            )

        # Verificar que el usuario existe
        try:
            auth.get_user(pet.owner_id)
        except:
            raise HTTPException(
                status_code=404, detail="Usuario no encontrado"
            )

        # Crear un UID único para la mascota
        pet_ref = db.collection("pets").document()
        pet_uid = pet_ref.id

        # Registrar mascota en Firestore
        pet_data = {
            "uid": pet_uid,
            "name": pet.name,
            "breed": pet.breed,
            "age": pet.age,
            "weight": pet.weight,
            "color": pet.color,
            "gender": pet.gender,
            "owner_id": pet.owner_id,
            "created_at": firestore.SERVER_TIMESTAMP,
        }

        pet_ref.set(pet_data)

        # Actualizar la lista de mascotas del usuario
        user_ref = db.collection("users").document(pet.owner_id)
        user_ref.update({"pets": firestore.ArrayUnion([pet_uid])})

        return {
            "message": "Mascota registrada exitosamente",
            "pet_id": pet_uid,
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error al registrar mascota: {str(e)}"
        )
