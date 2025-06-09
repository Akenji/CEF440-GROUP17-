from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from uuid import UUID

class CourseBase(BaseModel):
    code: str
    name: str
    description: Optional[str] = None
    department_id: UUID
    credits: int
    semester: str
    academic_year: str

class CourseCreate(CourseBase):
    pass

class CourseUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    credits: Optional[int] = None
    semester: Optional[str] = None
    academic_year: Optional[str] = None

class Course(CourseBase):
    id: UUID
    created_at: datetime
    updated_at: datetime

class CourseWithEducators(Course):
    educators: List = []

class CourseWithStudents(Course):
    students: List = []

class CourseWithSessions(Course):
    sessions: List = []
