import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/models/academic_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../auth/data/providers/academic_providers.dart';

class QuickActionsCard extends ConsumerWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _ActionButton(
                  title: 'Add Course',
                  icon: Icons.add_circle,
                  color: Colors.blue,
                  onTap: () => _showAddCourseDialog(context, ref),
                ),
                _ActionButton(
                  title: 'Assign Lecturer',
                  icon: Icons.person_add,
                  color: Colors.green,
                  onTap: () => _showAssignLecturerDialog(context, ref),
                ),
                _ActionButton(
                  title: 'View Reports',
                  icon: Icons.analytics,
                  color: Colors.orange,
                  onTap: () => context.go('/admin/reports'),
                ),
                _ActionButton(
                  title: 'Manage Users',
                  icon: Icons.people,
                  color: Colors.purple,
                  onTap: () => context.go('/admin/users'),
                ),
                _ActionButton(
                  title: 'Add Faculty',
                  icon: Icons.school,
                  color: Colors.teal,
                  onTap: () => _showAddFacultyDialog(context, ref),
                ),
                _ActionButton(
                  title: 'Add Department',
                  icon: Icons.business,
                  color: Colors.indigo,
                  onTap: () => _showAddDepartmentDialog(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCourseDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AddCourseDialog(ref: ref),
    );
  }

  void _showAssignLecturerDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AssignLecturerDialog(ref: ref),
    );
  }

  void _showAddFacultyDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AddFacultyDialog(ref: ref),
    );
  }

  void _showAddDepartmentDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AddDepartmentDialog(ref: ref),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add Faculty Dialog
class AddFacultyDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;
  
  const AddFacultyDialog({super.key, required this.ref});

  @override
  ConsumerState<AddFacultyDialog> createState() => _AddFacultyDialogState();
}

