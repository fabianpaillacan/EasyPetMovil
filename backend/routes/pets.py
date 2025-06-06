
from fastapi import APIRouter, Depends
from backend.utils.auth import get_current_user
from backend.models.pets import RegisterRequestPets
from backend.controllers import pets_controller

router = APIRouter(prefix="/pets", tags=["pets"])

@router.post("/register", status_code=201) #esta okey
async def register_pets(req: RegisterRequestPets, user_id: str = Depends(get_current_user)):
    return await pets_controller.create_pets(req, user_id)

@router.get("/profile/{pet_id}") 
async def consult_pets(pet_id: str, user_id: str = Depends(get_current_user)):
    return await pets_controller.get_pets_info(pet_id, user_id)

@router.delete("/profile/{pet_id}")
async def delete_pets(pet_id: str, user_id: str = Depends(get_current_user)):
    return await pets_controller.delete_pets(pet_id, user_id)
