from fastapi import APIRouter, Depends, HTTPException, status
from core.dependencies import get_current_user, get_current_educator, get_current_admin
from core.database import get_db
from models.course import CourseCreate, CourseUpdate, Course, CourseWithEducators, CourseWithStudents, CourseWithSessions
from models.user import UserInDB
from typing import Any, List, Optional
from uuid import UUID
import logging

# Set up logging for debugging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

router = APIRouter()

@router.post("/", response_model=Course)
async def create_course(
    course_in: CourseCreate,
    current_user: UserInDB = Depends(get_current_admin)
) -> Any:
    """
    Create a new course. Only admins can create courses.
    
    Args:
        course_in (CourseCreate): The course data to create.
        current_user (UserInDB): The authenticated admin user.
    
    Returns:
        Course: The created course.
    
    Raises:
        HTTPException: If course code exists or database error occurs.
    """
    db = get_db()
    
    logger.info(f"User {current_user.id} creating course with code {course_in.code}")
    
    try:
        # Check if course code already exists
        existing_course = db.client.table("courses").select("*").eq("code", course_in.code).execute()
        if existing_course.data:
            logger.warning(f"Course code {course_in.code} already exists")
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Course code already exists"
            )
        
        # Create course
        result = db.client.table("courses").insert(course_in.dict()).execute()
        
        if not result.data:
            logger.error("Failed to create course")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to create course"
            )
        
        logger.info(f"Course created successfully: {result.data[0]['id']}")
        return result.data[0]
    
    except Exception as e:
        logger.error(f"Database error while creating course: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error: {str(e)}"
        )

@router.get("/", response_model=List[Course])
async def read_courses(
    skip: int = 0,
    limit: int = 100,
    department_id: Optional[UUID] = None,
    semester: Optional[str] = None,
    academic_year: Optional[str] = None,
    student_id: Optional[UUID] = None,
    educator_id: Optional[UUID] = None,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    """
    Retrieve a list of courses with optional filters.
    
    Args:
        skip (int): Number of records to skip.
        limit (int): Maximum number of records to return.
        department_id (Optional[UUID]): Filter by department ID.
        semester (Optional[str]): Filter by semester.
        academic_year (Optional[str]): Filter by academic year.
        student_id (Optional[UUID]): Get courses for a specific student.
        educator_id (Optional[UUID]): Get courses for a specific educator.
        current_user (UserInDB): The authenticated user.
    
    Returns:
        List[Course]: List of courses matching the criteria.
    
    Raises:
        HTTPException: If unauthorized or database error occurs.
    """
    db = get_db()
    
    logger.info(f"User {current_user.id} fetching courses with filters: student_id={student_id}, educator_id={educator_id}")
    
    try:
        # If student_id is provided, get courses for that student
        if student_id:
            if current_user.role == "student" and str(current_user.id) != str(student_id):
                logger.warning(f"User {current_user.id} unauthorized to access student {student_id} courses")
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not authorized to access this student's courses"
                )
            
            student_courses = db.client.table("course_students")\
                .select("courses(*)")\
                .eq("student_id", str(student_id))\
                .eq("status", "active")\
                .execute()
            
            return [course["courses"] for course in student_courses.data] if student_courses.data else []
        
        # If educator_id is provided, get courses for that educator
        if educator_id:
            if current_user.role == "educator" and str(current_user.id) != str(educator_id):
                logger.warning(f"User {current_user.id} unauthorized to access educator {educator_id} courses")
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not authorized to access this educator's courses"
                )
            
            educator_courses = db.client.table("course_educators")\
                .select("courses(*)")\
                .eq("educator_id", str(educator_id))\
                .execute()
            
            return [course["courses"] for course in educator_courses.data] if educator_courses.data else []
        
        # Build query for general course listing
        query = db.client.table("courses").select("*").range(skip, skip + limit - 1)
        
        # Apply filters
        if department_id:
            query = query.eq("department_id", str(department_id))
        if semester:
            query = query.eq("semester", semester)
        if academic_year:
            query = query.eq("academic_year", academic_year)
        
        courses = query.execute()
        
        logger.info(f"Retrieved {len(courses.data or [])} courses")
        return courses.data if courses.data else []
    
    except Exception as e:
        logger.error(f"Database error while fetching courses: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error: {str(e)}"
        )

