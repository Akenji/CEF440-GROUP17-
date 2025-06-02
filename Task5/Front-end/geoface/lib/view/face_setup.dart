import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../utils/app_colors.dart';

class FacialRecognitionSetupScreen extends StatefulWidget {
  const FacialRecognitionSetupScreen({Key? key}) : super(key: key);

  @override
  State<FacialRecognitionSetupScreen> createState() =>
      _FacialRecognitionSetupScreenState();
}

class _FacialRecognitionSetupScreenState
    extends State<FacialRecognitionSetupScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scaleAnimation;

  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  bool _isCaptureComplete = false;
  bool _showError = false;
  String _instructionText = 'Look straight at the camera';
  String _errorMessage = '';
  int _captureStep = 1; // 1: Front, 2: Left, 3: Right
  double _faceAlignmentScore = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeCamera();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutSine,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      _slideController.forward();
    });
    _pulseController.repeat(reverse: true);
    _scaleController.forward();
  }

  void _shakeOverlay() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _showError = true;
          _errorMessage = 'No camera available on this device';
        });
        return;
      }
      _cameraController = CameraController(
        cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front),
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
      // Simulate face detection feedback
      _simulateFaceDetection();
    } catch (e) {
      setState(() {
        _showError = true;
        _errorMessage = 'Failed to initialize camera: $e';
      });
    }
  }

  void _simulateFaceDetection() {
    // Simulate face alignment and lighting checks
    Future.doWhile(() async {
      if (!_isCameraInitialized || _isCaptureComplete) return false;
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _faceAlignmentScore = (_faceAlignmentScore + 0.2) % 1.0;
        if (_faceAlignmentScore < 0.3) {
          _instructionText = 'Adjust your position: Center your face';
        } else if (_faceAlignmentScore < 0.6) {
          _instructionText = 'Improve lighting: Ensure even light';
        } else {
          _instructionText = 'Face detected! Ready to capture';
        }
      });
      return true;
    });
  }

  Future<void> _handleCapture() async {
    if (_faceAlignmentScore < 0.6) {
      setState(() {
        _showError = true;
        _errorMessage = 'Please align your face properly';
      });
      _shakeOverlay();
      return;
    }

    setState(() {
      _isCapturing = true;
      _showError = false;
    });

    // Simulate capturing image
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isCapturing = false;
      if (_captureStep == 1) {
        _captureStep = 2;
        _instructionText = 'Turn slightly to the left';
      } else if (_captureStep == 2) {
        _captureStep = 3;
        _instructionText = 'Turn slightly to the right';
      } else {
        _isCaptureComplete = true;
        _instructionText = 'Facial setup complete!';
      }
    });
  }

  void _handleRetake() {
    setState(() {
      _captureStep = 1;
      _isCaptureComplete = false;
      _instructionText = 'Look straight at the camera';
      _showError = false;
    });
    _simulateFaceDetection();
  }

  void _handleContinue() {
    // Navigate to Permission Setup Screen
    Navigator.pushNamed(context, '/permission_setup');
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
          child: Column(
            children: [
              // Animated Header
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.gradientAccentStart,
                                AppColors.gradientAccentEnd,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentShadow,
                                blurRadius: 25,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 40,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Facial Recognition Setup',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Capture your face for attendance verification',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Camera Preview and Overlay
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          _shakeAnimation.value *
                              (_shakeController.status ==
                                      AnimationStatus.reverse
                                  ? -1
                                  : 1),
                          0,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                                color: AppColors.formContainerBorder),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowWithOpacity,
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Stack(
                              children: [
                                // Camera Preview
                                _isCameraInitialized &&
                                        _cameraController != null
                                    ? CameraPreview(_cameraController!)
                                    : Container(
                                        color: AppColors.shadow,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primaryAccent,
                                          ),
                                        ),
                                      ),

                                // Face Detection Overlay
                                ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Center(
                                    child: Container(
                                      width: 200,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _faceAlignmentScore > 0.6
                                              ? AppColors.passwordStrengthStrong
                                              : AppColors.errorAccent,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                ),

                                // Instruction Text
                                Positioned(
                                  top: 20,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    decoration: BoxDecoration(
                                      color: AppColors.formContainerBackground,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: AppColors.formContainerBorder),
                                    ),
                                    child: Text(
                                      _instructionText,
                                      style: const TextStyle(
                                        color: AppColors.primaryText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),

                                // Error Message
                                if (_showError)
                                  Positioned(
                                    bottom: 20,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.errorBackground,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.errorBorder),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.error_outline,
                                            color: AppColors.errorAccent,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _errorMessage,
                                              style: const TextStyle(
                                                color: AppColors.errorAccent,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Controls
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (_showError) const SizedBox(height: 20),

                    // Capture/Continue Button
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isCapturing
                            ? null
                            : (_isCaptureComplete
                                ? _handleContinue
                                : _handleCapture),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAccent,
                          foregroundColor: AppColors.primaryText,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 15,
                          shadowColor: AppColors.accentShadow,
                        ),
                        child: _isCapturing
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryText,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Capturing...',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              )
                            : Text(
                                _isCaptureComplete
                                    ? 'Continue'
                                    : 'Capture (Step $_captureStep/3)',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    if (_isCaptureComplete)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextButton(
                          onPressed: _handleRetake,
                          child: const Text(
                            'Retake',
                            style: TextStyle(
                              color: AppColors.primaryAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
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
    _shakeController.dispose();
    _scaleController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }
}
