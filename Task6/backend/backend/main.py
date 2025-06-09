from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from api.routes import auth, users, courses, attendance, locations
from core.config import settings

app = FastAPI(
    title="Classroom Attendance API",
    description="Backend API for the classroom attendance system",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(users.router, prefix="/api/users", tags=["Users"])
app.include_router(courses.router, prefix="/api/courses", tags=["Courses"])
app.include_router(attendance.router, prefix="/api/attendance", tags=["Attendance"])
app.include_router(locations.router, prefix="/api/locations", tags=["Locations"])

@app.get("/", tags=["Root"])
async def root():
    return {"message": "Welcome to the Classroom Attendance API"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