@router.get("/available", response_model=List[Course])
async def read_available_courses(
    skip: int = 0,
    limit: int = 100,
    department_id: Optional[UUID] = None,
    semester: Optional[str] = None,
    academic_year: Optional[str] = None,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    """
    Get courses available for enrollment (not already enrolled by current user).
    
    Args:
        skip (int): Number of records to skip.
        limit (int): Maximum number of records to return.
        department_id (Optional[UUID]): Filter by department ID.
        semester (Optional[str]): Filter by semester.
        academic_year (Optional[str]): Filter by academic year.
        current_user (UserInDB): The authenticated user.
    
    Returns:
        List[Course]: List of available courses.
    
    Raises:
        HTTPException: If database error occurs.
    """
    db = get_db()
    
    logger.info(f"User {current_user.id} fetching available courses")
    
    try:
        query = db.client.table("courses").select("*").range(skip, skip + limit - 1)
        
        if department_id:
            query = query.eq("department_id", str(department_id))
        if semester:
            query = query.eq("semester", semester)
        if academic_year:
            query = query.eq("academic_year", academic_year)
        
        all_courses = query.execute()
        
        if not all_courses.data:
            logger.info("No courses found")
            return []
        
        enrolled_courses = db.client.table("course_students")\
            .select("course_id")\
            .eq("student_id", str(current_user.id))\
            .eq("status", "active")\
            .execute()
        
        enrolled_course_ids = {course["course_id"] for course in enrolled_courses.data} if enrolled_courses.data else set()
        
        available_courses = [
            course for course in all_courses.data 
            if course["id"] not in enrolled_course_ids
        ]
        
        logger.info(f"Retrieved {len(available_courses)} available courses")
        return available_courses
    
    except Exception as e:
        logger.error(f"Database error while fetching available courses: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error: {str(e)}"
        )

@router.get("/{course_id}", response_model=Course)
async def read_course(
    course_id: UUID,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    """
    Retrieve a specific course by ID.
    
    Args:
        course_id (UUID): The UUID of the course.
        current_user (UserInDB): The authenticated user.
    
    Returns:
        Course: The course details.
    
    Raises:
        HTTPException: If course not found or database error occurs.
    """
    db = get_db()
    
    logger.info(f"User {current_user.id} fetching course {course_id}")
    
    try:
        course = db.client.table("courses").select("*").eq("id", str(course_id)).execute()
        
        if not course.data:
            logger.warning(f"Course {course_id} not found")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Course not found"
            )
        
        return course.data[0]
    
    except Exception as e:
        logger.error(f"Database error while fetching course {course_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error: {str(e)}"
        )

@router.put("/{course_id}", response_model=Course)
async def update_course(
    course_id: UUID,
    course_in: CourseUpdate,
    current_user: UserInDB = Depends(get_current_admin)
) -> Any:
    """
    Update a course. Only admins can update courses.
    
    Args:
        course_id (UUID): The UUID of the course.
        course_in (CourseUpdate): The updated course data.
        current_user (UserInDB): The authenticated admin user.
    
    Returns:
        Course: The updated course.
    
    Raises:
        HTTPException: If course not found or database error occurs.
    """
    db = get_db()
    
    logger.info(f"User {current_user.id} updating course {course_id}")
    
    try:
        course = db.client.table("courses").select("*").eq("id", str(course_id)).execute()
        if not course.data:
            logger.warning(f"Course {course_id} not found")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Course not found"
            )
        
        update_data = course_in.dict(exclude_unset=True)
        result = db.client.table("courses").update(update_data).eq("id", str(course_id)).execute()
        
        if not result.data:
            logger.error(f"Failed to update course {course_id}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to update course"
            )
        
        logger.info(f"Course {course_id} updated successfully")
        return result.data[0]
    
    except Exception as e:
        logger.error(f"Database error while updating course {course_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error: {str(e)}"
        )

