from fastapi import APIRouter, Depends, HTTPException, Body
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from firebase_admin import auth
from pydantic import BaseModel

router = APIRouter()
security = HTTPBearer()

class PasswordUpdate(BaseModel):
    new_password: str

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
):
    try:
        token = credentials.credentials
        decoded_token = auth.verify_id_token(token)
        return decoded_token["uid"]
    except Exception:
        raise HTTPException(status_code=401, detail="Token inválido o expirado")

@router.put("/update_password")
async def update_password(
    data: PasswordUpdate = Body(...),
    user_id: str = Depends(get_current_user)
):
    try:
        auth.update_user(user_id, password=data.new_password)
        return {"message": "Contraseña actualizada"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
