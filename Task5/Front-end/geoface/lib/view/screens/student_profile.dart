import 'package:attendee/view/face_setup.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

import '../../utils/app_colors.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _bounceController;
  late AnimationController _zoomController;
  late AnimationController _shakeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _zoomAnimation;
  late Animation<double> _shakeAnimation;

  // Mock profile data
  final Map<String, dynamic> profileData = {
    'studentId': 'STU123456',
    'fullName': 'John Doe',
    'email': 'john.doe@university.edu',
    'phone': '+234 123 456 7890',
    'department': 'Computer Science',
    'level': '300',
    'profilePicture': null,
    'facialRecognitionEnrolled': true,
    'notificationPreferences': {
      'emailNotifications': true,
      'pushNotifications': true,
    },
  };

  final List<Map<String, dynamic>> notifications = [
    {'message': 'Profile updated successfully', 'time': '2025-06-02 08:00 AM'},
    {
      'message': 'Facial recognition re-enrollment required',
      'time': '2025-06-01 10:00 AM'
    },
  ];

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isOnline = true;
  int _unreadNotifications = 2;
  bool _isEditing = false;
  File? _profileImage;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _startAnimations();
    _startConnectivityMonitoring();
    _loadProfileData();
  }

  void _initializeControllers() {
    _emailController.text = profileData['email'];
    _phoneController.text = profileData['phone'];
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut),
    );

    _zoomAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOutQuad),
    );

    _shakeAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    _pulseController.repeat(reverse: true);
    _scaleController.forward();
    _rotateController.repeat();
    _bounceController.forward();
    _zoomController.forward();
  }

  void _startConnectivityMonitoring() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      setState(() {
        _isOnline = !results.contains(ConnectivityResult.none);
      });
    });
  }

  void _loadProfileData() {
    // Placeholder for Firebase or API call
    setState(() {});
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
    if (!_isEditing && _formKey.currentState!.validate()) {
      _saveProfile();
    } else {
      _shakeController.reset();
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
  }

  void _saveProfile() {
    profileData['email'] = _emailController.text;
    profileData['phone'] = _phoneController.text;
    // Placeholder for Firebase update
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: AppColors.passwordStrengthStrong,
      ),
    );
    setState(() {
      _unreadNotifications++;
      notifications.add({
        'message': 'Profile updated successfully',
        'time': DateTime.now().toString(),
      });
    });
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      // Placeholder for Firebase Storage upload
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture updated'),
          backgroundColor: AppColors.passwordStrengthStrong,
        ),
      );
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera initialization failed: $e'),
          backgroundColor: AppColors.errorAccent,
        ),
      );
    }
  }

  Future<void> _reEnrollFacialRecognition() async {
    await _initializeCamera();
    if (_isCameraInitialized) {
      // Placeholder for MLKit facial recognition enrollment
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Facial recognition re-enrollment started'),
          backgroundColor: AppColors.passwordStrengthStrong,
        ),
      );
      await Future.delayed(const Duration(seconds: 2)); // Mock processing
      setState(() {
        profileData['facialRecognitionEnrolled'] = true;
        _unreadNotifications++;
        notifications.add({
          'message': 'Facial recognition re-enrolled successfully',
          'time': DateTime.now().toString(),
        });
      });
      _cameraController?.dispose();
      setState(() {
        _isCameraInitialized = false;
      });
    }
  }

  void _showNotifications() {
    setState(() {
      _unreadNotifications = 0;
    });
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.formContainerBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) => FadeInListItem(
                  child: ListTile(
                    leading: const Icon(Icons.notifications,
                        color: AppColors.primaryAccent),
                    title: Text(
                      notifications[index]['message'],
                      style: const TextStyle(color: AppColors.primaryText),
                    ),
                    subtitle: Text(
                      notifications[index]['time'],
                      style: const TextStyle(color: AppColors.secondaryText),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          GestureDetector(
            onTap: _isEditing ? _pickProfileImage : null,
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.gradientAccentStart,
                      AppColors.gradientAccentEnd
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentShadow.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _profileImage != null
                      ? Image.file(_profileImage!, fit: BoxFit.cover)
                      : const Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.primaryText,
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            profileData['fullName'],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${profileData['studentId']}',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isOnline ? Icons.wifi : Icons.wifi_off,
                color: _isOnline
                    ? AppColors.passwordStrengthStrong
                    : AppColors.errorAccent,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _isOnline ? 'Online' : 'Offline',
                style: TextStyle(
                  fontSize: 14,
                  color: _isOnline
                      ? AppColors.passwordStrengthStrong
                      : AppColors.errorAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.formContainerBackground,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.formContainerBorder),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: AppColors.secondaryText),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon:
                      const Icon(Icons.email, color: AppColors.primaryAccent),
                ),
                validator: (value) {
                  if (value == null ||
                      !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: const TextStyle(color: AppColors.secondaryText),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon:
                      const Icon(Icons.phone, color: AppColors.primaryAccent),
                ),
                validator: (value) {
                  if (value == null ||
                      !RegExp(r'^\+\d{10,14}$').hasMatch(value)) {
                    return 'Enter a valid phone number (e.g., +2371234567890)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Department: ${profileData['department']}',
                style: const TextStyle(color: AppColors.secondaryText),
              ),
              const SizedBox(height: 8),
              Text(
                'Level: ${profileData['level']}',
                style: const TextStyle(color: AppColors.secondaryText),
              ),
              const SizedBox(height: 24),
              BounceTransition(
                animation: _bounceAnimation,
                child: ElevatedButton(
                  onPressed: _toggleEditMode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    foregroundColor: AppColors.primaryText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(_isEditing ? 'Save Profile' : 'Edit Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFacialRecognitionSettings() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.formContainerBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Facial Recognition',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  profileData['facialRecognitionEnrolled']
                      ? 'Enrolled'
                      : 'Not Enrolled',
                  style: TextStyle(
                    color: profileData['facialRecognitionEnrolled']
                        ? AppColors.passwordStrengthStrong
                        : AppColors.errorAccent,
                  ),
                ),
                RotationTransition(
                  turns: _rotateAnimation,
                  child: Icon(
                    Icons.face,
                    color: AppColors.dropdownBackground,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ZoomTransition(
              animation: _zoomAnimation,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FacialRecognitionSetupScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: AppColors.primaryText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Re-enroll Facial Recognition'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationPreferences() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.formContainerBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text(
                'Email Notifications',
                style: TextStyle(color: AppColors.primaryText),
              ),
              value: profileData['notificationPreferences']
                  ['emailNotifications'],
              onChanged: (value) {
                setState(() {
                  profileData['notificationPreferences']['emailNotifications'] =
                      value;
                });
                // Placeholder for Firebase update
              },
              activeColor: AppColors.primaryAccent,
            ),
            SwitchListTile(
              title: const Text(
                'Push Notifications',
                style: TextStyle(color: AppColors.primaryText),
              ),
              value: profileData['notificationPreferences']
                  ['pushNotifications'],
              onChanged: (value) {
                setState(() {
                  profileData['notificationPreferences']['pushNotifications'] =
                      value;
                });
                // Placeholder for Firebase update
              },
              activeColor: AppColors.primaryAccent,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundGradientStart,
              AppColors.backgroundGradientMid1,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 100),
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildProfileForm(),
                    _buildFacialRecognitionSettings(),
                    _buildNotificationPreferences(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              // Positioned(
              //   'bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child: Container(
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              //     decoration: BoxDecoration(
              //       color: AppColors.formContainerBackground,
              //       border: Border(
              //           top: BorderSide(color: AppColors.formContainerBorder)),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //          _buildNavItem(Icons.home, 'Home', true, () {}),
              //         _buildNavItem(Icons.schedule, 'Schedule', false,
              //             () => _navigateToScreen(CourseDetailScreen(courseId: "courseId"))),
              //         _buildNavItem(Icons.analytics, 'Analytics', false,
              //             () => _navigateToScreen(StudentAnalyticsScreen())),
              //         _buildNavItem(Icons.person, 'Profile', false,
              //             () => _navigateToScreen(StudentProfileScreen() )),
              //       ]
              //     ),
              //   ),
              // ),'
              Positioned(
                top: 16,
                right: 16,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: GestureDetector(
                    onTap: _showNotifications,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryAccent,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentShadow.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: AppColors.primaryText,
                            size: 24,
                          ),
                        ),
                        if (_unreadNotifications > 0)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.errorAccent,
                              ),
                              child: Text(
                                '$_unreadNotifications',
                                style: const TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primaryAccent : AppColors.secondaryText,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color:
                  isActive ? AppColors.primaryAccent : AppColors.secondaryText,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _bounceController.dispose();
    _zoomController.dispose();
    _shakeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cameraController?.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

class FadeInListItem extends StatefulWidget {
  final Widget child;

  const FadeInListItem({Key? key, required this.child}) : super(key: key);

  @override
  _FadeInListItemState createState() => _FadeInListItemState();
}

class _FadeInListItemState extends State<FadeInListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ZoomTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const ZoomTransition({Key? key, required this.animation, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class BounceTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const BounceTransition(
      {Key? key, required this.animation, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -10 * (1 - animation.value)),
          child: Transform.scale(
            scale: 1 + 0.1 * (1 - animation.value),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
