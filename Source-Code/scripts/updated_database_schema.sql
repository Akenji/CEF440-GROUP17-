-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- Create custom types
CREATE TYPE user_role AS ENUM ('student', 'lecturer', 'admin');
CREATE TYPE attendance_status AS ENUM ('present', 'absent', 'late', 'excused');
CREATE TYPE session_status AS ENUM ('scheduled', 'active', 'ended', 'cancelled');
CREATE TYPE enrollment_status AS ENUM ('active', 'dropped', 'completed', 'suspended');

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
    is_active BOOLEAN DEFAULT true,
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
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(faculty_id, code)
);

-- Students table (UPDATED)
CREATE TABLE public.students (
    id UUID REFERENCES public.users(id) PRIMARY KEY,
    matricule VARCHAR(20) NOT NULL UNIQUE,
    department_id UUID REFERENCES public.departments(id),
    level INTEGER NOT NULL CHECK (level >= 200),
    admission_year INTEGER NOT NULL,
    graduation_year INTEGER,
    current_semester INTEGER DEFAULT 1 CHECK (current_semester IN (1, 2)),
    current_academic_year VARCHAR(9) DEFAULT '2024-2025', -- e.g., "2024-2025"
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Lecturers table (UPDATED)
CREATE TABLE public.lecturers (
    id UUID REFERENCES public.users(id) PRIMARY KEY,
    employee_id VARCHAR(20) NOT NULL UNIQUE,
    department_id UUID REFERENCES public.departments(id),
    title VARCHAR(50), -- Dr., Prof., etc.
    specialization TEXT,
    hire_date DATE,
    office_location VARCHAR(100),
    office_hours TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Admins table (UPDATED)
CREATE TABLE public.admins (
    id UUID REFERENCES public.users(id) PRIMARY KEY,
    department_id UUID REFERENCES public.departments(id), -- NULL for system-wide admins
    admin_level VARCHAR(20) DEFAULT 'department', -- 'system', 'faculty', 'department'
    permissions JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Courses table (UPDATED)
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
    max_enrollment INTEGER DEFAULT 100, -- NEW: Maximum students allowed
    current_enrollment INTEGER DEFAULT 0, -- NEW: Current number of enrolled students
    enrollment_start_date TIMESTAMP WITH TIME ZONE, -- NEW: When enrollment opens
    enrollment_end_date TIMESTAMP WITH TIME ZONE, -- NEW: When enrollment closes
    course_start_date TIMESTAMP WITH TIME ZONE, -- NEW: When course starts
    course_end_date TIMESTAMP WITH TIME ZONE, -- NEW: When course ends
    prerequisites JSONB DEFAULT '[]', -- NEW: Array of prerequisite course IDs
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
    role VARCHAR(50) DEFAULT 'instructor', -- 'instructor', 'assistant', 'coordinator'
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(course_id, lecturer_id)
);

-- Course enrollments (students enrolled in courses) - UPDATED
CREATE TABLE public.course_enrollments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    student_id UUID REFERENCES public.students(id) ON DELETE CASCADE,
    status enrollment_status DEFAULT 'active', -- NEW: Enrollment status
    enrolled_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    dropped_at TIMESTAMP WITH TIME ZONE, -- NEW: When student dropped
    grade VARCHAR(5), -- NEW: Final grade (A, B, C, D, F)
    grade_points DECIMAL(3,2), -- NEW: Grade points (4.0, 3.7, etc.)
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(course_id, student_id)
);

-- NEW: Course Prerequisites table
CREATE TABLE public.course_prerequisites (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    prerequisite_course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    is_mandatory BOOLEAN DEFAULT true,
    minimum_grade VARCHAR(5) DEFAULT 'D', -- Minimum grade required in prerequisite
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(course_id, prerequisite_course_id)
);

-- Attendance sessions
CREATE TABLE public.attendance_sessions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    lecturer_id UUID REFERENCES public.lecturers(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    session_type VARCHAR(50) DEFAULT 'lecture', -- 'lecture', 'lab', 'tutorial', 'exam'
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
    auto_end_session BOOLEAN DEFAULT true, -- NEW: Auto-end session after scheduled time
    late_threshold_minutes INTEGER DEFAULT 15, -- NEW: Minutes after start time to mark as late
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Face data for students (UPDATED)
CREATE TABLE public.face_data (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    student_id UUID REFERENCES public.students(id) ON DELETE CASCADE UNIQUE,
    face_encoding BYTEA NOT NULL,
    face_image_url TEXT,
    confidence_threshold FLOAT DEFAULT 0.8,
    backup_encodings JSONB DEFAULT '[]', -- NEW: Multiple face encodings for better accuracy
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_verified BOOLEAN DEFAULT false, -- NEW: Whether face data has been verified
    verification_attempts INTEGER DEFAULT 0, -- NEW: Number of verification attempts
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Attendance records (UPDATED)
CREATE TABLE public.attendance_records (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    session_id UUID REFERENCES public.attendance_sessions(id) ON DELETE CASCADE,
    student_id UUID REFERENCES public.students(id) ON DELETE CASCADE,
    status attendance_status NOT NULL,
    marked_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    location_coordinates POINT,
    distance_from_session FLOAT, -- NEW: Distance in meters from session location
    face_confidence FLOAT,
    face_image_url TEXT, -- NEW: Store the face image used for verification
    device_info JSONB DEFAULT '{}', -- NEW: Device information for audit
    ip_address INET, -- NEW: IP address for audit
    is_manual_override BOOLEAN DEFAULT false,
    override_reason TEXT,
    override_by UUID REFERENCES public.users(id),
    verification_method VARCHAR(50) DEFAULT 'face_location', -- 'face_location', 'manual', 'qr_code'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(session_id, student_id)
);

-- NEW: Enrollment History table (for audit trail)
CREATE TABLE public.enrollment_history (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    enrollment_id UUID REFERENCES public.course_enrollments(id) ON DELETE CASCADE,
    student_id UUID REFERENCES public.students(id) ON DELETE CASCADE,
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
    action VARCHAR(50) NOT NULL, -- 'enrolled', 'dropped', 'suspended', 'reactivated'
    reason TEXT,
    performed_by UUID REFERENCES public.users(id),
    performed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    old_status enrollment_status,
    new_status enrollment_status
);

-- NEW: Academic Calendar table
CREATE TABLE public.academic_calendar (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    academic_year VARCHAR(9) NOT NULL, -- e.g., "2024-2025"
    semester INTEGER CHECK (semester IN (1, 2)),
    event_type VARCHAR(50) NOT NULL, -- 'enrollment_start', 'enrollment_end', 'semester_start', 'semester_end', 'exam_period'
    event_name VARCHAR(255) NOT NULL,
    event_date TIMESTAMP WITH TIME ZONE NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications table (UPDATED)
CREATE TABLE public.notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL, -- 'enrollment', 'attendance', 'grade', 'system', 'reminder'
    priority VARCHAR(20) DEFAULT 'normal', -- 'low', 'normal', 'high', 'urgent'
    data JSONB DEFAULT '{}',
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP WITH TIME ZONE,
    expires_at TIMESTAMP WITH TIME ZONE, -- NEW: When notification expires
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- NEW: System Settings table
CREATE TABLE public.system_settings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value JSONB NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT false, -- Whether setting can be read by non-admins
    updated_by UUID REFERENCES public.users(id),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_students_matricule ON public.students(matricule);
CREATE INDEX idx_students_department ON public.students(department_id);
CREATE INDEX idx_students_level ON public.students(level);
CREATE INDEX idx_students_academic_year ON public.students(current_academic_year);

CREATE INDEX idx_lecturers_department ON public.lecturers(department_id);
CREATE INDEX idx_lecturers_employee_id ON public.lecturers(employee_id);

CREATE INDEX idx_courses_department ON public.courses(department_id);
CREATE INDEX idx_courses_level ON public.courses(level);
CREATE INDEX idx_courses_academic_year ON public.courses(academic_year);
CREATE INDEX idx_courses_semester ON public.courses(semester);
CREATE INDEX idx_courses_active ON public.courses(is_active);

CREATE INDEX idx_course_enrollments_student ON public.course_enrollments(student_id);
CREATE INDEX idx_course_enrollments_course ON public.course_enrollments(course_id);
CREATE INDEX idx_course_enrollments_status ON public.course_enrollments(status);
CREATE INDEX idx_course_enrollments_active ON public.course_enrollments(is_active);

CREATE INDEX idx_attendance_sessions_course ON public.attendance_sessions(course_id);
CREATE INDEX idx_attendance_sessions_status ON public.attendance_sessions(status);
CREATE INDEX idx_attendance_sessions_date ON public.attendance_sessions(scheduled_start);

CREATE INDEX idx_attendance_records_session ON public.attendance_records(session_id);
CREATE INDEX idx_attendance_records_student ON public.attendance_records(student_id);
CREATE INDEX idx_attendance_records_status ON public.attendance_records(status);

CREATE INDEX idx_notifications_user ON public.notifications(user_id);
CREATE INDEX idx_notifications_type ON public.notifications(type);
CREATE INDEX idx_notifications_read ON public.notifications(is_read);

CREATE INDEX idx_face_data_student ON public.face_data(student_id);
CREATE INDEX idx_face_data_verified ON public.face_data(is_verified);

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
ALTER TABLE public.course_prerequisites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.face_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.enrollment_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.academic_calendar ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;

-- Enhanced RLS Policies

-- Users can read their own data
CREATE POLICY "Users can read own data" ON public.users
    FOR SELECT USING (auth.uid() = id);

-- Users can update their own data (except role)
CREATE POLICY "Users can update own data" ON public.users
    FOR UPDATE USING (auth.uid() = id);

-- Students can read their own data
CREATE POLICY "Students can read own data" ON public.students
    FOR SELECT USING (auth.uid() = id);

-- Students can update their own non-critical data
CREATE POLICY "Students can update own data" ON public.students
    FOR UPDATE USING (auth.uid() = id);

-- Lecturers can read their own data
CREATE POLICY "Lecturers can read own data" ON public.lecturers
    FOR SELECT USING (auth.uid() = id);

-- Lecturers can update their own data
CREATE POLICY "Lecturers can update own data" ON public.lecturers
    FOR UPDATE USING (auth.uid() = id);

-- Admins can read their own data
CREATE POLICY "Admins can read own data" ON public.admins
    FOR SELECT USING (auth.uid() = id);

-- Public read access to faculties and departments
CREATE POLICY "Public read faculties" ON public.faculties
    FOR SELECT USING (is_active = true);

CREATE POLICY "Public read departments" ON public.departments
    FOR SELECT USING (is_active = true);

-- Students and lecturers can read active courses
CREATE POLICY "Users can read active courses" ON public.courses
    FOR SELECT USING (is_active = true);

-- Students can read courses they're enrolled in or can enroll in
CREATE POLICY "Students can read available courses" ON public.courses
    FOR SELECT USING (
        is_active = true AND
        (enrollment_start_date IS NULL OR enrollment_start_date <= NOW()) AND
        (enrollment_end_date IS NULL OR enrollment_end_date >= NOW())
    );

-- Lecturers can read courses they're assigned to
CREATE POLICY "Lecturers can read assigned courses" ON public.courses
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.course_assignments ca
            WHERE ca.course_id = id AND ca.lecturer_id = auth.uid()
        )
    );

-- Students can manage their own enrollments
CREATE POLICY "Students can read own enrollments" ON public.course_enrollments
    FOR SELECT USING (auth.uid() = student_id);

CREATE POLICY "Students can insert own enrollments" ON public.course_enrollments
    FOR INSERT WITH CHECK (auth.uid() = student_id);

CREATE POLICY "Students can update own enrollments" ON public.course_enrollments
    FOR UPDATE USING (auth.uid() = student_id);

-- Students can read their attendance records
CREATE POLICY "Students can read own attendance" ON public.attendance_records
    FOR SELECT USING (auth.uid() = student_id);

-- Students can insert their attendance records
CREATE POLICY "Students can insert own attendance" ON public.attendance_records
    FOR INSERT WITH CHECK (auth.uid() = student_id);

-- Students can read/write their own face data
CREATE POLICY "Students can manage own face data" ON public.face_data
    FOR ALL USING (auth.uid() = student_id);

-- Students can read their own notifications
CREATE POLICY "Users can read own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

-- Students can update their own notifications (mark as read)
CREATE POLICY "Users can update own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- Public read access to academic calendar
CREATE POLICY "Public read academic calendar" ON public.academic_calendar
    FOR SELECT USING (is_active = true);

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

CREATE TRIGGER update_course_enrollments_updated_at BEFORE UPDATE ON public.course_enrollments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_attendance_sessions_updated_at BEFORE UPDATE ON public.attendance_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_face_data_updated_at BEFORE UPDATE ON public.face_data
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update course enrollment count
CREATE OR REPLACE FUNCTION update_course_enrollment_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.courses 
        SET current_enrollment = current_enrollment + 1 
        WHERE id = NEW.course_id;
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        -- If enrollment status changed from active to inactive
        IF OLD.is_active = true AND NEW.is_active = false THEN
            UPDATE public.courses 
            SET current_enrollment = current_enrollment - 1 
            WHERE id = NEW.course_id;
        -- If enrollment status changed from inactive to active
        ELSIF OLD.is_active = false AND NEW.is_active = true THEN
            UPDATE public.courses 
            SET current_enrollment = current_enrollment + 1 
            WHERE id = NEW.course_id;
        END IF;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.courses 
        SET current_enrollment = current_enrollment - 1 
        WHERE id = OLD.course_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

-- Trigger to automatically update enrollment counts
CREATE TRIGGER update_enrollment_count_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.course_enrollments
    FOR EACH ROW EXECUTE FUNCTION update_course_enrollment_count();

-- Function to log enrollment history
CREATE OR REPLACE FUNCTION log_enrollment_history()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO public.enrollment_history (
            enrollment_id, student_id, course_id, action, 
            new_status, performed_by
        ) VALUES (
            NEW.id, NEW.student_id, NEW.course_id, 'enrolled',
            NEW.status, NEW.student_id
        );
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.status != NEW.status THEN
            INSERT INTO public.enrollment_history (
                enrollment_id, student_id, course_id, action,
                old_status, new_status, performed_by
            ) VALUES (
                NEW.id, NEW.student_id, NEW.course_id, 
                CASE 
                    WHEN NEW.status = 'dropped' THEN 'dropped'
                    WHEN NEW.status = 'suspended' THEN 'suspended'
                    WHEN NEW.status = 'active' THEN 'reactivated'
                    ELSE 'updated'
                END,
                OLD.status, NEW.status, auth.uid()
            );
        END IF;
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

-- Trigger to log enrollment history
CREATE TRIGGER log_enrollment_history_trigger
    AFTER INSERT OR UPDATE ON public.course_enrollments
    FOR EACH ROW EXECUTE FUNCTION log_enrollment_history();
