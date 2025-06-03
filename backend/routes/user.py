from fastapi import APIRouter, Body, Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from firebase_admin import auth, firestore
from backend.firebase.config import db
from backend.models.user import RegisterRequest, PartialUserUpdateRequest

router = APIRouter(prefix="/user", tags=["user"])
security = HTTPBearer()


# Validación del token
async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
):
    try:
        token = credentials.credentials
        decoded_token = auth.verify_id_token(token)
        return decoded_token["uid"]
    except Exception:
        raise HTTPException(status_code=401, detail="Token inválido o expirado")


# Registro de usuario
@router.post("/register", status_code=201)
async def register_user(req: RegisterRequest):
    try:
        # Crear usuario en Firebase Auth
        try:
            user_record = auth.create_user(email=req.email, password=req.password)
            uid = user_record.uid
        except Exception as auth_error:
            raise HTTPException(status_code=400, detail=f"Error en autenticación: {auth_error}")

        # Guardar datos en Firestore
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
            # Rollback: eliminar usuario en Firebase Auth si falla Firestore
            auth.delete_user(uid)
            raise HTTPException(status_code=400, detail=f"Error en base de datos: {db_error}")

        return {"message": "Usuario registrado correctamente"}

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error inesperado: {e}")


# Consultar información del usuario
@router.get("/information")
async def consult_user(user_id: str = Depends(get_current_user)):
    try:
        user_ref = db.collection("users").document(user_id)
        user_doc = user_ref.get()

        if not user_doc.exists:
            raise HTTPException(status_code=404, detail="Usuario no encontrado")

        return {"user": user_doc.to_dict()}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# Actualizar información del usuario
@router.put("/update")
async def update_user(
    user_id: str = Depends(get_current_user),
    data: PartialUserUpdateRequest = Body(...)
):
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
