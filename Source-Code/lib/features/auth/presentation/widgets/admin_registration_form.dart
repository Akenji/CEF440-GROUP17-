import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_attendance_app/features/admin/presentation/pages/admin_dashboard_page.dart';

import '../../../../core/services/supabase_service.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/validation_service.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../../data/providers/academic_providers.dart';
import '../../data/providers/auth_providers.dart';

class AdminRegistrationForm extends ConsumerStatefulWidget {
  final VoidCallback onComplete;
  final bool isLoading;
  final String userEmail;
  final String userPassword;
  final String userFullName;
  final String userPhone;

  const AdminRegistrationForm({
    super.key,
    required this.onComplete,
    required this.isLoading,
    required this.userEmail,
    required this.userPassword,
    required this.userFullName,
    required this.userPhone,
  });

  @override
  ConsumerState<AdminRegistrationForm> createState() => _AdminRegistrationFormState();
}

class _AdminRegistrationFormState extends ConsumerState<AdminRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _adminCodeController = TextEditingController();
  
  String? _selectedDepartment;
  String _adminLevel = 'department';
  bool _obscureAdminCode = true;

  @override
  void dispose() {
    _adminCodeController.dispose();
    super.dispose();
  }

  Future<void> _completeRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Validate admin code
      final adminCode = _adminCodeController.text.trim();
      if (!ValidationService.isValidAdminCode(adminCode)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid admin code. Please contact system administrator.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Get admin level from code
      final adminLevel = ValidationService.getAdminLevel(adminCode);

      // Prepare admin data
      final adminData = {
        'department_id': _selectedDepartment,
        'admin_level': adminLevel,
        'permissions': _getDefaultPermissions(adminLevel),
      };

      // Call the auth service with complete data
      await ref.read(authServiceProvider.notifier).signUp(
        email: widget.userEmail,
        password: widget.userPassword,
        fullName: widget.userFullName,
        role: UserRole.admin,
        additionalData: adminData,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Admin registration successful! Please check your email for verification.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminDashboardPage()));
        
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

  Map<String, dynamic> _getDefaultPermissions(String adminLevel) {
    if (adminLevel == 'system') {
      return {
        'manage_users': true,
        'manage_courses': true,
        'manage_departments': true,
        'manage_faculties': true,
        'view_reports': true,
        'manage_system_settings': true,
        'manage_attendance': true,
      };
    } else {
      return {
        'manage_users': false,
        'manage_courses': true,
        'manage_departments': false,
        'manage_faculties': false,
        'view_reports': true,
        'manage_system_settings': false,
        'manage_attendance': true,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final departmentsAsync = ref.watch(allDepartmentsProvider);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Icon(
              Icons.admin_panel_settings,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Administrator Registration',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your administrator profile',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Admin Code Field
            AuthTextField(
              controller: _adminCodeController,
              label: 'Admin Authorization Code',
              obscureText: _obscureAdminCode,
              prefixIcon: Icons.security,
              suffixIcon: IconButton(
                icon: Icon(_obscureAdminCode ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscureAdminCode = !_obscureAdminCode),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the admin authorization code';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Contact system administrator for authorization code',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Department Dropdown (Optional for system admins)
            departmentsAsync.when(
              data: (departments) => DropdownButtonFormField<String>(
                value: _selectedDepartment,
                decoration: const InputDecoration(
                  labelText: 'Department (Optional)',
                  prefixIcon: Icon(Icons.business),
                  border: OutlineInputBorder(),
                  helperText: 'Leave empty for system-wide administration',
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('System-wide Administration'),
                  ),
                  ...departments.map((department) => DropdownMenuItem(
                    value: department.id,
                    child: Text('${department.name} (${department.faculty?.name})'),
                  )),
                ],
                onChanged: (value) => setState(() => _selectedDepartment = value),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text('Error loading departments: $error'),
            ),
            const SizedBox(height: 24),

            // Admin Level Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Admin Privileges',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Department Admin: Manage courses and attendance for specific department\n'
                    '• System Admin: Full system access and user management\n'
                    '• Access level determined by authorization code',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
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
