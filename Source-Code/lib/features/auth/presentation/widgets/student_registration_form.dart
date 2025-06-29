import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:school_attendance_app/features/student/presentation/pages/student_dashboard_page.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/face_recognition_service.dart'; // Ensure this import is correct
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/face_capture_widget.dart'; // This widget needs modification
import '../../data/providers/academic_providers.dart';
import '../../data/providers/auth_providers.dart';

class StudentRegistrationForm extends ConsumerStatefulWidget {
  final VoidCallback onComplete;
  bool isLoading;
  final String userEmail;
  final String userPassword;
  final String userFullName;
  final String userPhone;

  StudentRegistrationForm({
    super.key,
    required this.onComplete,
    this.isLoading = false, // Default to false
    required this.userEmail,
    required this.userPassword,
    required this.userFullName,
    required this.userPhone,
  });

  @override
  ConsumerState<StudentRegistrationForm> createState() =>
      _StudentRegistrationFormState();
}

class _StudentRegistrationFormState
    extends ConsumerState<StudentRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _matriculeController = TextEditingController();
  final _admissionYearController = TextEditingController();

  // Add a GlobalKey for the FaceCaptureWidget to access its methods
  final GlobalKey<FaceCaptureWidgetState> _faceCaptureWidgetKey = GlobalKey();

  String? _selectedFaculty;
  String? _selectedDepartment;
  int _selectedLevel = 200;
  List<double>? _faceEncoding; // This will temporarily hold double features
  String? _faceImagePath;
  bool _isFaceCaptured = true;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _admissionYearController.text = DateTime.now().year.toString();
  }

  @override
  void dispose() {
    _matriculeController.dispose();
    _admissionYearController.dispose();
    super.dispose();
  }

  Future<void> _completeRegistration() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please complete all required fields and capture your face')),
      );
      return;
    }

    try {
      // Convert _faceEncoding from List<double> to List<int>
      // This is crucial for compatibility with FaceDataModel.faceEncoding
      List<int>? faceEncodingForStorage;
      if (_faceEncoding != null) {
        faceEncodingForStorage =
            FaceRecognitionService.convertFeaturesToIntegers(_faceEncoding!);
      }

      // Prepare student data
      final studentData = {
        'matricule': _matriculeController.text.trim(),
        'department_id': _selectedDepartment,
        'level': _selectedLevel,
        'admission_year': int.parse(_admissionYearController.text),
        'current_semester': 1,
        'current_academic_year': '2024-2025',
        'face_encoding':
            faceEncodingForStorage!, // Now correctly List<int> or null
        'face_image_url': _faceImagePath!,
      };

      // Call the auth service with complete data
      await ref.read(authServiceProvider.notifier).signUp(
            email: widget.userEmail,
            password: widget.userPassword,
            fullName: widget.userFullName,
            role: UserRole.student,
            additionalData: studentData,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Registration successful! Please check your email for verification.'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onComplete(); // Call onComplete callback
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

  Future<bool> _validateMatricule(String matricule) async {
    try {
      final existing = await SupabaseService.from('students')
          .select('id')
          .eq('matricule', matricule)
          .maybeSingle();
      return existing == null;
    } catch (e) {
      return true; // Allow if we can't check
    }
  }

  void _nextStep() {
    if (_currentStep == 0 && _formKey.currentState!.validate()) {
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      _completeRegistration();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  // --- NEW METHOD FOR MANUAL CAPTURE ---
  Future<void> _manualCapture() async {
    // This assumes FaceCaptureWidget has a public method like 'captureImage()'
    // that returns the captured image path and potentially face encoding.
    // YOU MUST IMPLEMENT THIS METHOD IN FACE_CAPTURE_WIDGET.DART
    try {
      final result =
          await _faceCaptureWidgetKey.currentState?.captureImageManually();
      if (result != null) {
        setState(() {
          _faceEncoding = result['encoding']; // Expecting List<double>
          _faceImagePath = result['imagePath']; // Expecting String
          _isFaceCaptured = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Image captured manually. Proceed with registration.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Manual capture failed or no image was taken.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during manual capture: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress Indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / 2,
            backgroundColor: Colors.grey.withOpacity(0.3),
          ),
          const SizedBox(height: 24),

          // Header
          Icon(
            Icons.school,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            _currentStep == 0
                ? 'Student Information'
                : 'Face Recognition Setup',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _currentStep == 0
                ? 'Complete your student profile'
                : 'Capture your face for attendance verification',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          if (_currentStep == 0)
            _buildStudentInfoStep()
          else
            _buildFaceCaptureStep(),
        ],
      ),
    );
  }

  Widget _buildStudentInfoStep() {
    final facultiesAsync = ref.watch(facultiesProvider);
    final departmentsAsync = ref.watch(departmentsProvider(_selectedFaculty));

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Matricule Field
          AuthTextField(
            controller: _matriculeController,
            label: 'Matricule/Student ID',
            prefixIcon: Icons.badge_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your matricule';
              }
              return null;
            },
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
              items: faculties
                  .map((faculty) => DropdownMenuItem(
                        value: faculty.id,
                        child: Text(faculty.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFaculty = value;
                  _selectedDepartment = null; // Reset department
                });
              },
              validator: (value) =>
                  value == null ? 'Please select your faculty' : null,
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
                items: departments
                    .map((department) => DropdownMenuItem(
                          value: department.id,
                          child: Text(department.name),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedDepartment = value),
                validator: (value) =>
                    value == null ? 'Please select your department' : null,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text('Error loading departments: $error'),
            ),
          const SizedBox(height: 16),

          // Level Dropdown
          DropdownButtonFormField<int>(
            value: _selectedLevel,
            decoration: const InputDecoration(
              labelText: 'Level',
              prefixIcon: Icon(Icons.stairs),
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 200, child: Text('200 Level')),
              DropdownMenuItem(value: 300, child: Text('300 Level')),
              DropdownMenuItem(value: 400, child: Text('400 Level')),
              DropdownMenuItem(value: 500, child: Text('500 Level')),
            ],
            onChanged: (value) => setState(() => _selectedLevel = value!),
          ),
          const SizedBox(height: 16),

          // Admission Year Field
          AuthTextField(
            controller: _admissionYearController,
            label: 'Admission Year',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.calendar_today,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your admission year';
              }
              final year = int.tryParse(value);
              if (year == null || year < 2000 || year > DateTime.now().year) {
                return 'Please enter a valid year';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Next Button
          AuthButton(
            onPressed: _nextStep,
            child: const Text('Next: Face Setup'),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceCaptureStep() {
    return Column(
      children: [
        // Face Capture Widget
        FaceCaptureWidget(
          key: _faceCaptureWidgetKey, // Assign the GlobalKey here
          onFaceCaptured: (encoding, imagePath) {
            setState(() {
              _faceEncoding =
                  encoding; // This is List<double> from FaceRecognitionService
              _faceImagePath = imagePath;
              _isFaceCaptured = true;
            });
          },
        ),
        const SizedBox(height: 24),

        // --- NEW MANUAL CAPTURE BUTTON ---
        AuthButton(
          onPressed: _manualCapture, // Call the new manual capture method
          isOutlined: true,
          child: const Text('Manually Capture Face'),
        ),
        const SizedBox(height: 24),

        // Status Indicator
        if (_isFaceCaptured)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Face captured successfully! You can now complete registration.',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 24),

        // Complete Registration Button
        AuthButton(
          onPressed: () {
            _completeRegistration();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StudentDashboardPage()));
          },
          isLoading: false,
          child: const Text('Complete Registration'),
        ),
        const SizedBox(height: 16),

        // Back Button
        AuthButton(
          onPressed: _previousStep,
          isOutlined: true,
          child: const Text('Back'),
        ),
      ],
    );
  }
}
