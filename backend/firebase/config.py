import os

from dotenv import load_dotenv
from firebase_admin import credentials, initialize_app
from google.cloud import firestore
from google.oauth2 import service_account

from ..utils.logger import logger

# Load environment variables
load_dotenv()

# Get config from environment variables
PROJECT_ID = os.getenv("GCP_PROJECT_ID")
DATABASE_NAME = os.getenv("GCP_DATABASE_NAME")
SERVICE_ACCOUNT_KEY_PATH = os.path.abspath(os.getenv("GCP_SERVICE_ACCOUNT_KEY_PATH"))

# Validate that required environment variables are set
if not all([PROJECT_ID, DATABASE_NAME, SERVICE_ACCOUNT_KEY_PATH]):
    raise EnvironmentError(
        "Missing required environment variables for Firebase configuration"
    )


# Initialize Firebase (only once)
cred = credentials.Certificate(SERVICE_ACCOUNT_KEY_PATH)
initialize_app(cred)
logger.debug("Firebase app initialized successfully.")

# Firestore client
credentials_gcp = service_account.Credentials.from_service_account_file(
    SERVICE_ACCOUNT_KEY_PATH
)
db = firestore.Client(
    project=PROJECT_ID, credentials=credentials_gcp, database=DATABASE_NAME
)
logger.debug("Firestore client initialized successfully.")
