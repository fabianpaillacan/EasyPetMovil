
from fastapi import APIRouter, Body, Depends
from backend.utils.auth import get_current_user 
from backend.models.user import RegisterRequest, PartialUserUpdateRequest
from backend.controllers import user_controller

router = APIRouter(prefix="/user", tags=["user"])

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

@router.get("/pets")
async def pets_list_for_user(user_id: str = Depends(get_current_user)):
    return await user_controller.get_pets_for_user(user_id)

