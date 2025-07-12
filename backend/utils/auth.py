from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from firebase_admin import auth
import logging

security = HTTPBearer()
logger = logging.getLogger(__name__)

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
):
    try:
        token = credentials.credentials
        logger.info(f"Received token: {token[:20]}...")  # Log first 20 chars
        decoded_token = auth.verify_id_token(token)
        logger.info(f"Token verified successfully for UID: {decoded_token['uid']}")
        return decoded_token["uid"]
    except Exception as e:
        logger.error(f"Token verification failed: {str(e)}")
        raise HTTPException(status_code=401, detail=f"Token inválido o expirado: {str(e)}")
