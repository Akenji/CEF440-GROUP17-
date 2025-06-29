-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types
CREATE TYPE user_role AS ENUM ('student', 'lecturer', 'admin');
CREATE TYPE session_status AS ENUM ('scheduled', 'active', 'ended', 'cancelled');
CREATE TYPE attendance_status AS ENUM ('present', 'absent', 'late', 'excused');
CREATE TYPE enrollment_status AS ENUM ('active', 'dropped', 'completed', 'suspended');
CREATE TYPE notification_type AS ENUM ('enrollment', 'attendance', 'grade', 'system', 'reminder');
CREATE TYPE notification_priority AS ENUM ('low', 'normal', 'high', 'urgent');

-- Users table (main user accounts)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
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
CREATE TABLE faculties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    code VARCHAR(10) UNIQUE NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Departments table
CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    faculty_id UUID NOT NULL REFERENCES faculties(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(faculty_id, code)
);

-- Students table
CREATE TABLE students (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    matricule VARCHAR(50) UNIQUE NOT NULL,
    department_id UUID NOT NULL REFERENCES departments(id),
    level INTEGER NOT NULL CHECK (level IN (200, 300, 400, 500)),
    admission_year INTEGER NOT NULL,
    graduation_year INTEGER,
    current_semester INTEGER DEFAULT 1 CHECK (current_semester IN (1, 2)),
    current_academic_year VARCHAR(10) DEFAULT '2024-2025',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Lecturers table
CREATE TABLE lecturers (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    department_id UUID NOT NULL REFERENCES departments(id),
    title VARCHAR(50),
    specialization TEXT,
    hire_date DATE,
    office_location VARCHAR(255),
    office_hours TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Admins table
CREATE TABLE admins (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    department_id UUID REFERENCES departments(id),
    admin_level VARCHAR(20) DEFAULT 'department' CHECK (admin_level IN ('department', 'faculty', 'system')),
    permissions JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Courses table
CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    department_id UUID NOT NULL REFERENCES departments(id),
    code VARCHAR(20) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    credits INTEGER DEFAULT 3 CHECK (credits > 0),
    level INTEGER NOT NULL CHECK (level IN (200, 300, 400, 500)),
    semester INTEGER NOT NULL CHECK (semester IN (1, 2)),
    academic_year VARCHAR(10) NOT NULL,
    max_enrollment INTEGER DEFAULT 100,
    current_enrollment INTEGER DEFAULT 0,
    enrollment_start_date TIMESTAMP WITH TIME ZONE,
    enrollment_end_date TIMESTAMP WITH TIME ZONE,
    course_start_date TIMESTAMP WITH TIME ZONE,
    course_end_date TIMESTAMP WITH TIME ZONE,
    prerequisites TEXT[],
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(department_id, code, academic_year)
);

-- Course Prerequisites table
CREATE TABLE course_prerequisites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    prerequisite_course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    is_mandatory BOOLEAN DEFAULT true,
    minimum_grade VARCHAR(2) DEFAULT 'D',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(course_id, prerequisite_course_id)
);

-- Course Assignments (Lecturer-Course assignments)
CREATE TABLE course_assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    lecturer_id UUID NOT NULL REFERENCES lecturers(id) ON DELETE CASCADE,
    is_primary BOOLEAN DEFAULT false,
    role VARCHAR(20) DEFAULT 'instructor',
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(course_id, lecturer_id)
);

-- Course Enrollments table
CREATE TABLE course_enrollments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    status enrollment_status DEFAULT 'active',
    enrolled_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    dropped_at TIMESTAMP WITH TIME ZONE,
    grade VARCHAR(2),
    grade_points DECIMAL(3,2),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(course_id, student_id)
);

-- Enrollment History table
CREATE TABLE enrollment_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    enrollment_id UUID NOT NULL REFERENCES course_enrollments(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES students(id),
    course_id UUID NOT NULL REFERENCES courses(id),
    action VARCHAR(50) NOT NULL,
    reason TEXT,
    performed_by UUID REFERENCES users(id),
    performed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    old_status enrollment_status,
    new_status enrollment_status
);

