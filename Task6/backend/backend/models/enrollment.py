from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from uuid import UUID

class EnrollmentBase(BaseModel):
    course_id: UUID
    student_id: UUID
    status: str = "active"

class EnrollmentCreate(EnrollmentBase):
    pass

class EnrollmentUpdate(BaseModel):
    status: Optional[str] = None

class Enrollment(EnrollmentBase):
    id: UUID
    enrollment_date: datetime
    created_at: datetime
    updated_at: datetime

class EnrollmentWithCourse(Enrollment):
    course: dict = {}

class EnrollmentWithStudent(Enrollment):
    student: dict = {}
