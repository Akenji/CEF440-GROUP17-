-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- Create custom types
CREATE TYPE user_role AS ENUM ('student', 'lecturer', 'admin');
CREATE TYPE attendance_status AS ENUM ('present', 'absent', 'late', 'excused');
CREATE TYPE session_status AS ENUM ('scheduled', 'active', 'ended', 'cancelled');

-- Users table (extends Supabase auth.users)
CREATE TABLE public.users (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role user_role NOT NULL,
    avatar_url TEXT,
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Faculties table
CREATE TABLE public.faculties (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    code VARCHAR(10) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Departments table
CREATE TABLE public.departments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    faculty_id UUID REFERENCES public.faculties(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(faculty_id, code)
);

-- Students table
CREATE TABLE public.students (
    id UUID REFERENCES public.users(id) PRIMARY KEY,
    matricule VARCHAR(20) NOT NULL UNIQUE,
    department_id UUID REFERENCES public.departments(id),
    level INTEGER NOT NULL CHECK (level >= 200),
    admission_year INTEGER NOT NULL,
    graduation_year INTEGER,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Lecturers table
CREATE TABLE public.lecturers (
    id UUID REFERENCES public.users(id) PRIMARY KEY,
    employee_id VARCHAR(20) NOT NULL UNIQUE,
    department_id UUID REFERENCES public.departments(id),
    title VARCHAR(50),
    specialization TEXT,
    hire_date DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Admins table
CREATE TABLE public.admins (
    id UUID REFERENCES public.users(id) PRIMARY KEY,
    department_id UUID REFERENCES public.departments(id),
    permissions JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Courses table
CREATE TABLE public.courses (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    department_id UUID REFERENCES public.departments(id),
    code VARCHAR(20) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    credits INTEGER DEFAULT 3,
    level INTEGER NOT NULL CHECK (level >= 200),
    semester INTEGER CHECK (semester IN (1, 2)),
    academic_year VARCHAR(9) NOT NULL, -- e.g., "2023-2024"
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(department_id, code, academic_year)
);

-- Course assignments (lecturers assigned to courses)
CREATE TABLE public.course_assignments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    lecturer_id UUID REFERENCES public.lecturers(id) ON DELETE CASCADE,
    is_primary BOOLEAN DEFAULT false,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(course_id, lecturer_id)
);

-- Course enrollments (students enrolled in courses)
CREATE TABLE public.course_enrollments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    student_id UUID REFERENCES public.students(id) ON DELETE CASCADE,
    enrolled_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_active BOOLEAN DEFAULT true,
    UNIQUE(course_id, student_id)
);

-- Attendance sessions
CREATE TABLE public.attendance_sessions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    lecturer_id UUID REFERENCES public.lecturers(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    scheduled_start TIMESTAMP WITH TIME ZONE NOT NULL,
    scheduled_end TIMESTAMP WITH TIME ZONE NOT NULL,
    actual_start TIMESTAMP WITH TIME ZONE,
    actual_end TIMESTAMP WITH TIME ZONE,
    status session_status DEFAULT 'scheduled',
    location_name VARCHAR(255),
    location_coordinates POINT,
    geofence_radius INTEGER DEFAULT 100, -- meters
    require_geofence BOOLEAN DEFAULT true,
    require_face_recognition BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Face data for students
CREATE TABLE public.face_data (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    student_id UUID REFERENCES public.students(id) ON DELETE CASCADE UNIQUE,
    face_encoding BYTEA NOT NULL,
    face_image_url TEXT,
    confidence_threshold FLOAT DEFAULT 0.8,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Attendance records
CREATE TABLE public.attendance_records (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    session_id UUID REFERENCES public.attendance_sessions(id) ON DELETE CASCADE,
    student_id UUID REFERENCES public.students(id) ON DELETE CASCADE,
    status attendance_status NOT NULL,
    marked_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    location_coordinates POINT,
    face_confidence FLOAT,
    is_manual_override BOOLEAN DEFAULT false,
    override_reason TEXT,
    override_by UUID REFERENCES public.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(session_id, student_id)
);

-- Notifications table
CREATE TABLE public.notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    data JSONB DEFAULT '{}',
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_students_matricule ON public.students(matricule);
CREATE INDEX idx_students_department ON public.students(department_id);
CREATE INDEX idx_lecturers_department ON public.lecturers(department_id);
CREATE INDEX idx_courses_department ON public.courses(department_id);
CREATE INDEX idx_courses_level ON public.courses(level);
CREATE INDEX idx_attendance_sessions_course ON public.attendance_sessions(course_id);
CREATE INDEX idx_attendance_sessions_status ON public.attendance_sessions(status);
CREATE INDEX idx_attendance_records_session ON public.attendance_records(session_id);
CREATE INDEX idx_attendance_records_student ON public.attendance_records(student_id);
CREATE INDEX idx_notifications_user ON public.notifications(user_id);

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lecturers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.faculties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.face_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- RLS Policies
-- Users can read their own data
CREATE POLICY "Users can read own data" ON public.users
    FOR SELECT USING (auth.uid() = id);

-- Users can update their own data
CREATE POLICY "Users can update own data" ON public.users
    FOR UPDATE USING (auth.uid() = id);

-- Students can read their own data
CREATE POLICY "Students can read own data" ON public.students
    FOR SELECT USING (auth.uid() = id);

-- Lecturers can read their own data
CREATE POLICY "Lecturers can read own data" ON public.lecturers
    FOR SELECT USING (auth.uid() = id);

-- Students can read courses they're enrolled in
CREATE POLICY "Students can read enrolled courses" ON public.courses
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.course_enrollments ce
            WHERE ce.course_id = id AND ce.student_id = auth.uid()
        )
    );

-- Lecturers can read courses they're assigned to
CREATE POLICY "Lecturers can read assigned courses" ON public.courses
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.course_assignments ca
            WHERE ca.course_id = id AND ca.lecturer_id = auth.uid()
        )
    );

-- Students can read their attendance records
CREATE POLICY "Students can read own attendance" ON public.attendance_records
    FOR SELECT USING (auth.uid() = student_id);

-- Students can insert their attendance records
CREATE POLICY "Students can insert own attendance" ON public.attendance_records
    FOR INSERT WITH CHECK (auth.uid() = student_id);

-- Create functions and triggers for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_students_updated_at BEFORE UPDATE ON public.students
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_lecturers_updated_at BEFORE UPDATE ON public.lecturers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_courses_updated_at BEFORE UPDATE ON public.courses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_attendance_sessions_updated_at BEFORE UPDATE ON public.attendance_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
