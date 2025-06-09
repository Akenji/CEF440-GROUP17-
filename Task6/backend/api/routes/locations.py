from fastapi import APIRouter, Depends, HTTPException, status
from core.dependencies import get_current_user
from core.database import get_db
from models.location import LocationCreate, LocationLog, LocationVerification
from models.user import UserInDB
from typing import Any, List, Dict
from uuid import UUID
from datetime import datetime
import pytz
import math

router = APIRouter()

@router.post("/log", response_model=LocationLog)
async def log_location(
    location_in: LocationCreate,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    db = get_db()
    
    # Create location log
    location_data = {
        "user_id": str(current_user.id),
        "latitude": location_in.latitude,
        "longitude": location_in.longitude,
        "accuracy": location_in.accuracy,
        "session_id": str(location_in.session_id) if location_in.session_id else None
    }
    
    result = db.client.table("location_logs").insert(location_data).execute()
    
    if not result.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to log location"
        )
    
    return result.data[0]

@router.get("/logs", response_model=List[LocationLog])
async def read_location_logs(
    user_id: UUID = None,
    session_id: UUID = None,
    limit: int = 100,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    db = get_db()
    
    # Build query
    query = db.client.table("location_logs").select("*").limit(limit)
    
    # Students can only see their own logs
    if current_user.role == "student":
        query = query.eq("user_id", str(current_user.id))
    elif user_id and (current_user.role == "educator" or current_user.role == "admin"):
        query = query.eq("user_id", str(user_id))
    
    if session_id:
        query = query.eq("session_id", str(session_id))
    
    # Execute query
    logs = query.order("timestamp", desc=True).execute()
    
    return logs.data if logs.data else []

def calculate_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """
    Calculate the great circle distance between two points 
    on the earth (specified in decimal degrees)
    Returns distance in meters
    """
    # Convert decimal degrees to radians
    lat1, lon1, lat2, lon2 = map(math.radians, [lat1, lon1, lat2, lon2])
    
    # Haversine formula
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = math.sin(dlat/2)**2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlon/2)**2
    c = 2 * math.asin(math.sqrt(a))
    
    # Radius of earth in meters
    r = 6371000
    
    return c * r

@router.post("/verify", response_model=Dict[str, Any])
async def verify_location(location_verification: LocationVerification) -> Any:
    db = get_db()
    
    # Get venue details
    venue = db.client.table("venues")\
        .select("*")\
        .eq("id", str(location_verification.venue_id))\
        .execute()
    
    if not venue.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Venue not found"
        )
    
    venue = venue.data[0]
    
    # Calculate distance
    distance = calculate_distance(
        location_verification.latitude,
        location_verification.longitude,
        venue["latitude"],
        venue["longitude"]
    )
    
    # Check if within geofence
    is_within_geofence = distance <= venue["geofence_radius"]
    
    return {
        "user_id": str(location_verification.user_id),
        "venue_id": str(location_verification.venue_id),
        "venue_name": venue["name"],
        "venue_building": venue["building"],
        "venue_room": venue["room_number"],
        "distance": distance,
        "geofence_radius": venue["geofence_radius"],
        "is_within_geofence": is_within_geofence,
        "latitude": location_verification.latitude,
        "longitude": location_verification.longitude,
        "venue_latitude": venue["latitude"],
        "venue_longitude": venue["longitude"]
    }

@router.get("/venues", response_model=List[Dict[str, Any]])
async def read_venues(
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    db = get_db()
    
    venues = db.client.table("venues").select("*").execute()
    
    return venues.data if venues.data else []

@router.get("/venues/{venue_id}", response_model=Dict[str, Any])
async def read_venue(
    venue_id: UUID,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    db = get_db()
    
    venue = db.client.table("venues").select("*").eq("id", str(venue_id)).execute()
    
    if not venue.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Venue not found"
        )
    
    return venue.data[0]
