import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:math' as math;

import '../../utils/app_colors.dart';

class AttendanceMarkingScreen extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String classTime;
  final double requiredLatitude;
  final double requiredLongitude;
  final double allowedRadius;

  const AttendanceMarkingScreen({
    Key? key,
    required this.courseId,
    required this.courseName,
    required this.classTime,
    required this.requiredLatitude,
    required this.requiredLongitude,
    this.allowedRadius = 100.0, // meters
  }) : super(key: key);

  @override
  State<AttendanceMarkingScreen> createState() =>
      _AttendanceMarkingScreenState();
}

class _AttendanceMarkingScreenState extends State<AttendanceMarkingScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late AnimationController _shakeController;
  late AnimationController _rotateController;
  late AnimationController _breatheController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _breatheAnimation;

  // Camera and Detection
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  bool _isAttendanceMarked = false;
  bool _showError = false;
  bool _isOnline = true;
  String _instructionText = 'Position your face in the frame';
  String _errorMessage = '';

  // Enhanced Detection Metrics
  double _faceAlignmentScore = 0.0;
  double _lightingScore = 0.0;
  double _faceConfidenceScore = 0.0;
  double _stabilityScore = 0.0;
  bool _eyesDetected = false;
  bool _mouthDetected = false;

  // Location and Network
  // Position? _currentPosition;
  String _locationStatus = 'Checking location...';
  bool _isLocationValid = false;
  StreamSubscription<ConnectivityResult>? _connectivitySubscriptio;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Capture Management
  int _captureAttempts = 0;
  final int _maxAttempts = 5;
  Timer? _detectionTimer;
  Timer? _stabilityTimer;
  List<double> _stabilityReadings = [];

  // Mock attendance result
  Map<String, dynamic>? _attendanceResult;

  // Biometric Enhancement
  final List<String> _biometricChecks = [
    'Face Detection',
    'Eye Detection',
    'Lighting Analysis',
    'Stability Check',
    'Location Verification',
  ];
  Map<String, bool> _checkResults = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeChecks();
    _checkPermissionsAndInitialize();
    _startAnimations();
    _startConnectivityMonitoring();
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
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _breatheController = AnimationController(
      duration: const Duration(milliseconds: 4000),
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

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _shakeAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticInOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _breatheAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOutSine),
    );
  }

  void _initializeChecks() {
    for (String check in _biometricChecks) {
      _checkResults[check] = false;
    }
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    _pulseController.repeat(reverse: true);
    _scaleController.forward();
    _rotateController.repeat();
    _breatheController.repeat(reverse: true);
  }

  void _shakeOverlay() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  Future<void> _checkPermissionsAndInitialize() async {
    try {
      // Check camera permission
      var cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        setState(() {
          _showError = true;
          _errorMessage = 'Camera access required for attendance verification';
        });
        if (cameraStatus.isPermanentlyDenied) {
          await openAppSettings();
        }
        return;
      }

      // Check location permission
      var locationStatus = await Permission.location.request();
      if (!locationStatus.isGranted) {
        setState(() {
          _showError = true;
          _errorMessage =
              'Location access required for attendance verification';
        });
        return;
      }

      await Future.wait([
        _initializeCamera(),
        // _initializeLocation(),
      ]);
    } catch (e) {
      setState(() {
        _showError = true;
        _errorMessage = 'Initialization failed: ${e.toString()}';
      });
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No camera available');
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _checkResults['Face Detection'] = true;
        });
        _startFaceDetection();
      }
    } catch (e) {
      setState(() {
        _showError = true;
        _errorMessage = 'Camera initialization failed: ${e.toString()}';
      });
    }
  }

  // Future<void> _initializeLocation() async {
  //   try {
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       setState(() {
  //         _locationStatus = 'Location services disabled';
  //       });
  //       return;
  //     }

  //     _currentPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     if (_currentPosition != null) {
  //       double distance = Geolocator.distanceBetween(
  //         _currentPosition!.latitude,
  //         _currentPosition!.longitude,
  //         widget.requiredLatitude,
  //         widget.requiredLongitude,
  //       );

  //       setState(() {
  //         _isLocationValid = distance <= widget.allowedRadius;
  //         _locationStatus = _isLocationValid
  //             ? 'Within range (${distance.round()}m)'
  //             : 'Out of range (${distance.round()}m)';
  //         _checkResults['Location Verification'] = _isLocationValid;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _locationStatus = 'Location error: ${e.toString()}';
  //     });
  //   }
  // }

  void _startConnectivityMonitoring() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      setState(() {
        _isOnline = !results.contains(ConnectivityResult.none);
      });
    });
  }

  void _startFaceDetection() {
    _detectionTimer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (!_isCameraInitialized || _isAttendanceMarked) return;

      _simulateAdvancedFaceDetection();
    });
  }

  void _simulateAdvancedFaceDetection() {
    // Enhanced simulation with more realistic patterns
    final random = math.Random();

    setState(() {
      // Simulate face alignment with some variance
      _faceAlignmentScore = math.max(
          0.0,
          math.min(
              1.0, _faceAlignmentScore + (random.nextDouble() - 0.5) * 0.3));

      // Simulate lighting conditions
      _lightingScore = math.max(0.0,
          math.min(1.0, _lightingScore + (random.nextDouble() - 0.5) * 0.2));

      // Simulate face confidence
      _faceConfidenceScore = math.max(
          0.0,
          math.min(
              1.0, _faceConfidenceScore + (random.nextDouble() - 0.5) * 0.25));

      // Track stability
      _stabilityReadings.add(_faceAlignmentScore);
      if (_stabilityReadings.length > 10) {
        _stabilityReadings.removeAt(0);
      }

      // Calculate stability score
      if (_stabilityReadings.length >= 5) {
        double variance = _calculateVariance(_stabilityReadings);
        _stabilityScore = math.max(0.0, 1.0 - variance * 10);
        _checkResults['Stability Check'] = _stabilityScore > 0.7;
      }

      // Simulate eye and mouth detection
      _eyesDetected = _faceConfidenceScore > 0.6 && random.nextBool();
      _mouthDetected = _faceConfidenceScore > 0.5 && random.nextBool();

      _checkResults['Eye Detection'] = _eyesDetected;
      _checkResults['Lighting Analysis'] = _lightingScore > 0.6;

      _updateInstructionText();
    });
  }

  double _calculateVariance(List<double> values) {
    if (values.isEmpty) return 0.0;
    double mean = values.reduce((a, b) => a + b) / values.length;
    double variance =
        values.map((x) => math.pow(x - mean, 2)).reduce((a, b) => a + b) /
            values.length;
    return variance;
  }

  void _updateInstructionText() {
    if (_faceAlignmentScore < 0.4) {
      _instructionText = 'Move closer and center your face';
    } else if (_lightingScore < 0.5) {
      _instructionText = 'Improve lighting - face your light source';
    } else if (!_eyesDetected) {
      _instructionText = 'Look directly at the camera';
    } else if (_stabilityScore < 0.6) {
      _instructionText = 'Hold still for better detection';
    } else if (_faceConfidenceScore > 0.8 && _stabilityScore > 0.7) {
      _instructionText = 'Perfect! Ready for capture';
    } else {
      _instructionText = 'Almost ready - maintain position';
    }
  }

  bool get _canCapture {
    return _faceAlignmentScore > 0.7 &&
        _lightingScore > 0.6 &&
        _faceConfidenceScore > 0.8 &&
        _stabilityScore > 0.7 &&
        _eyesDetected &&
        _isLocationValid &&
        _isOnline;
  }

  Future<void> _handleCapture() async {
    if (_captureAttempts >= _maxAttempts) {
      setState(() {
        _showError = true;
        _errorMessage = 'Maximum attempts reached. Please contact support.';
      });
      _shakeOverlay();
      return;
    }

    if (!_canCapture) {
      setState(() {
        _showError = true;
        _errorMessage = 'Please satisfy all verification requirements.';
        _captureAttempts++;
      });
      _shakeOverlay();
      return;
    }

    setState(() {
      _isCapturing = true;
      _showError = false;
    });

    try {
      // Simulate enhanced biometric verification
      await _performBiometricVerification();

      // Mock attendance result with enhanced data
      setState(() {
        _isCapturing = false;
        _isAttendanceMarked = true;
        _attendanceResult = {
          'courseId': widget.courseId,
          'courseName': widget.courseName,
          'studentId': 'STU12345', // Would come from auth
          'studentName': 'John Doe', // Would come from auth
          'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'time': DateFormat('HH:mm:ss').format(DateTime.now()),
          'status': 'Present',
          'location': _locationStatus,
          'confidence': _faceConfidenceScore,
          'biometricScore': _calculateOverallScore(),
          'verificationMethod': 'Facial Recognition + Location',
        };
        _instructionText = 'Attendance verified successfully!';
      });

      _showSuccessSnackBar();
    } catch (e) {
      setState(() {
        _isCapturing = false;
        _showError = true;
        _errorMessage = 'Verification failed: ${e.toString()}';
        _captureAttempts++;
      });
      _shakeOverlay();
    }
  }

  Future<void> _performBiometricVerification() async {
    // Simulate multi-step verification process
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 400));
      // Update progress or show verification steps
    }
  }

  double _calculateOverallScore() {
    return (_faceAlignmentScore +
            _lightingScore +
            _faceConfidenceScore +
            _stabilityScore) /
        4;
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Attendance marked for ${widget.courseName}'),
          ],
        ),
        backgroundColor: AppColors.passwordStrengthStrong,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _handleRetake() {
    setState(() {
      _isAttendanceMarked = false;
      _showError = false;
      _instructionText = 'Position your face in the frame';
      _captureAttempts = 0;
      _attendanceResult = null;
    });
    _startFaceDetection();
  }

  void _handleConfirm() {
    Navigator.pop(context, _attendanceResult);
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          ScaleTransition(
            scale: _breatheAnimation,
            child: Container(
              width: 90,
              height: 90,
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
              child: const Icon(
                Icons.face_retouching_natural,
                size: 45,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Biometric Attendance',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.courseName} • ${widget.classTime}',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _buildConnectionStatus(),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _isOnline
            ? AppColors.passwordStrengthStrong.withOpacity(0.1)
            : AppColors.errorAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isOnline
              ? AppColors.passwordStrengthStrong
              : AppColors.errorAccent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
            _isOnline ? 'Connected' : 'Offline Mode',
            style: TextStyle(
              color: _isOnline
                  ? AppColors.passwordStrengthStrong
                  : AppColors.errorAccent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: Container(
              height: 400,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _canCapture
                      ? AppColors.passwordStrengthStrong
                      : AppColors.formContainerBorder,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowWithOpacity,
                    blurRadius: 25,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(27),
                child: Stack(
                  children: [
                    // Camera Preview
                    _buildCameraView(),

                    // Enhanced Face Detection Overlay
                    _buildFaceOverlay(),

                    // Instruction Panel
                    _buildInstructionPanel(),

                    // Error Panel
                    if (_showError) _buildErrorPanel(),

                    // Biometric Indicators
                    _buildBiometricIndicators(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCameraView() {
    if (_isCameraInitialized && _cameraController != null) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _cameraController!.value.previewSize?.height ?? 0,
            height: _cameraController!.value.previewSize?.width ?? 0,
            child: CameraPreview(_cameraController!),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.shadow,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primaryAccent,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Initializing Camera...',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaceOverlay() {
    return Center(
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: Container(
          width: 220,
          height: 320,
          decoration: BoxDecoration(
            border: Border.all(
              color: _canCapture
                  ? AppColors.passwordStrengthStrong
                  : _faceAlignmentScore > 0.5
                      ? AppColors.primaryAccent
                      : AppColors.errorAccent,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(60),
          ),
          child: Stack(
            children: [
              // Corner indicators
              ...List.generate(4, (index) => _buildCornerIndicator(index)),

              // Center confidence indicator
              if (_faceConfidenceScore > 0.5)
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryAccent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _eyesDetected ? Icons.visibility : Icons.face,
                      color: AppColors.primaryAccent,
                      size: 30,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCornerIndicator(int index) {
    final positions = [
      const Alignment(-0.8, -0.8), // Top-left
      const Alignment(0.8, -0.8), // Top-right
      const Alignment(-0.8, 0.8), // Bottom-left
      const Alignment(0.8, 0.8), // Bottom-right
    ];

    return Align(
      alignment: positions[index],
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: _faceAlignmentScore > 0.6
              ? AppColors.passwordStrengthStrong
              : AppColors.errorAccent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildInstructionPanel() {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.formContainerBackground.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.formContainerBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              _canCapture ? Icons.check_circle : Icons.info_outline,
              color: _canCapture
                  ? AppColors.passwordStrengthStrong
                  : AppColors.primaryAccent,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _instructionText,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPanel() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.errorBackground,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.errorBorder),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.errorAccent,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _errorMessage,
                style: const TextStyle(
                  color: AppColors.errorAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricIndicators() {
    return Positioned(
      right: 10,
      top: 80,
      child: Column(
        children: _biometricChecks.map((check) {
          bool isComplete = _checkResults[check] ?? false;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isComplete
                  ? AppColors.passwordStrengthStrong.withOpacity(0.2)
                  : AppColors.errorAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isComplete ? Icons.check : Icons.close,
              color: isComplete
                  ? AppColors.passwordStrengthStrong
                  : AppColors.errorAccent,
              size: 16,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVerificationStatus() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.formContainerBackground,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.formContainerBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowWithOpacity,
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verification Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatusRow('Face Detection', _faceAlignmentScore, Icons.face),
            const SizedBox(height: 12),
            _buildStatusRow('Lighting Quality', _lightingScore, Icons.wb_sunny),
            const SizedBox(height: 12),
            _buildStatusRow('Confidence', _faceConfidenceScore, Icons.security),
            const SizedBox(height: 12),
            _buildStatusRow('Stability', _stabilityScore, Icons.video_stable),
            const SizedBox(height: 16),
            _buildLocationStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, double score, IconData icon) {
    Color color = score > 0.7
        ? AppColors.passwordStrengthStrong
        : score > 0.4
            ? AppColors.primaryAccent
            : AppColors.errorAccent;

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: score,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${(score * 100).round()}%',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isLocationValid
            ? AppColors.passwordStrengthStrong.withOpacity(0.1)
            : AppColors.errorAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isLocationValid
              ? AppColors.passwordStrengthStrong
              : AppColors.errorAccent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isLocationValid ? Icons.location_on : Icons.location_off,
            color: _isLocationValid
                ? AppColors.passwordStrengthStrong
                : AppColors.errorAccent,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location Status',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _locationStatus,
                  style: TextStyle(
                    color: _isLocationValid
                        ? AppColors.passwordStrengthStrong
                        : AppColors.errorAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSummary() {
    if (_attendanceResult == null) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.gradientAccentStart,
              AppColors.gradientAccentEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentShadow.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Attendance Verified',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildResultRow(
              'Course',
              _attendanceResult!['courseName'],
              Icons.school,
            ),
            const SizedBox(height: 12),
            _buildResultRow(
              'Date & Time',
              '${_attendanceResult!['date']} at ${_attendanceResult!['time']}',
              Icons.schedule,
            ),
            const SizedBox(height: 12),
            _buildResultRow(
              'Status',
              _attendanceResult!['status'],
              Icons.check_circle,
            ),
            const SizedBox(height: 12),
            _buildResultRow(
              'Verification Score',
              '${(_attendanceResult!['biometricScore'] * 100).round()}%',
              Icons.security,
            ),
            const SizedBox(height: 12),
            _buildResultRow(
              'Method',
              _attendanceResult!['verificationMethod'],
              Icons.fingerprint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Primary Action Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _isCapturing ||
                      (!_isAttendanceMarked && _captureAttempts >= _maxAttempts)
                  ? null
                  : (_isAttendanceMarked ? _handleConfirm : _handleCapture),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAttendanceMarked
                    ? AppColors.passwordStrengthStrong
                    : AppColors.primaryAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 12,
                shadowColor: AppColors.accentShadow,
                disabledBackgroundColor: AppColors.divider,
              ),
              child: _isCapturing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Verifying...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isAttendanceMarked
                              ? Icons.check_circle
                              : Icons.camera_alt,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _isAttendanceMarked
                              ? 'Confirm Attendance'
                              : 'Verify Attendance',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          // Secondary Action Button
          if (_isAttendanceMarked) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _handleRetake,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.errorAccent,
                  side:
                      const BorderSide(color: AppColors.errorAccent, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Retake',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Attempts Counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.formContainerBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.formContainerBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.secondaryText,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Attempts: ${_maxAttempts - _captureAttempts} remaining',
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
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
              AppColors.backgroundGradientMid2,
              AppColors.backgroundGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 24),
                _buildCameraPreview(),
                const SizedBox(height: 16),
                if (!_isAttendanceMarked) _buildVerificationStatus(),
                if (_isAttendanceMarked) _buildResultSummary(),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _scaleController.dispose();
    _shakeController.dispose();
    _rotateController.dispose();
    _breatheController.dispose();
    _cameraController?.dispose();
    _detectionTimer?.cancel();
    _stabilityTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
