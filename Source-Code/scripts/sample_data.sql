-- Insert sample faculties
INSERT INTO public.faculties (name, code, description) VALUES
('Faculty of Science', 'SCI', 'Faculty of Science and Technology'),
('Faculty of Arts', 'ART', 'Faculty of Arts and Humanities'),
('Faculty of Engineering', 'ENG', 'Faculty of Engineering');

-- Insert sample departments
INSERT INTO public.departments (faculty_id, name, code, description) VALUES
((SELECT id FROM public.faculties WHERE code = 'SCI'), 'Computer Science', 'CS', 'Department of Computer Science'),
((SELECT id FROM public.faculties WHERE code = 'SCI'), 'Mathematics', 'MATH', 'Department of Mathematics'),
((SELECT id FROM public.faculties WHERE code = 'ENG'), 'Software Engineering', 'SE', 'Department of Software Engineering');

-- Insert sample courses
INSERT INTO public.courses (department_id, code, title, description, credits, level, semester, academic_year) VALUES
((SELECT id FROM public.departments WHERE code = 'CS'), 'CS201', 'Data Structures', 'Introduction to Data Structures and Algorithms', 3, 200, 1, '2024-2025'),
((SELECT id FROM public.departments WHERE code = 'CS'), 'CS202', 'Database Systems', 'Introduction to Database Management Systems', 3, 200, 2, '2024-2025'),
((SELECT id FROM public.departments WHERE code = 'CS'), 'CS301', 'Software Engineering', 'Principles of Software Engineering', 4, 300, 1, '2024-2025'),
((SELECT id FROM public.departments WHERE code = 'SE'), 'SE201', 'Programming Fundamentals', 'Basic Programming Concepts', 3, 200, 1, '2024-2025');
