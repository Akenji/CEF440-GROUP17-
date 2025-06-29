
-- Insert realistic data for the University of Buea, Cameroon
WITH inserted_users AS (
    INSERT INTO users (email, full_name, role, phone) VALUES
    ('admin.system@ubuea.cm', 'System Admin', 'admin', '+237677123456'),
    ('lecturer.science@ubuea.cm', 'Dr. John Doe', 'lecturer', '+237677234567'),
    ('lecturer.arts@ubuea.cm', 'Prof. Jane Smith', 'lecturer', '+237677345678'),
    ('student.cs@ubuea.cm', 'Paul Eko', 'student', '+237677456789'),
    ('student.law@ubuea.cm', 'Mary Nji', 'student', '+237677567890'),
    ('student.physics@ubuea.cm', 'Sarah Obi', 'student', '+237677678901'),
    ('student.english@ubuea.cm', 'David Nkeng', 'student', '+237677789012')
    RETURNING id, email, role, full_name
),
inserted_faculties AS (
    INSERT INTO faculties (name, code, description) VALUES
    ('Faculty of Science', 'FS', 'Promoting scientific research and education.'),
    ('Faculty of Arts', 'FA', 'Fostering excellence in humanities and arts.'),
    ('Faculty of Social and Management Sciences', 'FSMS', 'Developing leaders in social and management fields.'),
    ('Faculty of Education', 'FE', 'Training educators for the future.'),
    ('Faculty of Health Sciences', 'FHS', 'Advancing health through education and research.'),
    ('Faculty of Agriculture and Veterinary Medicine', 'FAVM', 'Innovating in agriculture and veterinary science.')
    RETURNING id, code
),
inserted_departments AS (
    INSERT INTO departments (faculty_id, name, code, description)
    SELECT
        f.id,
        CASE
            WHEN f.code = 'FS' THEN d_fs.name
            WHEN f.code = 'FA' THEN d_fa.name
            WHEN f.code = 'FSMS' THEN d_fsms.name
            ELSE NULL
        END,
        CASE
            WHEN f.code = 'FS' THEN d_fs.code
            WHEN f.code = 'FA' THEN d_fa.code
            WHEN f.code = 'FSMS' THEN d_fsms.code
            ELSE NULL
        END,
        CASE
            WHEN f.code = 'FS' THEN d_fs.description
            WHEN f.code = 'FA' THEN d_fa.description
            WHEN f.code = 'FSMS' THEN d_fsms.description
            ELSE NULL
        END
    FROM inserted_faculties f
    LEFT JOIN (
        VALUES
        ('Computer Science', 'CS', 'Department of Computer Science'),
        ('Physics', 'PHY', 'Department of Physics'),
        ('Chemistry', 'CHM', 'Department of Chemistry')
    ) AS d_fs(name, code, description) ON f.code = 'FS'
    LEFT JOIN (
        VALUES
        ('English', 'ENG', 'Department of English Language and Literature'),
        ('Law', 'LAW', 'Department of Law'),
        ('History', 'HIS', 'Department of History')
    ) AS d_fa(name, code, description) ON f.code = 'FA'
    LEFT JOIN (
        VALUES
        ('Economics', 'ECO', 'Department of Economics'),
        ('Management', 'MGT', 'Department of Management')
    ) AS d_fsms(name, code, description) ON f.code = 'FSMS'
    WHERE (f.code = 'FS' AND d_fs.name IS NOT NULL)
       OR (f.code = 'FA' AND d_fa.name IS NOT NULL)
       OR (f.code = 'FSMS' AND d_fsms.name IS NOT NULL)
    RETURNING id, code, faculty_id
),
inserted_students AS (
    INSERT INTO students (id, matricule, department_id, level, admission_year, current_semester, current_academic_year)
    SELECT
        u.id,
        CASE
            WHEN u.email = 'student.cs@ubuea.cm' THEN 'UB20T1234'
            WHEN u.email = 'student.law@ubuea.cm' THEN 'UB21A5678'
            WHEN u.email = 'student.physics@ubuea.cm' THEN 'UB20S9101'
            WHEN u.email = 'student.english@ubuea.cm' THEN 'UB21L1121'
            ELSE NULL
        END,
        CASE
            WHEN u.email = 'student.cs@ubuea.cm' THEN (SELECT id FROM inserted_departments WHERE code = 'CS')
            WHEN u.email = 'student.law@ubuea.cm' THEN (SELECT id FROM inserted_departments WHERE code = 'LAW')
            WHEN u.email = 'student.physics@ubuea.cm' THEN (SELECT id FROM inserted_departments WHERE code = 'PHY')
            WHEN u.email = 'student.english@ubuea.cm' THEN (SELECT id FROM inserted_departments WHERE code = 'ENG')
            ELSE NULL
        END,
        CASE
            WHEN u.email = 'student.cs@ubuea.cm' THEN 400
            WHEN u.email = 'student.law@ubuea.cm' THEN 300
            WHEN u.email = 'student.physics@ubuea.cm' THEN 400
            WHEN u.email = 'student.english@ubuea.cm' THEN 300
            ELSE NULL
        END,
        CASE
            WHEN u.email = 'student.cs@ubuea.cm' THEN 2020
            WHEN u.email = 'student.law@ubuea.cm' THEN 2021
            WHEN u.email = 'student.physics@ubuea.cm' THEN 2020
            WHEN u.email = 'student.english@ubuea.cm' THEN 2021
            ELSE NULL
        END,
        1, '2024-2025'
    FROM inserted_users u
    WHERE u.role = 'student'
    RETURNING id AS student_id, matricule
),
inserted_lecturers AS (
    INSERT INTO lecturers (id, employee_id, department_id, title, specialization, hire_date)
    SELECT
        u.id,
        CASE
            WHEN u.email = 'lecturer.science@ubuea.cm' THEN 'EMP001FS'
            WHEN u.email = 'lecturer.arts@ubuea.cm' THEN 'EMP002FA'
            ELSE NULL
        END,
        CASE
            WHEN u.email = 'lecturer.science@ubuea.cm' THEN (SELECT id FROM inserted_departments WHERE code = 'CS')
            WHEN u.email = 'lecturer.arts@ubuea.cm' THEN (SELECT id FROM inserted_departments WHERE code = 'ENG')
            ELSE NULL
        END,
        CASE
            WHEN u.email = 'lecturer.science@ubuea.cm' THEN 'Dr.'
            WHEN u.email = 'lecturer.arts@ubuea.cm' THEN 'Prof.'
            ELSE NULL
        END,
        CASE
            WHEN u.email = 'lecturer.science@ubuea.cm' THEN 'Artificial Intelligence'
            WHEN u.email = 'lecturer.arts@ubuea.cm' THEN 'African Literature'
            ELSE NULL
        END,
        CASE
            WHEN u.email = 'lecturer.science@ubuea.cm' THEN '2015-09-01'::DATE
            WHEN u.email = 'lecturer.arts@ubuea.cm' THEN '2010-01-15'::DATE
            ELSE NULL
        END
    FROM inserted_users u
    WHERE u.role = 'lecturer'
    RETURNING id AS lecturer_id, employee_id
),
inserted_admins AS (
    INSERT INTO admins (id, department_id, admin_level)
    SELECT
        u.id,
        (SELECT id FROM inserted_departments WHERE code = 'CS') AS department_id,
        'system'
    FROM inserted_users u
    WHERE u.role = 'admin' AND u.email = 'admin.system@ubuea.cm'
    RETURNING id AS admin_id
),
inserted_courses AS (
    INSERT INTO courses (department_id, code, title, credits, level, semester, academic_year, max_enrollment, enrollment_start_date, enrollment_end_date, course_start_date, course_end_date)
    VALUES
    ((SELECT id FROM inserted_departments WHERE code = 'CS'), 'CMT401', 'Software Engineering I', 3, 400, 1, '2024-2025', 80, '2024-08-15 09:00:00+01', '2024-09-15 17:00:00+01', '2024-09-02 08:00:00+01', '2025-01-31 17:00:00+01'),
    ((SELECT id FROM inserted_departments WHERE code = 'CS'), 'CMT403', 'Operating Systems', 3, 400, 1, '2024-2025', 80, '2024-08-15 09:00:00+01', '2024-09-15 17:00:00+01', '2024-09-02 08:00:00+01', '2025-01-31 17:00:00+01'),
    ((SELECT id FROM inserted_departments WHERE code = 'LAW'), 'LAW301', 'Constitutional Law I', 4, 300, 1, '2024-2025', 120, '2024-08-15 09:00:00+01', '2024-09-15 17:00:00+01', '2024-09-02 08:00:00+01', '2025-01-31 17:00:00+01'),
    ((SELECT id FROM inserted_departments WHERE code = 'ENG'), 'ENG302', 'Introduction to Poetry', 3, 300, 1, '2024-2025', 100, '2024-08-15 09:00:00+01', '2024-09-15 17:00:00+01', '2024-09-02 08:00:00+01', '2025-01-31 17:00:00+01'),
    ((SELECT id FROM inserted_departments WHERE code = 'PHY'), 'PHY405', 'Quantum Mechanics', 4, 400, 1, '2024-2025', 50, '2024-08-15 09:00:00+01', '2024-09-15 17:00:00+01', '2024-09-02 08:00:00+01', '2025-01-31 17:00:00+01')
    RETURNING id AS course_id, code, title
),
inserted_course_assignments AS (
    INSERT INTO course_assignments (course_id, lecturer_id, is_primary)
    SELECT c.course_id, l.lecturer_id, true
    FROM inserted_courses c, inserted_lecturers l
    WHERE (c.code = 'CMT401' AND l.employee_id = 'EMP001FS') OR
          (c.code = 'CMT403' AND l.employee_id = 'EMP001FS') OR
          (c.code = 'ENG302' AND l.employee_id = 'EMP002FA')
    RETURNING course_id
),
inserted_enrollments AS (
    INSERT INTO course_enrollments (course_id, student_id, status, grade)
    SELECT
        c.course_id,
        s.student_id,
        'active',
        NULL
    FROM inserted_courses c
    JOIN inserted_students s ON
        (c.code = 'CMT401' AND s.matricule = 'UB20T1234') OR
        (c.code = 'CMT403' AND s.matricule = 'UB20T1234') OR
        (c.code = 'LAW301' AND s.matricule = 'UB21A5678') OR
        (c.code = 'ENG302' AND s.matricule = 'UB21L1121') OR
        (c.code = 'PHY405' AND s.matricule = 'UB20S9101')
    RETURNING id AS enrollment_id, course_id, student_id
),
inserted_enrollment_history AS (
    INSERT INTO enrollment_history (enrollment_id, student_id, course_id, action, old_status, new_status, reason, performed_by)
    SELECT
        e.enrollment_id,
        e.student_id,
        e.course_id,
        'enroll',
        NULL,
        'active',
        'Initial enrollment',
        (SELECT id FROM inserted_users WHERE email = 'admin.system@ubuea.cm')
    FROM inserted_enrollments e
    RETURNING enrollment_id
),
inserted_attendance_sessions AS (
    INSERT INTO attendance_sessions (course_id, lecturer_id, title, scheduled_start, scheduled_end, location_name, location_latitude, location_longitude)
    SELECT
        c.course_id,
        l.lecturer_id,
        CASE
            WHEN c.code = 'CMT401' THEN 'CMT401 Week 1 Lecture'
            WHEN c.code = 'LAW301' THEN 'LAW301 Week 1 Lecture'
            ELSE NULL
        END,
        CASE
            WHEN c.code = 'CMT401' THEN '2024-09-02 09:00:00+01'::timestamp with time zone
            WHEN c.code = 'LAW301' THEN '2024-09-03 14:00:00+01'::timestamp with time zone
            ELSE NULL
        END,
        CASE
            WHEN c.code = 'CMT401' THEN '2024-09-02 11:00:00+01'::timestamp with time zone
            WHEN c.code = 'LAW301' THEN '2024-09-03 16:00:00+01'::timestamp with time zone
            ELSE NULL
        END,
        CASE
            WHEN c.code = 'CMT401' THEN 'Amphitheatre 750'
            WHEN c.code = 'LAW301' THEN 'Faculty of Arts Lecture Hall'
            ELSE NULL
        END,
        CASE
            WHEN c.code = 'CMT401' THEN 4.0152
            WHEN c.code = 'LAW301' THEN 4.0160
            ELSE NULL
        END,
        CASE
            WHEN c.code = 'CMT401' THEN 9.2974
            WHEN c.code = 'LAW301' THEN 9.2980
            ELSE NULL
        END
    FROM inserted_courses c
    JOIN inserted_lecturers l ON
        (c.code = 'CMT401' AND l.employee_id = 'EMP001FS') OR
        (c.code = 'LAW301' AND l.employee_id = 'EMP002FA')
    RETURNING id AS session_id, course_id, lecturer_id, title
),
inserted_attendance_records AS (
    INSERT INTO attendance_records (session_id, student_id, status, location_latitude, location_longitude, distance_from_session, face_confidence)
    SELECT
        s.session_id,
        stu.student_id,
        'present'::attendance_status, -- Cast to attendance_status
        CASE
            WHEN s.title = 'CMT401 Week 1 Lecture' THEN 4.0153
            WHEN s.title = 'LAW301 Week 1 Lecture' THEN 4.0161
            ELSE NULL
        END,
        CASE
            WHEN s.title = 'CMT401 Week 1 Lecture' THEN 9.2975
            WHEN s.title = 'LAW301 Week 1 Lecture' THEN 9.2981
            ELSE NULL
        END,
        CASE
            WHEN s.title = 'CMT401 Week 1 Lecture' THEN 15.2
            WHEN s.title = 'LAW301 Week 1 Lecture' THEN 10.5
            ELSE NULL
        END,
        CASE
            WHEN s.title = 'CMT401 Week 1 Lecture' THEN 0.95
            WHEN s.title = 'LAW301 Week 1 Lecture' THEN 0.92
            ELSE NULL
        END
    FROM inserted_attendance_sessions s
    JOIN inserted_students stu ON
        (s.title = 'CMT401 Week 1 Lecture' AND stu.matricule = 'UB20T1234') OR
        (s.title = 'LAW301 Week 1 Lecture' AND stu.matricule = 'UB21A5678')
    RETURNING session_id
),
inserted_face_data AS (
    INSERT INTO face_data (student_id, face_encoding, face_image_url, is_verified)
    SELECT
        id, ARRAY[100, 120, 150, 130, 110], 'http://example.com/paul_eko_face.jpg', true
    FROM inserted_users
    WHERE email = 'student.cs@ubuea.cm'
    RETURNING student_id
),
inserted_notifications AS (
    INSERT INTO notifications (user_id, title, message, type, priority, expires_at)
    SELECT
        id, 'Course Enrollment Confirmation', 'You have been successfully enrolled in CMT401.', 'enrollment'::notification_type, 'normal'::notification_priority, '2025-01-01 23:59:59+01'::timestamp with time zone
    FROM inserted_users
    WHERE email = 'student.cs@ubuea.cm'
    UNION ALL
    SELECT
        id, 'Attendance Marked', 'Your attendance for CMT401 lecture on 2024-09-02 has been marked present.', 'attendance'::notification_type, 'low'::notification_priority, NULL
    FROM inserted_users
    WHERE email = 'student.cs@ubuea.cm'
    UNION ALL
    SELECT
        id, 'System Update', 'System maintenance scheduled for Saturday.', 'system'::notification_type, 'high'::notification_priority, NULL
    FROM inserted_users
    WHERE email = 'admin.system@ubuea.cm'
    RETURNING id
),
inserted_system_settings AS (
    INSERT INTO system_settings (setting_key, setting_value, description, is_public)
    VALUES
    ('enrollment_settings', '{"maxCoursesPerSemester": 8, "minCreditsPerSemester": 12, "maxCreditsPerSemester": 21}', 'Global enrollment rules', true),
    ('attendance_settings', '{"geofenceRadius": 100.0, "faceConfidenceThreshold": 0.8, "lateThresholdMinutes": 15}', 'Global attendance rules', true),
    ('current_academic_year', '"2024-2025"', 'The active academic year for the university', true)
    RETURNING id
),
inserted_academic_calendar AS (
    INSERT INTO academic_calendar (academic_year, semester, event_type, event_name, event_date, description)
    VALUES
    ('2024-2025', 1, 'Start of Semester', 'First Semester Begins', '2024-09-02', 'Lectures commence for the first semester.'),
    ('2024-2025', 1, 'Registration Deadline', 'Course Registration Closes', '2024-09-15', 'Final day for students to register for courses.'),
    ('2024-2025', 1, 'Mid-Semester Break', 'Mid-Semester Holidays', '2024-10-21', 'One-week break for students and staff.'),
    ('2024-2025', 1, 'End of Semester', 'First Semester Ends', '2025-01-31', 'Lectures end for the first semester.'),
    ('2024-2025', 2, 'Start of Semester', 'Second Semester Begins', '2025-03-03', 'Lectures commence for the second semester.'),
    ('2024-2025', 2, 'End of Semester', 'Second Semester Ends', '2025-06-30', 'Lectures end for the second semester.')
    RETURNING id
)
-- Final SELECT statement to trigger all CTEs and indicate completion
SELECT 'Data insertion complete' AS status
FROM inserted_academic_calendar;
