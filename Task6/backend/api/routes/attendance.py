from fastapi import APIRouter, Depends, HTTPException, status
from core.dependencies import get_current_user, get_current_educator
from core.database import get_db
from models.attendance import (
    ClassSessionCreate, ClassSession, AttendanceSessionCreate, 
    AttendanceSession, AttendanceSessionWithDetails, AttendanceRecordCreate,
    AttendanceRecord, AttendanceRecordWithDetails
)
from models.user import UserInDB
from api.routes.locations import verify_location
from typing import Any, List
from uuid import UUID
from datetime import datetime
import pytz

router = APIRouter()

@router.post("/class-sessions", response_model=ClassSession)
async def create_class_session(
    session_in: ClassSessionCreate,
    current_user: UserInDB = Depends(get_current_educator)
) -> Any:
    db = get_db()
    
    # Check if course exists
    course = db.client.table("courses").select("*").eq("id", str(session_in.course_id)).execute()
    if not course.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Course not found"
        )
    
    # Check if venue exists
    venue = db.client.table("venues").select("*").eq("id", str(session_in.venue_id)).execute()
    if not venue.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Venue not found"
        )
    
    # Check if educator is assigned to this course if not admin
    if current_user.role == "educator":
        educator_course = db.client.table("course_educators")\
            .select("*")\
            .eq("course_id", str(session_in.course_id))\
            .eq("educator_id", str(current_user.id))\
            .execute()
        
        if not educator_course.data:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to create sessions for this course"
            )
    
    # Create class session
    result = db.client.table("class_sessions").insert(session_in.dict()).execute()
    
    if not result.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create class session"
        )
    
    return result.data[0]

@router.get("/class-sessions", response_model=List[ClassSession])
async def read_class_sessions(
    course_id: UUID = None,
    venue_id: UUID = None,
    start_date: datetime = None,
    end_date: datetime = None,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    db = get_db()
    
    # Build query
    query = db.client.table("class_sessions").select("*")
    
    # Apply filters
    if course_id:
        query = query.eq("course_id", str(course_id))
    
    if venue_id:
        query = query.eq("venue_id", str(venue_id))
    
    if start_date:
        query = query.gte("start_time", start_date.isoformat())
    
    if end_date:
        query = query.lte("end_time", end_date.isoformat())
    
    # Execute query
    sessions = query.execute()
    
    return sessions.data if sessions.data else []

@router.post("/sessions", response_model=AttendanceSession)
async def create_attendance_session(
    session_in: AttendanceSessionCreate,
    current_user: UserInDB = Depends(get_current_educator)
) -> Any:
    db = get_db()
    
    # Check if class session exists
    class_session = db.client.table("class_sessions")\
        .select("*")\
        .eq("id", str(session_in.class_session_id))\
        .execute()
    
    if not class_session.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Class session not found"
        )
    
    class_session = class_session.data[0]
    
    # Check if educator is assigned to this course if not admin
    if current_user.role == "educator":
        if str(class_session["educator_id"]) != str(current_user.id):
            educator_course = db.client.table("course_educators")\
                .select("*")\
                .eq("course_id", str(class_session["course_id"]))\
                .eq("educator_id", str(current_user.id))\
                .execute()
            
            if not educator_course.data:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not authorized to create attendance sessions for this class"
                )
    
    # Check if there's already an active attendance session for this class
    active_session = db.client.table("attendance_sessions")\
        .select("*")\
        .eq("class_session_id", str(session_in.class_session_id))\
        .in_("status", ["pending", "active"])\
        .execute()
    
    if active_session.data:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="An active attendance session already exists for this class"
        )
    
    # Create attendance session
    now = datetime.now(pytz.UTC)
    attendance_session_data = {
        "class_session_id": str(session_in.class_session_id),
        "status": "active",
        "start_time": now.isoformat(),
        "created_by": str(current_user.id),
        "verification_method": session_in.verification_method
    }
    
    result = db.client.table("attendance_sessions").insert(attendance_session_data).execute()
    
    if not result.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create attendance session"
        )
    
    return result.data[0]

