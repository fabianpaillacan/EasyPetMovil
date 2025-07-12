from fastapi import APIRouter, Depends
from backend.utils.auth import get_current_user

router = APIRouter(prefix="/auth", tags=["auth"])

@router.get("/user/ping", summary="Ping endpoint to verify user authentication")
def ping(user_id: str = Depends(get_current_user)):
    return {"message": f"Hola, tu UID es {user_id}"}

@router.get("/test", summary="Test endpoint without authentication")
def test():
    return {"message": "Backend is working"}
