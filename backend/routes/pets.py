
from fastapi import APIRouter, Body, Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from firebase_admin import auth
#from backend.models.pets import 
from backend.controllers import pets_controller

router = APIRouter(prefix="/pets", tags=["pets"])
security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
):
    try:
        token = credentials.credentials
        decoded_token = auth.verify_id_token(token)
        return decoded_token["uid"]
    except Exception:
        raise HTTPException(status_code=401, detail="Token inválido o expirado")

@router.post("/register", status_code=201)
async def register_pets(req: RegisterRequestPets):
    return await pets_controller.create_pets(req)

@router.get("/profile")
async def consult_pets(user_id: str = Depends(get_current_user)):
    return await pets_controller.get_pets_info(user_id)
