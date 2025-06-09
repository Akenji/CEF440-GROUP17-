from fastapi import APIRouter, Depends, HTTPException, status
from core.dependencies import get_current_user, get_current_admin
from core.database import get_db
from models.user import User, UserUpdate, UserInDB, UserWithCourses
from typing import Any, List
from uuid import UUID

router = APIRouter()

@router.get("/me", response_model=User)
async def read_users_me(current_user: UserInDB = Depends(get_current_user)) -> Any:
    return current_user

@router.put("/me", response_model=User)
async def update_user_me(
    user_in: UserUpdate,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    db = get_db()
    
    update_data = user_in.dict(exclude_unset=True)
    
    # Hash password if it's being updated
    if "password" in update_data and update_data["password"]:
        from core.security import get_password_hash
        update_data["password"] = get_password_hash(update_data["password"])
    
    # Update user
    result = db.client.table("users").update(update_data).eq("id", current_user.id).execute()
    
    if not result.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update user"
        )
    
    return result.data[0]

@router.get("/me/courses", response_model=UserWithCourses)
async def read_user_courses(current_user: UserInDB = Depends(get_current_user)) -> Any:
    db = get_db()
    
    if current_user.role == "student":
        # Get courses for student
        courses = db.client.table("course_students")\
            .select("courses(*)")\
            .eq("student_id", current_user.id)\
            .execute()
        
        courses_data = [course["courses"] for course in courses.data] if courses.data else []
        
    elif current_user.role == "educator":
        # Get courses for educator
        courses = db.client.table("course_educators")\
            .select("courses(*)")\
            .eq("educator_id", current_user.id)\
            .execute()
        
        courses_data = [course["courses"] for course in courses.data] if courses.data else []
    
    else:  # Admin
        # Get all courses
        courses = db.client.table("courses").select("*").execute()
        courses_data = courses.data if courses.data else []
    
    # Return user with courses
    user_with_courses = current_user.dict()
    user_with_courses["courses"] = courses_data
    
    return user_with_courses

@router.get("/{user_id}", response_model=User)
async def read_user(
    user_id: UUID,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    # Only admins can view other users, or users viewing themselves
    if current_user.role != "admin" and str(current_user.id) != str(user_id):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    db = get_db()
    user = db.client.table("users").select("*").eq("id", str(user_id)).execute()
    
    if not user.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    return user.data[0]

@router.get("/", response_model=List[User])
async def read_users(
    skip: int = 0,
    limit: int = 100,
    role: str = None,
    current_user: UserInDB = Depends(get_current_admin)
) -> Any:
    db = get_db()
    
    # Build query
    query = db.client.table("users").select("*").range(skip, skip + limit - 1)
    
    # Filter by role if provided
    if role:
        query = query.eq("role", role)
    
    # Execute query
    users = query.execute()
    
    return users.data if users.data else []