@router.get("/sessions", response_model=List[AttendanceSessionWithDetails])
async def read_attendance_sessions(
    course_id: UUID = None,
    class_session_id: UUID = None,
    status: str = None,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    db = get_db()
    
    # Build base query for attendance sessions
    query = db.client.table("attendance_sessions")\
        .select("*, class_sessions(*)")
    
    # Apply filters
    if class_session_id:
        query = query.eq("class_session_id", str(class_session_id))
    
    if status:
        query = query.eq("status", status)
    
    # Execute query
    sessions = query.execute()
    
    if not sessions.data:
        return []
    
    # Process results
    result = []
    for session in sessions.data:
        class_session = session["class_sessions"]
        
        # Filter by course_id if provided
        if course_id and str(class_session["course_id"]) != str(course_id):
            continue
        
        # Get course details
        course = db.client.table("courses")\
            .select("*")\
            .eq("id", class_session["course_id"])\
            .execute()
        
        # Get venue details
        venue = db.client.table("venues")\
            .select("*")\
            .eq("id", class_session["venue_id"])\
            .execute()
        
        # Get attendance count
        attendance_count = db.client.table("attendance_records")\
            .select("count")\
            .eq("attendance_session_id", session["id"])\
            .execute()
        
        count = attendance_count.count if hasattr(attendance_count, 'count') else 0
        
        # Build response object
        session_with_details = {
            **session,
            "class_session": class_session,
            "course": course.data[0] if course.data else {},
            "venue": venue.data[0] if venue.data else {},
            "attendance_count": count
        }
        
        result.append(session_with_details)
    
    return result

@router.get("/sessions/{session_id}", response_model=AttendanceSessionWithDetails)
async def read_attendance_session(
    session_id: UUID,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    db = get_db()
    
    # Get attendance session with class session details
    session = db.client.table("attendance_sessions")\
        .select("*, class_sessions(*)")\
        .eq("id", str(session_id))\
        .execute()
    
    if not session.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Attendance session not found"
        )
    
    session = session.data[0]
    class_session = session["class_sessions"]
    
    # Get course details
    course = db.client.table("courses")\
        .select("*")\
        .eq("id", class_session["course_id"])\
        .execute()
    
    # Get venue details
    venue = db.client.table("venues")\
        .select("*")\
        .eq("id", class_session["venue_id"])\
        .execute()
    
    # Get attendance count
    attendance_count = db.client.table("attendance_records")\
        .select("count")\
        .eq("attendance_session_id", session["id"])\
        .execute()
    
    count = attendance_count.count if hasattr(attendance_count, 'count') else 0
    
    # Build response object
    session_with_details = {
        **session,
        "class_session": class_session,
        "course": course.data[0] if course.data else {},
        "venue": venue.data[0] if venue.data else {},
        "attendance_count": count
    }
    
    return session_with_details

@router.put("/sessions/{session_id}/close", response_model=AttendanceSession)
async def close_attendance_session(
    session_id: UUID,
    current_user: UserInDB = Depends(get_current_educator)
) -> Any:
    db = get_db()
    
    # Get attendance session
    session = db.client.table("attendance_sessions")\
        .select("*, class_sessions(*)")\
        .eq("id", str(session_id))\
        .execute()
    
    if not session.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Attendance session not found"
        )
    
    session = session.data[0]
    class_session = session["class_sessions"]
    
    # Check if educator is authorized
    if current_user.role == "educator":
        if str(session["created_by"]) != str(current_user.id) and str(class_session["educator_id"]) != str(current_user.id):
            educator_course = db.client.table("course_educators")\
                .select("*")\
                .eq("course_id", str(class_session["course_id"]))\
                .eq("educator_id", str(current_user.id))\
                .execute()
            
            if not educator_course.data:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not authorized to close this attendance session"
                )
    
    # Check if session is already closed
    if session["status"] in ["closed", "expired"]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Attendance session is already {session['status']}"
        )
    
    # Close session
    now = datetime.now(pytz.UTC)
    update_data = {
        "status": "closed",
        "end_time": now.isoformat(),
        "updated_at": now.isoformat()
    }
    
    result = db.client.table("attendance_sessions")\
        .update(update_data)\
        .eq("id", str(session_id))\
        .execute()
    
    if not result.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to close attendance session"
        )
    
    return result.data[0]

