from fastapi import APIRouter, Depends, Header, HTTPException
from firebase_admin import auth

router = APIRouter()

def verify_token(authorization: str = Header(...)):
    try:
        scheme, token = authorization.split()
        decoded = auth.verify_id_token(token)
        return decoded["uid"]
    except Exception as e:
        raise HTTPException(status_code=401, detail="Token inválido")

@router.get("/ping")
def ping(user_id: str = Depends(verify_token)):
    return {"message": f"Hola, tu UID es {user_id}"}
