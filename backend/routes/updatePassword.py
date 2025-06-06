from fastapi import APIRouter, Depends, HTTPException, Body
from firebase_admin import auth
from pydantic import BaseModel
from backend.utils.auth import get_current_user

router = APIRouter(prefix="/update", tags=["update"])
class PasswordUpdate(BaseModel):
    new_password: str

@router.put("/password")
async def update_password(
    data: PasswordUpdate = Body(...),
    user_id: str = Depends(get_current_user)
):
    try:
        auth.update_user(user_id, password=data.new_password)
        return {"message": "Contraseña actualizada"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