@router.post("/records", response_model=AttendanceRecord)
async def mark_attendance(
    record_in: AttendanceRecordCreate,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    db = get_db()
    
    # Only students can mark their own attendance
    if current_user.role != "student":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only students can mark attendance"
        )
    
    # Get attendance session
    session = db.client.table("attendance_sessions")\
        .select("*, class_sessions(*)")\
        .eq("id", str(record_in.attendance_session_id))\
        .execute()
    
    if not session.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Attendance session not found"
        )
    
    session = session.data[0]
    class_session = session["class_sessions"]
    
    # Check if session is active
    if session["status"] != "active":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Attendance session is {session['status']}, not active"
        )
    
    # Check if student is enrolled in the course
    enrollment = db.client.table("course_students")\
        .select("*")\
        .eq("course_id", str(class_session["course_id"]))\
        .eq("student_id", str(current_user.id))\
        .execute()
    
    if not enrollment.data:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not enrolled in this course"
        )
    
    # Check if student already marked attendance
    existing_record = db.client.table("attendance_records")\
        .select("*")\
        .eq("attendance_session_id", str(record_in.attendance_session_id))\
        .eq("student_id", str(current_user.id))\
        .execute()
    
    if existing_record.data:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="You have already marked attendance for this session"
        )
    
    # Get venue for location verification
    venue = db.client.table("venues")\
        .select("*")\
        .eq("id", str(class_session["venue_id"]))\
        .execute()
    
    if not venue.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Venue information not found"
        )
    
    venue = venue.data[0]
    
    # Verify location
    from models.location import LocationVerification
    location_verification = LocationVerification(
        user_id=current_user.id,
        venue_id=venue["id"],
        latitude=record_in.latitude,
        longitude=record_in.longitude,
        accuracy=None,  # Optional
        is_within_geofence=False,  # Will be calculated
        distance=0.0  # Will be calculated
    )
    
    location_result = await verify_location(location_verification)
    
    # Check if student is within geofence
    if not location_result["is_within_geofence"]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"You are not within the classroom area. Distance: {location_result['distance']:.1f} meters from venue."
        )
    
    # Create attendance record
    now = datetime.now(pytz.UTC)
    attendance_record_data = {
        "attendance_session_id": str(record_in.attendance_session_id),
        "student_id": str(current_user.id),
        "status": "present",
        "marked_at": now.isoformat(),
        "latitude": record_in.latitude,
        "longitude": record_in.longitude,
        "verification_method": record_in.verification_method,
        "notes": record_in.notes
    }
    
    result = db.client.table("attendance_records").insert(attendance_record_data).execute()
    
    if not result.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to mark attendance"
        )
    
    # Log location
    location_log_data = {
        "user_id": str(current_user.id),
        "latitude": record_in.latitude,
        "longitude": record_in.longitude,
        "session_id": str(record_in.attendance_session_id)
    }
    
    db.client.table("location_logs").insert(location_log_data).execute()
    
    return result.data[0]

@router.get("/records", response_model=List[AttendanceRecordWithDetails])
async def read_attendance_records(
    session_id: UUID = None,
    student_id: UUID = None,
    status: str = None,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    db = get_db()
    
    # Build query
    query = db.client.table("attendance_records").select("*")
    
    # Apply filters
    if session_id:
        query = query.eq("attendance_session_id", str(session_id))
    
    if status:
        query = query.eq("status", status)
    
    # Students can only see their own records
    if current_user.role == "student":
        query = query.eq("student_id", str(current_user.id))
    elif student_id and (current_user.role == "educator" or current_user.role == "admin"):
        query = query.eq("student_id", str(student_id))
    
    # Execute query
    records = query.execute()
    
    if not records.data:
        return []
    
    # Get additional details for each record
    result = []
    for record in records.data:
        # Get student details
        student = db.client.table("users")\
            .select("id, first_name, last_name, email, student_id, profile_image_url")\
            .eq("id", record["student_id"])\
            .execute()
        
        # Get session details
        session = db.client.table("attendance_sessions")\
            .select("id, class_session_id, status, start_time, end_time")\
            .eq("id", record["attendance_session_id"])\
            .execute()
        
        # Build response object
        record_with_details = {
            **record,
            "student": student.data[0] if student.data else {},
            "session": session.data[0] if session.data else {}
        }
        
        result.append(record_with_details)
    
    return result

@router.put("/records/{record_id}", response_model=AttendanceRecord)
async def update_attendance_record(
    record_id: UUID,
    status: str,
    notes: str = None,
    current_user: UserInDB = Depends(get_current_educator)
) -> Any:
    db = get_db()
    
    # Get attendance record
    record = db.client.table("attendance_records")\
        .select("*, attendance_sessions(class_session_id)")\
        .eq("id", str(record_id))\
        .execute()
    
    if not record.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Attendance record not found"
        )
    
    record = record.data[0]
    
    # Get class session
    class_session = db.client.table("class_sessions")\
        .select("*")\
        .eq("id", record["attendance_sessions"]["class_session_id"])\
        .execute()
    
    if not class_session.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Class session not found"
        )
    
    class_session = class_session.data[0]
    
    # Check if educator is authorized
    if current_user.role == "educator":
        if str(class_session["educator_id"]) != str(current_user.id):
            educator_course = db.client.table("course_educators")\
                .select("*")\
                .eq("course_id", str(class_session["course_id"]))\
                .eq("educator_id", str(current_user.id))\
                .execute()
            
            if not educator_course.data:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not authorized to update this attendance record"
                )
    
    # Update record
    update_data = {
        "status": status,
        "verified_by": str(current_user.id),
        "updated_at": datetime.now(pytz.UTC).isoformat()
    }
    
    if notes:
        update_data["notes"] = notes
    
    result = db.client.table("attendance_records")\
        .update(update_data)\
        .eq("id", str(record_id))\
        .execute()
    
    if not result.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update attendance record"
        )
    
    return result.data[0]
