# backend/controllers/user_controller.py

from firebase_admin import auth, firestore
from fastapi import HTTPException
from backend.firebase.config import db
from backend.models.user import RegisterRequest, PartialUserUpdateRequest


async def create_user_account(req: RegisterRequest):
    try:
        user_record = auth.create_user(email=req.email, password=req.password)
        uid = user_record.uid
    except Exception as auth_error:
        raise HTTPException(status_code=400, detail=f"Error en autenticación: {auth_error}")

    try:
        user_ref = db.collection("users").document(uid)
        user_data = {
            "first_name": req.first_name,
            "last_name": req.last_name,
            "rut": req.rut,
            "birth_date": req.birth_date,
            "phone": req.phone,
            "email": req.email,
            "gender": req.gender,
            "uid": uid,
            "created_at": firestore.SERVER_TIMESTAMP,
        }
        user_ref.set(user_data)
    except Exception as db_error:
        auth.delete_user(uid)
        raise HTTPException(status_code=400, detail=f"Error en base de datos: {db_error}")

    return {"message": "Usuario registrado correctamente"}


async def get_user_info(user_id: str):
    try:
        user_ref = db.collection("users").document(user_id)
        user_doc = user_ref.get()

        if not user_doc.exists:
            raise HTTPException(status_code=404, detail="Usuario no encontrado")

        return {"user": user_doc.to_dict()}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


async def update_user_info(user_id: str, data: PartialUserUpdateRequest):
    try:
        updates = {k: v for k, v in data.model_dump().items() if v is not None}
        if not updates:
            raise HTTPException(status_code=400, detail="No hay campos para actualizar")

        user_ref = db.collection("users").document(user_id)
        user_ref.update(updates)

        if 'email' in updates:
            auth.update_user(user_id, email=updates['email'])

        return {"message": "Usuario actualizado correctamente"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

async def get_pets_for_user(user_id: str):
    try:
        user_ref = db.collection("users").document(user_id)
        user_doc = user_ref.get()

        if not user_doc.exists:
            raise HTTPException(status_code=404, detail="Usuario no encontrado")

        pets_ids = user_doc.to_dict().get("pets", [])

        if not pets_ids:
            return {"pets": []}

        pets_data = []
        for pet_id in pets_ids:
            pet_ref = db.collection("pets").document(pet_id)
            pet_doc = pet_ref.get()

            if pet_doc.exists:
                pet_data = pet_doc.to_dict()
                pet_data['id'] = pet_doc.id  # Incluye el ID del documento
                pets_data.append(pet_data)

        return {"pets": pets_data}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))