@router.delete("/{course_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_course(
    course_id: UUID,
    current_user: UserInDB = Depends(get_current_admin)
) -> None:
    """
    Delete a course. Only admins can delete courses.
    
    Args:
        course_id (UUID): The UUID of the course.
        current_user (UserInDB): The authenticated admin user.
    
    Raises:
        HTTPException: If course not found or database error occurs.
    """
    db = get_db()
    
    logger.info(f"User {current_user.id} deleting course {course_id}")
    
    try:
        course = db.client.table("courses").select("id").eq("id", str(course_id)).execute()
        if not course.data:
            logger.warning(f"Course {course_id} not found")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Course not found"
            )
        
        # Delete related records (cascade)
        db.client.table("course_students").delete().eq("course_id", str(course_id)).execute()
        db.client.table("course_educators").delete().eq("course_id", str(course_id)).execute()
        
        # Delete course
        db.client.table("courses").delete().eq("id", str(course_id)).execute()
        
        logger.info(f"Course {course_id} deleted successfully")
    
    except Exception as e:
        logger.error(f"Database error while deleting course {course_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error: {str(e)}"
        )

@router.post("/{course_id}/enroll", response_model=dict, status_code=status.HTTP_201_CREATED)
async def enroll_in_course(
    course_id: UUID,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    """
    Enroll the current user (student) in a course.
    
    Args:
        course_id (UUID): The UUID of the course.
        current_user (UserInDB): The authenticated user.
    
    Returns:
        dict: A success message.
    
    Raises:
        HTTPException: If user is not a student, course not found, already enrolled, or database error.
    """
    db = get_db()
    
    logger.info(f"User {current_user.id} enrolling in course {course_id}")
    
    try:
        if current_user.role != "student":
            logger.warning(f"User {current_user.id} is not a student, role: {current_user.role}")
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only students can enroll in courses"
            )
        
        course = db.client.table("courses").select("id").eq("id", str(course_id)).execute()
        if not course.data:
            logger.warning(f"Course {course_id} not found")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Course not found"
            )
        
        enrollment = db.client.table("course_students")\
            .select("*")\
            .eq("course_id", str(course_id))\
            .eq("student_id", str(current_user.id))\
            .execute()
        
        if enrollment.data:
            if enrollment.data[0]["status"] == "active":
                logger.warning(f"User {current_user.id} already enrolled in course {course_id}")
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Already enrolled in this course"
                )
            else:
                db.client.table("course_students")\
                    .update({"status": "active"})\
                    .eq("course_id", str(course_id))\
                    .eq("student_id", str(current_user.id))\
                    .execute()
                logger.info(f"Enrollment reactivated for user {current_user.id} in course {course_id}")
                return {"message": "Enrollment reactivated successfully"}
        
        enrollment_data = {
            "course_id": str(course_id),
            "student_id": str(current_user.id),
            "status": "active"
        }
        
        result = db.client.table("course_students").insert(enrollment_data).execute()
        
        if not result.data:
            logger.error(f"Failed to enroll user {current_user.id} in course {course_id}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to enroll in course"
            )
        
        logger.info(f"User {current_user.id} enrolled in course {course_id}")
        return {"message": "Enrolled successfully"}
    
    except Exception as e:
        logger.error(f"Database error while enrolling user {current_user.id} in course {course_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error: {str(e)}"
        )