class _AddFacultyDialogState extends ConsumerState<AddFacultyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Faculty'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Faculty Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty == true ? 'Please enter faculty name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Faculty Code',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty == true ? 'Please enter faculty code' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _addFaculty,
          child: _isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add Faculty'),
        ),
      ],
    );
  }

  Future<void> _addFaculty() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await SupabaseService.from('faculties').insert({
        'name': _nameController.text.trim(),
        'code': _codeController.text.trim().toUpperCase(),
        'description': _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        'is_active': true,
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Faculty added successfully!')),
        );
        // Refresh faculties list
        widget.ref.invalidate(facultiesProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding faculty: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

// Add Department Dialog
class AddDepartmentDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;
  
  const AddDepartmentDialog({super.key, required this.ref});

  @override
  ConsumerState<AddDepartmentDialog> createState() => _AddDepartmentDialogState();
}

class _AddDepartmentDialogState extends ConsumerState<AddDepartmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedFaculty;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final facultiesAsync = widget.ref.watch(facultiesProvider);

    return AlertDialog(
      title: const Text('Add New Department'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              facultiesAsync.when(
                data: (faculties) => DropdownButtonFormField<String>(
                  value: _selectedFaculty,
                  decoration: const InputDecoration(
                    labelText: 'Faculty',
                    border: OutlineInputBorder(),
                  ),
                  items: faculties.map((faculty) => DropdownMenuItem(
                    value: faculty.id,
                    child: Text(faculty.name),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedFaculty = value),
                  validator: (value) => value == null ? 'Please select a faculty' : null,
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => Text('Error loading faculties: $error'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Department Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Please enter department name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Department Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Please enter department code' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _addDepartment,
          child: _isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add Department'),
        ),
      ],
    );
  }

  Future<void> _addDepartment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await SupabaseService.from('departments').insert({
        'faculty_id': _selectedFaculty,
        'name': _nameController.text.trim(),
        'code': _codeController.text.trim().toUpperCase(),
        'description': _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        'is_active': true,
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Department added successfully!')),
        );
        // Refresh departments list
        widget.ref.invalidate(allDepartmentsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding department: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

// Add Course Dialog
class AddCourseDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;
  
  const AddCourseDialog({super.key, required this.ref});

  @override
  ConsumerState<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends ConsumerState<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxEnrollmentController = TextEditingController(text: '100');
  String? _selectedDepartment;
  int _level = 200;
  int _semester = 1;
  int _credits = 3;
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _maxEnrollmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final departmentsAsync = widget.ref.watch(allDepartmentsProvider);

    return AlertDialog(
      title: const Text('Add New Course'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                departmentsAsync.when(
                  data: (departments) => DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                    ),
                    items: departments.map((dept) => DropdownMenuItem(
                      value: dept.id,
                      child: Text('${dept.name} (${dept.faculty?.name ?? ''})'),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedDepartment = value),
                    validator: (value) => value == null ? 'Please select a department' : null,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, _) => Text('Error loading departments: $error'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Course Code',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Please enter course code' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Course Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Please enter course title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _level,
                        decoration: const InputDecoration(
                          labelText: 'Level',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 200, child: Text('200')),
                          DropdownMenuItem(value: 300, child: Text('300')),
                          DropdownMenuItem(value: 400, child: Text('400')),
                          DropdownMenuItem(value: 500, child: Text('500')),
                        ],
                        onChanged: (value) => setState(() => _level = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _semester,
                        decoration: const InputDecoration(
                          labelText: 'Semester',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('1')),
                          DropdownMenuItem(value: 2, child: Text('2')),
                        ],
                        onChanged: (value) => setState(() => _semester = value!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _credits,
                        decoration: const InputDecoration(
                          labelText: 'Credits',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('1')),
                          DropdownMenuItem(value: 2, child: Text('2')),
                          DropdownMenuItem(value: 3, child: Text('3')),
                          DropdownMenuItem(value: 4, child: Text('4')),
                          DropdownMenuItem(value: 5, child: Text('5')),
                        ],
                        onChanged: (value) => setState(() => _credits = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _maxEnrollmentController,
                        decoration: const InputDecoration(
                          labelText: 'Max Enrollment',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty == true) return 'Please enter max enrollment';
                          final number = int.tryParse(value!);
                          if (number == null || number <= 0) return 'Please enter a valid number';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _addCourse,
          child: _isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add Course'),
        ),
      ],
    );
  }

  Future<void> _addCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final currentYear = DateTime.now().year;
      final academicYear = '$currentYear/${currentYear + 1}';

      await SupabaseService.from('courses').insert({
        'department_id': _selectedDepartment,
        'code': _codeController.text.trim().toUpperCase(),
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        'credits': _credits,
        'level': _level,
        'semester': _semester,
        'academic_year': academicYear,
        'max_enrollment': int.parse(_maxEnrollmentController.text),
        'current_enrollment': 0,
        'is_active': true,
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course added successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding course: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

// Assign Lecturer Dialog
class AssignLecturerDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;
  
  const AssignLecturerDialog({super.key, required this.ref});

  @override
  ConsumerState<AssignLecturerDialog> createState() => _AssignLecturerDialogState();
}

class _AssignLecturerDialogState extends ConsumerState<AssignLecturerDialog> {
  String? _selectedCourse;
  String? _selectedLecturer;
  bool _isPrimary = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Assign Lecturer to Course'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _getCourses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final courses = snapshot.data ?? [];
              
              return DropdownButtonFormField<String>(
                value: _selectedCourse,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                ),
                items: courses.map<DropdownMenuItem<String>>((course) => DropdownMenuItem<String>(
                  value: course['id'] as String,
                  child: Text('${course['code']} - ${course['title']}'),
                )).toList(),
                onChanged: (value) => setState(() => _selectedCourse = value),
              );
            },
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _getLecturers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final lecturers = snapshot.data ?? [];
              
              return DropdownButtonFormField<String>(
                value: _selectedLecturer,
                decoration: const InputDecoration(
                  labelText: 'Lecturer',
                  border: OutlineInputBorder(),
                ),
                items: lecturers.map<DropdownMenuItem<String>>((lecturer) => DropdownMenuItem<String>(
                  value: lecturer['id'] as String,
                  child: Text(lecturer['full_name']),
                )).toList(),
                onChanged: (value) => setState(() => _selectedLecturer = value),
              );
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Primary Lecturer'),
            value: _isPrimary,
            onChanged: (value) => setState(() => _isPrimary = value ?? false),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading || _selectedCourse == null || _selectedLecturer == null
              ? null
              : _assignLecturer,
          child: _isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Assign'),
        ),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> _getCourses() async {
    try {
      final response = await SupabaseService.from('courses')
          .select('id, code, title')
          .eq('is_active', true)
          .order('code');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getLecturers() async {
    try {
      final response = await SupabaseService.from('lecturers')
          .select('id, users(full_name)')
          .eq('is_active', true);
      
      return response.map<Map<String, dynamic>>((lecturer) => {
        'id': lecturer['id'],
        'full_name': lecturer['users']['full_name'],
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _assignLecturer() async {
    setState(() => _isLoading = true);

    try {
      await SupabaseService.from('course_assignments').insert({
        'course_id': _selectedCourse,
        'lecturer_id': _selectedLecturer,
        'is_primary': _isPrimary,
        'role': 'instructor',
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lecturer assigned successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error assigning lecturer: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
