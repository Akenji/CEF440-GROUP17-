from pydantic import BaseModel, EmailStr, validator
from typing import Optional, List
from datetime import datetime, date, time
from enum import Enum
import uuid

# Enums
class UserType(str, Enum):
    STUDENT = "student"
    EDUCATOR = "educator"
    ADMIN = "admin"

class AttendanceStatus(str, Enum):
    PRESENT = "present"
    ABSENT = "absent"
    LATE = "late"
    EXCUSED = "excused"

class SessionStatus(str, Enum):
    PENDING = "pending"
    ACTIVE = "active"
    CLOSED = "closed"
    EXPIRED = "expired"

class VerificationMethod(str, Enum):
    FACIAL_RECOGNITION = "facial_recognition"
    MANUAL = "manual"
    QR_CODE = "qr_code"
    NFC = "nfc"
    BIOMETRIC = "biometric"

# Base schemas
class BaseSchema(BaseModel):
    class Config:
        from_attributes = True

# User schemas
class UserBase(BaseSchema):
    email: EmailStr
    full_name: str
    user_type: UserType
    profile_image_url: Optional[str] = None
    phone: Optional[str] = None
    is_active: bool = True

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseSchema):
    full_name: Optional[str] = None
    profile_image_url: Optional[str] = None
    phone: Optional[str] = None
    is_active: Optional[bool] = None

class User(UserBase):
    id: uuid.UUID
    created_at: datetime
    updated_at: datetime

# Student schemas
class StudentBase(BaseSchema):
    student_id: str
    department_id: Optional[uuid.UUID] = None
    year: Optional[int] = None
    date_of_birth: Optional[date] = None
    gender: Optional[str] = None
    enrollment_date: Optional[date] = None
    device_id: Optional[str] = None

class StudentCreate(StudentBase):
    user: UserCreate

class Student(StudentBase):
    id: uuid.UUID
    user: User

# Venue schemas
class VenueBase(BaseSchema):
    name: str
    code: str
    building: str
    room_number: str
    capacity: int
    latitude: float
    longitude: float
    geofence_radius: float = 50.0
    description: Optional[str] = None
    facilities: Optional[dict] = None
    is_active: bool = True

class VenueCreate(VenueBase):
    pass

class Venue(VenueBase):
    id: uuid.UUID
    created_at: datetime
    updated_at: datetime

# Course schemas
class CourseBase(BaseSchema):
    name: str
    code: str
    description: Optional[str] = None
    credits: int = 3
    department_id: Optional[uuid.UUID] = None
    instructor_id: Optional[uuid.UUID] = None
    venue_id: Optional[uuid.UUID] = None
    capacity: int = 50
    level: Optional[str] = None
    semester: Optional[str] = None
    academic_year: Optional[str] = None
    is_active: bool = True

class CourseCreate(CourseBase):
    pass

class Course(CourseBase):
    id: uuid.UUID
    created_at: datetime
    updated_at: datetime

# Attendance Session schemas
class AttendanceSessionBase(BaseSchema):
    class_session_id: uuid.UUID
    course_id: uuid.UUID
    educator_id: uuid.UUID
    expires_at: Optional[datetime] = None
    requires_location: bool = True
    requires_facial_recognition: bool = False
    allow_late_marking: bool = True
    late_marking_grace_period: Optional[int] = 15
    settings: Optional[dict] = None
    notes: Optional[str] = None

class AttendanceSessionCreate(AttendanceSessionBase):
    pass

class AttendanceSession(AttendanceSessionBase):
    id: uuid.UUID
    status: SessionStatus
    start_time: datetime
    end_time: Optional[datetime] = None
    created_at: datetime
    updated_at: datetime

# Attendance Record schemas
class AttendanceRecordBase(BaseSchema):
    attendance_session_id: uuid.UUID
    student_id: uuid.UUID
    course_id: uuid.UUID
    attendance_date: date
    check_in_time: Optional[datetime] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    status: AttendanceStatus
    verification_method: Optional[VerificationMethod] = None
    distance_from_venue: Optional[float] = None
    override_reason: Optional[str] = None

class AttendanceRecordCreate(AttendanceRecordBase):
    pass

class AttendanceRecord(AttendanceRecordBase):
    id: uuid.UUID
    modified_by: Optional[uuid.UUID] = None
    created_at: datetime
    updated_at: datetime

# Location schemas
class LocationData(BaseSchema):
    latitude: float
    longitude: float
    accuracy: Optional[float] = None
    timestamp: datetime

class LocationValidation(BaseSchema):
    is_valid: bool
    distance: Optional[float] = None
    error: Optional[str] = None

# Authentication schemas
class Token(BaseSchema):
    access_token: str
    token_type: str
    expires_in: int
    user: User

class LoginRequest(BaseSchema):
    email: EmailStr
    password: str

# Response schemas
class AttendanceStats(BaseSchema):
    total_sessions: int
    present: int
    late: int
    absent: int
    attendance_rate: float

class ApiResponse(BaseSchema):
    success: bool
    message: str
    data: Optional[dict] = None
