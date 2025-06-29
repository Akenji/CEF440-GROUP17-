import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_service.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/role_selector.dart';
import '../widgets/student_registration_form.dart';
import '../widgets/lecturer_registration_form.dart';
import '../widgets/admin_registration_form.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  UserRole _selectedRole = UserRole.student;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _currentStep = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0 && _formKey.currentState!.validate()) {
      setState(() => _currentStep = 1);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: _currentStep == 0
                ? _buildBasicInfoStep()
                : _buildRoleSpecificStep(),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Icon(
            Icons.person_add,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Basic Information',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your basic details to get started',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Role Selector
          RoleSelector(
            selectedRole: _selectedRole,
            onRoleChanged: (role) => setState(() => _selectedRole = role),
          ),
          const SizedBox(height: 24),

          // Full Name Field
          AuthTextField(
            controller: _fullNameController,
            label: 'Full Name',
            prefixIcon: Icons.person_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              if (value.length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email Field
          AuthTextField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone Field
          AuthTextField(
            controller: _phoneController,
            label: 'Phone Number (Optional)',
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
          ),
          const SizedBox(height: 16),

          // Password Field
          AuthTextField(
            controller: _passwordController,
            label: 'Password',
            obscureText: _obscurePassword,
            prefixIcon: Icons.lock_outlined,
            suffixIcon: IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm Password Field
          AuthTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            obscureText: _obscureConfirmPassword,
            prefixIcon: Icons.lock_outlined,
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Next Button
          AuthButton(
            onPressed: _nextStep,
            child: const Text('Next'),
          ),
          const SizedBox(height: 16),

          // Sign In Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSpecificStep() {
    switch (_selectedRole) {
      case UserRole.student:
        return StudentRegistrationForm(
          onComplete: () {}, // Will be handled by the form itself
          isLoading: _isLoading,
          userEmail: _emailController.text,
          userPassword: _passwordController.text,
          userFullName: _fullNameController.text,
          userPhone: _phoneController.text,
        );
      case UserRole.lecturer:
        return LecturerRegistrationForm(
          onComplete: () {}, // Will be handled by the form itself
          isLoading: _isLoading,
          userEmail: _emailController.text,
          userPassword: _passwordController.text,
          userFullName: _fullNameController.text,
          userPhone: _phoneController.text,
        );
      case UserRole.admin:
        return AdminRegistrationForm(
          onComplete: () {}, // Will be handled by the form itself
          isLoading: _isLoading,
          userEmail: _emailController.text,
          userPassword: _passwordController.text,
          userFullName: _fullNameController.text,
          userPhone: _phoneController.text,
        );
    }
  }
}
