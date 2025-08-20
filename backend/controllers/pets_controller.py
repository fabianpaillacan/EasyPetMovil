
from firebase_admin import auth, firestore
from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from backend.firebase.config import db
from backend.models.pets import RegisterRequestPets

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
):
    try:
        token = credentials.credentials
        decoded_token = auth.verify_id_token(token)
        return decoded_token["uid"]
    except Exception:
        raise HTTPException(
            status_code=401, detail="Token inválido o expirado"
        )


async def create_pets(pet: RegisterRequestPets, current_user_uid: str = Depends(get_current_user)):

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
            #"weight": pet.weight,
            "color": pet.color,
            "gender": pet.gender,
            "birth_date": pet.birth_date,
            "species": pet.species,
            #"image": pet.image, #nuevo campo
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


async def get_pets_info(pet_id: str, user_id: str = Depends(get_current_user)):
      
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
    
async def delete_pets(pet_id: str, user_id: str = Depends(get_current_user)):
    try:
        pet_ref = db.collection("pets").document(pet_id)
        pet_doc = pet_ref.get()

        if not pet_doc.exists:
            raise HTTPException(status_code=404, detail="Mascota no encontrada")

        pet_data = pet_doc.to_dict()

        if pet_data["owner_id"] != user_id:
            raise HTTPException(status_code=403, detail="Acceso no autorizado")

        # Eliminar la mascota de Firestore
        pet_ref.delete()

        # Eliminar el ID de la mascota de la lista del usuario
        user_ref = db.collection("users").document(user_id)
        user_doc = user_ref.get()

        if user_doc.exists:
            user_data = user_doc.to_dict()
            pets_list = user_data.get("pets", [])

            if pet_id in pets_list:
                pets_list.remove(pet_id)
                user_ref.update({"pets": pets_list})

        return {"message": "Mascota eliminada exitosamente"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))