-- Attendance Sessions table
CREATE TABLE attendance_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    lecturer_id UUID NOT NULL REFERENCES lecturers(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    session_type VARCHAR(50) DEFAULT 'lecture',
    scheduled_start TIMESTAMP WITH TIME ZONE NOT NULL,
    scheduled_end TIMESTAMP WITH TIME ZONE NOT NULL,
    actual_start TIMESTAMP WITH TIME ZONE,
    actual_end TIMESTAMP WITH TIME ZONE,
    status session_status DEFAULT 'scheduled',
    location_name VARCHAR(255),
    location_latitude DECIMAL(10, 8),
    location_longitude DECIMAL(11, 8),
    geofence_radius INTEGER DEFAULT 100,
    require_geofence BOOLEAN DEFAULT true,
    require_face_recognition BOOLEAN DEFAULT true,
    auto_end_session BOOLEAN DEFAULT true,
    late_threshold_minutes INTEGER DEFAULT 15,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Attendance Records table
CREATE TABLE attendance_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL REFERENCES attendance_sessions(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    status attendance_status NOT NULL,
    marked_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    location_latitude DECIMAL(10, 8),
    location_longitude DECIMAL(11, 8),
    distance_from_session DECIMAL(8, 2),
    face_confidence DECIMAL(4, 3),
    face_image_url TEXT,
    device_info JSONB DEFAULT '{}',
    ip_address INET,
    is_manual_override BOOLEAN DEFAULT false,
    override_reason TEXT,
    override_by UUID REFERENCES users(id),
    verification_method VARCHAR(50) DEFAULT 'face_location',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(session_id, student_id)
);

-- Face Data table
CREATE TABLE face_data (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    face_encoding INTEGER[] NOT NULL,
    face_image_url TEXT,
    confidence_threshold DECIMAL(4, 3) DEFAULT 0.8,
    backup_encodings INTEGER[][],
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_verified BOOLEAN DEFAULT false,
    verification_attempts INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(student_id)
);

-- Notifications table
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type notification_type NOT NULL,
    priority notification_priority DEFAULT 'normal',
    data JSONB DEFAULT '{}',
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP WITH TIME ZONE,
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- System Settings table
CREATE TABLE system_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    setting_key VARCHAR(255) UNIQUE NOT NULL,
    setting_value JSONB NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT false,
    updated_by UUID REFERENCES users(id),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Academic Calendar table
CREATE TABLE academic_calendar (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    academic_year VARCHAR(10) NOT NULL,
    semester INTEGER NOT NULL CHECK (semester IN (1, 2)),
    event_type VARCHAR(50) NOT NULL,
    event_name VARCHAR(255) NOT NULL,
    event_date DATE NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_students_matricule ON students(matricule);
CREATE INDEX idx_students_department ON students(department_id);
CREATE INDEX idx_lecturers_employee_id ON lecturers(employee_id);
CREATE INDEX idx_lecturers_department ON lecturers(department_id);
CREATE INDEX idx_courses_department ON courses(department_id);
CREATE INDEX idx_courses_level_semester ON courses(level, semester);
CREATE INDEX idx_course_enrollments_student ON course_enrollments(student_id);
CREATE INDEX idx_course_enrollments_course ON course_enrollments(course_id);
CREATE INDEX idx_attendance_sessions_course ON attendance_sessions(course_id);
CREATE INDEX idx_attendance_sessions_lecturer ON attendance_sessions(lecturer_id);
CREATE INDEX idx_attendance_sessions_status ON attendance_sessions(status);
CREATE INDEX idx_attendance_records_session ON attendance_records(session_id);
CREATE INDEX idx_attendance_records_student ON attendance_records(student_id);
CREATE INDEX idx_face_data_student ON face_data(student_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read) WHERE is_read = false;

-- Create functions for automatic timestamp updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- Create triggers for updated_at columns
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_faculties_updated_at BEFORE UPDATE ON faculties FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_departments_updated_at BEFORE UPDATE ON departments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_students_updated_at BEFORE UPDATE ON students FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lecturers_updated_at BEFORE UPDATE ON lecturers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_admins_updated_at BEFORE UPDATE ON admins FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_courses_updated_at BEFORE UPDATE ON courses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_course_enrollments_updated_at BEFORE UPDATE ON course_enrollments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_attendance_sessions_updated_at BEFORE UPDATE ON attendance_sessions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_face_data_updated_at BEFORE UPDATE ON face_data FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON notifications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_system_settings_updated_at BEFORE UPDATE ON system_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_academic_calendar_updated_at BEFORE UPDATE ON academic_calendar FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();