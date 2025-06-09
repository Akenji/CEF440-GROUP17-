from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from uuid import UUID

class ClassSessionBase(BaseModel):
    course_id: UUID
    venue_id: UUID
    educator_id: UUID
    title: str
    description: Optional[str] = None
    start_time: datetime
    end_time: datetime
    is_recurring: bool = False
    recurrence_pattern: Optional[str] = None

class ClassSessionCreate(ClassSessionBase):
    pass

class ClassSessionUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    venue_id: Optional[UUID] = None
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None
    is_recurring: Optional[bool] = None
    recurrence_pattern: Optional[str] = None

class ClassSession(ClassSessionBase):
    id: UUID
    created_at: datetime
    updated_at: datetime

class AttendanceSessionBase(BaseModel):
    class_session_id: UUID
    status: str
    start_time: datetime
    end_time: Optional[datetime] = None
    created_by: UUID
    verification_method: str

class AttendanceSessionCreate(BaseModel):
    class_session_id: UUID
    verification_method: str = "geolocation"

class AttendanceSessionUpdate(BaseModel):
    status: Optional[str] = None
    end_time: Optional[datetime] = None

class AttendanceSession(AttendanceSessionBase):
    id: UUID
    created_at: datetime
    updated_at: datetime

class AttendanceSessionWithDetails(AttendanceSession):
    class_session: ClassSession
    venue: dict
    course: dict
    attendance_count: int = 0

class AttendanceRecordBase(BaseModel):
    attendance_session_id: UUID
    student_id: UUID
    status: str
    marked_at: datetime
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    verification_method: str
    verified_by: Optional[UUID] = None
    notes: Optional[str] = None

class AttendanceRecordCreate(BaseModel):
    attendance_session_id: UUID
    latitude: float
    longitude: float
    verification_method: str = "geolocation"
    notes: Optional[str] = None

class AttendanceRecordUpdate(BaseModel):
    status: Optional[str] = None
    notes: Optional[str] = None
    verified_by: Optional[UUID] = None

class AttendanceRecord(AttendanceRecordBase):
    id: UUID
    created_at: datetime
    updated_at: datetime

class AttendanceRecordWithDetails(AttendanceRecord):
    student: dict
    session: dict
