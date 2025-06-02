from fastapi import APIRouter, Depends, Header, HTTPException
from firebase_admin import auth

router = APIRouter(prefix="/auth", tags=["auth"])


def verify_token(authorization: str = Header(...)):
    try:
        scheme, token = authorization.split()
        decoded = auth.verify_id_token(token)
        return decoded["uid"]
    except Exception:
        raise HTTPException(status_code=401, detail="Token inválido")


@router.get("/user/ping", summary="Ping endpoint to verify user authentication")
def ping(user_id: str = Depends(verify_token)):
    return {"message": f"Hola, tu UID es {user_id}"}
