import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_attendance_app/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:school_attendance_app/features/lecturer/presentation/pages/lecturer_dashboard_page.dart';
import 'package:school_attendance_app/features/student/presentation/pages/student_dashboard_page.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/models/user_model.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/role_selector.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  UserRole? _selectedRole;
  bool _showRoleSelector = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes
    ref.listenManual(authServiceProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null && mounted) {
            // Navigate based on user role
            _navigateBasedOnRole(user.role);
          }
        },
        error: (error, stackTrace) {
          if (mounted) {
            _showErrorSnackBar(error.toString());
          }
        },
      );
    });
  }

  void _navigateBasedOnRole(UserRole role) {
    switch (role) {
      case UserRole.student:
        context.go('/student');
        break;
      case UserRole.lecturer:
        context.go('/lecturer');
        break;
      case UserRole.admin:
        context.go('/admin');
        break;
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login failed: $message'),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authServiceProvider.notifier).signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            expectedRole: _selectedRole, // Pass expected role for validation
          );
    } catch (error) {
      // Error handling is done in the listener
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _forgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address first'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      await ref.read(authServiceProvider.notifier).resetPassword(
            _emailController.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Check your inbox.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send reset email: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authServiceProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo and Title
                Hero(
                  tag: 'app_logo',
                  child: Icon(
                    Icons.school,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'School Attendance',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Role Selector (Optional)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _showRoleSelector ? null : 0,
                  child: _showRoleSelector
                      ? Column(
                          children: [
                            RoleSelector(
                              selectedRole: _selectedRole ?? UserRole.student,
                              onRoleChanged: (role) =>
                                  setState(() => _selectedRole = role),
                              isCompact: true,
                            ),
                            const SizedBox(height: 24),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),

                // Email Field
                AuthTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Auto-detect role based on email domain (optional)
                    if (value.contains('@student.')) {
                      setState(() => _selectedRole = UserRole.student);
                    } else if (value.contains('@lecturer.') ||
                        value.contains('@staff.')) {
                      setState(() => _selectedRole = UserRole.lecturer);
                    } else if (value.contains('@admin.')) {
                      setState(() => _selectedRole = UserRole.admin);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                AuthTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
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
                const SizedBox(height: 8),

                // Role Selector Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() => _showRoleSelector = !_showRoleSelector);
                      },
                      icon: Icon(
                        _showRoleSelector
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 20,
                      ),
                      label: Text(
                        _showRoleSelector ? 'Hide Role' : 'Select Role',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    if (_selectedRole != null)
                      Chip(
                        label: Text(
                          _selectedRole!.name.toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor:
                            _getRoleColor(_selectedRole!).withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: _getRoleColor(_selectedRole!),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sign In Button
                AuthButton(
                  onPressed: _isLoading ? null : _signIn,
                  isLoading: _isLoading,
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 16),

                // Forgot Password
                TextButton(
                  onPressed: _isLoading ? null : _forgotPassword,
                  child: const Text('Forgot Password?'),
                ),
                const SizedBox(height: 32),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'New to the platform?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Sign Up Link
                OutlinedButton(
                  onPressed: _isLoading ? null : () => context.go('/register'),
                  child: const Text('Create Account'),
                ),
                const SizedBox(height: 24),

                // Quick Login Demo Buttons (for testing)
                if (const bool.fromEnvironment('dart.vm.product') == false) ...[
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Quick Demo Login',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        StudentDashboardPage()));
                          },
                          // => _quickLogin(UserRole.student),
                          child: const Text('Student'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LecturerDashboardPage()));
                          },
                          //  => _quickLogin(UserRole.lecturer),
                          child: const Text('Lecturer'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AdminDashboardPage()));
                          },
                          // onPressed: () => _quickLogin(UserRole.admin),
                          child: const Text('Admin'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Colors.blue;
      case UserRole.lecturer:
        return Colors.green;
      case UserRole.admin:
        return Colors.orange;
    }
  }

  void _quickLogin(UserRole role) {
    setState(() {
      _selectedRole = role;
      switch (role) {
        case UserRole.student:
          _emailController.text = 'student@demo.com';
          break;
        case UserRole.lecturer:
          _emailController.text = 'lecturer@demo.com';
          break;
        case UserRole.admin:
          _emailController.text = 'admin@demo.com';
          break;
      }
      _passwordController.text = 'demo123';
    });
  }
}
