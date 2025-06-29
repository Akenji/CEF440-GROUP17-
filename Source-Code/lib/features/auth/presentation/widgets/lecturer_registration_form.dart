import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../../../core/models/user_model.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../../data/providers/academic_providers.dart';
import '../../data/providers/auth_providers.dart';

class LecturerRegistrationForm extends ConsumerStatefulWidget {
  final VoidCallback onComplete;
  final bool isLoading;
  final String userEmail;
  final String userPassword;
  final String userFullName;
  final String userPhone;

  const LecturerRegistrationForm({
    super.key,
    required this.onComplete,
    required this.isLoading,
    required this.userEmail,
    required this.userPassword,
    required this.userFullName,
    required this.userPhone,
  });

  @override
  ConsumerState<LecturerRegistrationForm> createState() => _LecturerRegistrationFormState();
}

class _LecturerRegistrationFormState extends ConsumerState<LecturerRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _specializationController = TextEditingController();
  
  String? _selectedFaculty;
  String? _selectedDepartment;
  DateTime? _hireDate;

  @override
  void dispose() {
    _employeeIdController.dispose();
    _titleController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  Future<void> _completeRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Validate employee ID uniqueness
      final isEmployeeIdUnique = await _validateEmployeeId(_employeeIdController.text.trim());
      if (!isEmployeeIdUnique) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Employee ID already exists. Please use a different ID.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Prepare lecturer data
      final lecturerData = {
        'employee_id': _employeeIdController.text.trim(),
        'department_id': _selectedDepartment,
        'title': _titleController.text.trim().isNotEmpty ? _titleController.text.trim() : null,
        'specialization': _specializationController.text.trim().isNotEmpty ? _specializationController.text.trim() : null,
        'hire_date': _hireDate?.toIso8601String(),
        'office_location': null,
        'office_hours': null,
      };

      // Call the auth service with complete data
      await ref.read(authServiceProvider.notifier).signUp(
        email: widget.userEmail,
        password: widget.userPassword,
        fullName: widget.userFullName,
        role: UserRole.lecturer,
        additionalData: lecturerData,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please check your email for verification.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/lecturer');
        widget.onComplete();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${error.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<bool> _validateEmployeeId(String employeeId) async {
    try {
      final existing = await SupabaseService.from('lecturers')
          .select('id')
          .eq('employee_id', employeeId)
          .maybeSingle();
      return existing == null;
    } catch (e) {
      return true; // Allow if we can't check
    }
  }

  @override
  Widget build(BuildContext context) {
    final facultiesAsync = ref.watch(facultiesProvider);
    final departmentsAsync = ref.watch(departmentsProvider(_selectedFaculty));

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Icon(
              Icons.person,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Lecturer Information',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your lecturer profile',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Employee ID Field
            AuthTextField(
              controller: _employeeIdController,
              label: 'Employee ID',
              prefixIcon: Icons.badge_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your employee ID';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Title Field
            AuthTextField(
              controller: _titleController,
              label: 'Title (e.g., Dr., Prof.)',
              prefixIcon: Icons.title,
            ),
            const SizedBox(height: 16),

            // Faculty Dropdown
            facultiesAsync.when(
              data: (faculties) => DropdownButtonFormField<String>(
                value: _selectedFaculty,
                decoration: const InputDecoration(
                  labelText: 'Faculty',
                  prefixIcon: Icon(Icons.account_balance),
                  border: OutlineInputBorder(),
                ),
                items: faculties.map((faculty) => DropdownMenuItem(
                  value: faculty.id,
                  child: Text(faculty.name),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFaculty = value;
                    _selectedDepartment = null;
                  });
                },
                validator: (value) => value == null ? 'Please select your faculty' : null,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text('Error loading faculties: $error'),
            ),
            const SizedBox(height: 16),

            // Department Dropdown
            if (_selectedFaculty != null)
              departmentsAsync.when(
                data: (departments) => DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    prefixIcon: Icon(Icons.business),
                    border: OutlineInputBorder(),
                  ),
                  items: departments.map((department) => DropdownMenuItem(
                    value: department.id,
                    child: Text(department.name),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedDepartment = value),
                  validator: (value) => value == null ? 'Please select your department' : null,
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => Text('Error loading departments: $error'),
              ),
            const SizedBox(height: 16),

            // Specialization Field
            AuthTextField(
              controller: _specializationController,
              label: 'Specialization/Field of Study',
              prefixIcon: Icons.science,
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Hire Date Picker
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1980),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _hireDate = date);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Hire Date (Optional)',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _hireDate != null
                      ? '${_hireDate!.day}/${_hireDate!.month}/${_hireDate!.year}'
                      : 'Select hire date',
                  style: TextStyle(
                    color: _hireDate != null ? null : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Complete Registration Button
            AuthButton(
              onPressed: _completeRegistration,
              isLoading: widget.isLoading,
              child: const Text('Complete Registration'),
            ),
          ],
        ),
      ),
    );
  }
}
