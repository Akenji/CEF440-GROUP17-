-- Insert sample faculties
INSERT INTO public.faculties (name, code, description) VALUES
('Faculty of Science', 'SCI', 'Faculty of Science and Technology'),
('Faculty of Arts', 'ART', 'Faculty of Arts and Humanities'),
('Faculty of Engineering', 'ENG', 'Faculty of Engineering'),
('Faculty of Medicine', 'MED', 'Faculty of Medicine and Health Sciences');

-- Insert sample departments
INSERT INTO public.departments (faculty_id, name, code, description) VALUES
((SELECT id FROM public.faculties WHERE code = 'SCI'), 'Computer Science', 'CS', 'Department of Computer Science'),
((SELECT id FROM public.faculties WHERE code = 'SCI'), 'Mathematics', 'MATH', 'Department of Mathematics'),
((SELECT id FROM public.faculties WHERE code = 'SCI'), 'Physics', 'PHYS', 'Department of Physics'),
((SELECT id FROM public.faculties WHERE code = 'ENG'), 'Software Engineering', 'SE', 'Department of Software Engineering'),
((SELECT id FROM public.faculties WHERE code = 'ENG'), 'Electrical Engineering', 'EE', 'Department of Electrical Engineering'),
((SELECT id FROM public.faculties WHERE code = 'ART'), 'English Literature', 'ENG', 'Department of English Literature');

-- Insert sample courses with enrollment limits and dates
INSERT INTO public.courses (
    department_id, code, title, description, credits, level, semester, 
    academic_year, max_enrollment, enrollment_start_date, enrollment_end_date,
    course_start_date, course_end_date
) VALUES
-- Computer Science Courses
((SELECT id FROM public.departments WHERE code = 'CS'), 'CS201', 'Data Structures', 'Introduction to Data Structures and Algorithms', 3, 200, 1, '2024-2025', 50, '2024-08-01', '2024-08-31', '2024-09-01', '2024-12-15'),
((SELECT id FROM public.departments WHERE code = 'CS'), 'CS202', 'Database Systems', 'Introduction to Database Management Systems', 3, 200, 2, '2024-2025', 45, '2024-12-01', '2024-12-31', '2025-01-15', '2025-05-15'),
((SELECT id FROM public.departments WHERE code = 'CS'), 'CS301', 'Software Engineering', 'Principles of Software Engineering', 4, 300, 1, '2024-2025', 40, '2024-08-01', '2024-08-31', '2024-09-01', '2024-12-15'),
((SELECT id FROM public.departments WHERE code = 'CS'), 'CS302', 'Computer Networks', 'Introduction to Computer Networks', 3, 300, 2, '2024-2025', 35, '2024-12-01', '2024-12-31', '2025-01-15', '2025-05-15'),
((SELECT id FROM public.departments WHERE code = 'CS'), 'CS401', 'Machine Learning', 'Introduction to Machine Learning', 4, 400, 1, '2024-2025', 30, '2024-08-01', '2024-08-31', '2024-09-01', '2024-12-15'),

-- Software Engineering Courses
((SELECT id FROM public.departments WHERE code = 'SE'), 'SE201', 'Programming Fundamentals', 'Basic Programming Concepts', 3, 200, 1, '2024-2025', 60, '2024-08-01', '2024-08-31', '2024-09-01', '2024-12-15'),
((SELECT id FROM public.departments WHERE code = 'SE'), 'SE301', 'Web Development', 'Full-Stack Web Development', 4, 300, 1, '2024-2025', 40, '2024-08-01', '2024-08-31', '2024-09-01', '2024-12-15'),

-- Mathematics Courses
((SELECT id FROM public.departments WHERE code = 'MATH'), 'MATH201', 'Calculus I', 'Differential and Integral Calculus', 4, 200, 1, '2024-2025', 80, '2024-08-01', '2024-08-31', '2024-09-01', '2024-12-15'),
((SELECT id FROM public.departments WHERE code = 'MATH'), 'MATH202', 'Calculus II', 'Advanced Calculus', 4, 200, 2, '2024-2025', 70, '2024-12-01', '2024-12-31', '2025-01-15', '2025-05-15');

-- Insert course prerequisites
INSERT INTO public.course_prerequisites (course_id, prerequisite_course_id, is_mandatory, minimum_grade) VALUES
-- CS301 requires CS201
((SELECT id FROM public.courses WHERE code = 'CS301'), (SELECT id FROM public.courses WHERE code = 'CS201'), true, 'C'),
-- CS302 requires CS201
((SELECT id FROM public.courses WHERE code = 'CS302'), (SELECT id FROM public.courses WHERE code = 'CS201'), true, 'C'),
-- CS401 requires CS301
((SELECT id FROM public.courses WHERE code = 'CS401'), (SELECT id FROM public.courses WHERE code = 'CS301'), true, 'B'),
-- MATH202 requires MATH201
((SELECT id FROM public.courses WHERE code = 'MATH202'), (SELECT id FROM public.courses WHERE code = 'MATH201'), true, 'C');

-- Insert academic calendar events
INSERT INTO public.academic_calendar (academic_year, semester, event_type, event_name, event_date, description) VALUES
('2024-2025', 1, 'enrollment_start', 'First Semester Enrollment Opens', '2024-08-01 00:00:00+00', 'Students can begin enrolling in first semester courses'),
('2024-2025', 1, 'enrollment_end', 'First Semester Enrollment Closes', '2024-08-31 23:59:59+00', 'Last day to enroll in first semester courses'),
('2024-2025', 1, 'semester_start', 'First Semester Begins', '2024-09-01 00:00:00+00', 'First semester classes begin'),
('2024-2025', 1, 'semester_end', 'First Semester Ends', '2024-12-15 23:59:59+00', 'First semester classes end'),
('2024-2025', 2, 'enrollment_start', 'Second Semester Enrollment Opens', '2024-12-01 00:00:00+00', 'Students can begin enrolling in second semester courses'),
('2024-2025', 2, 'enrollment_end', 'Second Semester Enrollment Closes', '2024-12-31 23:59:59+00', 'Last day to enroll in second semester courses'),
('2024-2025', 2, 'semester_start', 'Second Semester Begins', '2025-01-15 00:00:00+00', 'Second semester classes begin'),
('2024-2025', 2, 'semester_end', 'Second Semester Ends', '2025-05-15 23:59:59+00', 'Second semester classes end');

-- Insert system settings
INSERT INTO public.system_settings (setting_key, setting_value, description, is_public) VALUES
('enrollment_settings', '{"max_courses_per_semester": 8, "min_credits_per_semester": 12, "max_credits_per_semester": 21}', 'General enrollment limits and rules', true),
('attendance_settings', '{"geofence_radius": 100, "face_confidence_threshold": 0.8, "late_threshold_minutes": 15}', 'Attendance system configuration', true),
('academic_year', '{"current": "2024-2025", "next": "2025-2026"}', 'Current and next academic year', true),
('notification_settings', '{"send_enrollment_reminders": true, "send_attendance_alerts": true, "reminder_days_before": 3}', 'Notification preferences', false);