@router.delete("/{course_id}/enroll", status_code=status.HTTP_204_NO_CONTENT)
async def unenroll_from_course(
    course_id: UUID,
    current_user: UserInDB = Depends(get_current_user)
) -> None:
    """
    Unenroll the current user (student) from a course by updating the enrollment status to 'inactive'.
    
    Args:
        course_id (UUID): The UUID of the course.
        current_user (UserInDB): The authenticated user.
    
    Raises:
        HTTPException: If user is not a student, not enrolled, or database error occurs.
    """
    db = get_db()
    
    logger.info(f"User {current_user.id} attempting to unenroll from course {course_id}")
    
    try:
        if current_user.role != "student":
            logger.warning(f"User {current_user.id} is not a student, role: {current_user.role}")
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only students can unenroll from courses"
            )
        
        course = db.client.table("courses").select("id").eq("id", str(course_id)).execute()
        if not course.data:
            logger.warning(f"Course {course_id} not found")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Course not found"
            )
        
        enrollment = db.client.table("course_students")\
            .select("*")\
            .eq("course_id", str(course_id))\
            .eq("student_id", str(current_user.id))\
            .eq("status", "active")\
            .execute()
        
        if not enrollment.data:
            logger.warning(f"User {current_user.id} not enrolled in course {course_id}")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Not enrolled in this course"
            )
        
        db.client.table("course_students")\
            .update({"status": "inactive"})\
            .eq("course_id", str(course_id))\
            .eq("student_id", str(current_user.id))\
            .execute()
        
        logger.info(f"User {current_user.id} successfully unenrolled from course {course_id}")
    
    except Exception as e:
        logger.error(f"Database error while unenrolling user {current_user.id} from course {course_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error: {str(e)}"
        )

@router.get("/{course_id}/educators", response_model=CourseWithEducators)
async def read_course_educators(
    course_id: UUID,
    current_user: UserInDB = Depends(get_current_user)
) -> Any:
    """
    Retrieve educators assigned to a course.
    
    Args:
        course_id (UUID): The UUID of the course.
        current_user (UserInDB): The authenticated user.
    
    Returns:
        CourseWithEducators: Course details with list of educators.
    
    Raises:
        HTTPException: If course not found or database error occurs.
    """
    db = get_db()
    
    logger.info(f"User {current_user.id} fetching educators for course {course_id}")
    
    try:
        course = db.client.table("courses").select("*").eq("id", str(course_id)).execute()
        if not course.data:
            logger.warning(f"Course {course_id} not found")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Course not found"
            )
        
        educators = db.client.table("course_educators")\
            .select("users(*), is_primary")\
            .eq("course_id", str(course_id))\
            .execute()
        
        course_with_educators = course.data[0]
        course_with_educators["educators"] = [
            {**educator["users"], "is_primary": educator["is_primary"]} 
            for educator in educators.data
        ] if educators.data else []
        
        logger.info(f"Retrieved {len(course_with_educators['educators'])} educators for course {course_id}")
        return course_with_educators
    
    except Exception as e:
        logger.error(f"Database error while fetching educators for course {course_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error: {str(e)}"
        )

@router.get("/{course_id}/students", response_model=CourseWithStudents)
async def read_course_students(
    course_id: UUID,
    current_user: UserInDB = Depends(get_current_educator)
) -> Any:
    """
    Retrieve students enrolled in a course. Only educators or admins can access.
    
    Args:
        course_id (UUID): The UUID of the course.
        current_user (UserInDB): The authenticated educator or admin.
    
    Returns:
        CourseWithStudents: Course details with list of students.
    
    Raises:
        HTTPException: If unauthorized, course not found, or database error occurs.
    """
    db = get_db()
    
    logger.info(f"User {current_user.id} fetching students for course {course_id}")
    
    try:
        if current_user.role == "educator":
            educator_course = db.client.table("course_educators")\
                .select("*")\
                .eq("course_id", str(course_id))\
                .eq("educator_id", str(current_user.id))\
                .execute()
            
            if not educator_course.data:
                logger.warning(f"User {current_user.id} not authorized for course {course_id}")
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not authorized to access this course"
                )
        
        course = db.client.table("courses").select("*").eq("id", str(course_id)).execute()
        if not course.data:
            logger.warning(f"Course {course_id} not found")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Course not found"
            )
        
        students = db.client.table("course_students")\
            .select("users(*), enrollment_date, status")\
            .eq("course_id", str(course_id))\
            .eq("status", "active")\
            .execute()
        
        course_with_students = course.data[0]
        course_with_students["students"] = [
            {
                **student["users"],
                "enrollment_date": student["enrollment_date"],
                "status": student["status"]
            }
            for student in students.data
        ] if students.data else []
        
        logger.info(f"Retrieved {len(course_with_students['students'])} students for course {course_id}")
        return course_with_students
    
    except Exception as e:
        logger.error(f"Database error while fetching students for course {course_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error: {str(e)}"
        )