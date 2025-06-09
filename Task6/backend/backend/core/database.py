from supabase import create_client, Client
from core.config import settings
import logging

logger = logging.getLogger(__name__)

class Database:
    _instance = None
    _client = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(Database, cls).__new__(cls)
            try:
                cls._client = create_client(
                    settings.SUPABASE_URL, 
                    settings.SUPABASE_KEY
                )
                logger.info("Supabase client initialized successfully")
            except Exception as e:
                logger.error(f"Failed to initialize Supabase client: {e}")
                raise e
        return cls._instance
    
    @property
    def client(self) -> Client:
        return self._client
    
    def get_table(self, table_name: str):
        return self._client.table(table_name)

# Create a singleton instance
db = Database()

def get_db() -> Database:
    return db
