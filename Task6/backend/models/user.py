from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import datetime
from uuid import UUID

class UserBase(BaseModel):
    email: EmailStr
    first_name: str
    last_name: str
    is_active: bool = True

class UserCreate(UserBase):
    password: str
    role: str
    department_id: Optional[UUID] = None
    student_id: Optional[str] = None

class UserUpdate(BaseModel):
    email: Optional[EmailStr] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    password: Optional[str] = None
    profile_image_url: Optional[str] = None
    is_active: Optional[bool] = None

class UserInDB(UserBase):
    id: UUID
    role: str
    department_id: Optional[UUID] = None
    student_id: Optional[str] = None
    profile_image_url: Optional[str] = None
    created_at: datetime
    updated_at: datetime

class User(UserBase):
    id: UUID
    role: str
    department_id: Optional[UUID] = None
    student_id: Optional[str] = None
    profile_image_url: Optional[str] = None

class UserWithCourses(User):
    courses: List = []

class TokenData(BaseModel):
    user_id: Optional[str] = None

class Token(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
