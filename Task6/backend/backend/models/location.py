from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from uuid import UUID

class LocationBase(BaseModel):
    latitude: float
    longitude: float
    accuracy: Optional[float] = None

class LocationCreate(LocationBase):
    session_id: Optional[UUID] = None

class LocationLog(LocationBase):
    id: UUID
    user_id: UUID
    timestamp: datetime
    session_id: Optional[UUID] = None

class LocationVerification(BaseModel):
    user_id: UUID
    venue_id: UUID
    latitude: float
    longitude: float
    accuracy: Optional[float] = None
    is_within_geofence: bool
    distance: float  # Distance in meters
