-- Demo users for testing
-- Password for all demo users: demo123

-- Insert demo student
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
VALUES (
  '11111111-1111-1111-1111-111111111111',
  'student@demo.com',
  '$2a$10$8K1p/a0dhrxSHxN1nByqhOxF7uL5/NDPOB6Y6kkL8OKC8qfHFqWhW', -- demo123
  NOW(),
  NOW(),
  NOW(),
  '{"provider": "email", "providers": ["email"]}',
  '{"full_name": "Demo Student", "role": "student"}'
);

-- Insert demo lecturer
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
VALUES (
  '22222222-2222-2222-2222-222222222222',
  'lecturer@demo.com',
  '$2a$10$8K1p/a0dhrxSHxN1nByqhOxF7uL5/NDPOB6Y6kkL8OKC8qfHFqWhW', -- demo123
  NOW(),
  NOW(),
  NOW(),
  '{"provider": "email", "providers": ["email"]}',
  '{"full_name": "Demo Lecturer", "role": "lecturer"}'
);

-- Insert demo admin
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data)
VALUES (
  '33333333-3333-3333-3333-333333333333',
  'admin@demo.com',
  '$2a$10$8K1p/a0dhrxSHxN1nByqhOxF7uL5/NDPOB6Y6kkL8OKC8qfHFqWhW', -- demo123
  NOW(),
  NOW(),
  NOW(),
  '{"provider": "email", "providers": ["email"]}',
  '{"full_name": "Demo Admin", "role": "admin"}'
);

-- Insert corresponding user profiles
INSERT INTO public.users (id, email, full_name, role, is_active, created_at, updated_at)
VALUES 
  ('11111111-1111-1111-1111-111111111111', 'student@demo.com', 'Demo Student', 'student', true, NOW(), NOW()),
  ('22222222-2222-2222-2222-222222222222', 'lecturer@demo.com', 'Demo Lecturer', 'lecturer', true, NOW(), NOW()),
  ('33333333-3333-3333-3333-333333333333', 'admin@demo.com', 'Demo Admin', 'admin', true, NOW(), NOW());

-- Insert student profile
INSERT INTO public.students (id, matricule, department_id, level, admission_year, current_semester, current_academic_year)
VALUES (
  '11111111-1111-1111-1111-111111111111',
  'CS2024001',
  (SELECT id FROM departments WHERE code = 'CS' LIMIT 1),
  400,
  2021,
  1,
  '2024-2025'
);

-- Insert lecturer profile
INSERT INTO public.lecturers (id, employee_id, department_id, title, specialization, hire_date)
VALUES (
  '22222222-2222-2222-2222-222222222222',
  'LEC001',
  (SELECT id FROM departments WHERE code = 'CS' LIMIT 1),
  'Dr.',
  'Computer Science',
  '2020-01-15'
);

-- Insert admin profile
INSERT INTO public.admins (id, department_id, admin_level, permissions)
VALUES (
  '33333333-3333-3333-3333-333333333333',
  (SELECT id FROM departments WHERE code = 'CS' LIMIT 1),
  'department',
  '{"manage_users": true, "manage_courses": true, "view_reports": true, "system_settings": false}'
);

-- Insert demo face data for student
INSERT INTO public.face_data (student_id, face_encoding, face_image_url, is_verified)
VALUES (
  '11111111-1111-1111-1111-111111111111',
  ARRAY[0.1, 0.2, 0.3, 0.4, 0.5], -- Dummy face encoding
  'https://via.placeholder.com/300x300.jpg?text=Demo+Student',
  true
);
