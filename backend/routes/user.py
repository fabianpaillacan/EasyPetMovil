
from fastapi import APIRouter, Body, Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from firebase_admin import auth
from backend.models.user import RegisterRequest, PartialUserUpdateRequest
from backend.controllers import user_controller

router = APIRouter(prefix="/user", tags=["user"])
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
async def register_user(req: RegisterRequest):
    return await user_controller.create_user_account(req)

@router.get("/information")
async def consult_user(user_id: str = Depends(get_current_user)):
    return await user_controller.get_user_info(user_id)

@router.put("/update")
async def update_user(
    user_id: str = Depends(get_current_user),
    data: PartialUserUpdateRequest = Body(...)
):
    return await user_controller.update_user_info(user_id, data)
