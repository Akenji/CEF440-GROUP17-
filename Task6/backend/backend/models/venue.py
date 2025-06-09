from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from uuid import UUID

class VenueBase(BaseModel):
    name: str
    building: str
    room_number: str
    capacity: int
    latitude: float
    longitude: float
    geofence_radius: float = 50.0

class VenueCreate(VenueBase):
    pass

class VenueUpdate(BaseModel):
    name: Optional[str] = None
    building: Optional[str] = None
    room_number: Optional[str] = None
    capacity: Optional[int] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    geofence_radius: Optional[float] = None

class Venue(VenueBase):
    id: UUID
    created_at: datetime
    updated_at: datetime
