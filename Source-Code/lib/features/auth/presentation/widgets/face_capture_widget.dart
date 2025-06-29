import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:typed_data';

import '../../../../core/services/face_recognition_service.dart';
import '../../../../core/services/supabase_service.dart';

class FaceCaptureWidget extends StatefulWidget {
  final Function(List<double> encoding, String imagePath) onFaceCaptured;
  final double? faceDetectionThreshold;
  final Duration? faceDetectionInterval;

  const FaceCaptureWidget({
    super.key,
    required this.onFaceCaptured,
    this.faceDetectionThreshold = 0.7,
    this.faceDetectionInterval = const Duration(milliseconds: 500),
  });

  @override
  State<FaceCaptureWidget> createState() => FaceCaptureWidgetState();
}

class FaceCaptureWidgetState extends State<FaceCaptureWidget> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  CameraDescription? _currentCamera;
  bool _isInitialized = false;
  bool _isCapturing = false;
  bool _faceDetected =
      false; // Indicates if a good quality face is detected for auto-capture
  bool _isProcessingStream = false;
  String? _statusMessage;
  DateTime? _lastDetectionTime;
  List<Face>?
      _detectedFaces; // Stores all detected faces, regardless of quality

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _disposeCamera();
    super.dispose();
  }

  Future<void> _disposeCamera() async {
    try {
      if (_cameraController != null) {
        if (_cameraController!.value.isStreamingImages) {
          await _cameraController!.stopImageStream();
        }
        await _cameraController!.dispose();
      }
    } catch (e) {
      debugPrint('Camera disposal error: $e');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() {
        _statusMessage = 'Initializing camera...';
      });

      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _statusMessage = 'No cameras available on this device';
        });
        return;
      }

      // Prefer front camera for face capture
      _currentCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        _currentCamera!,
        ResolutionPreset.high, // Increased resolution for better accuracy
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420, // Ensure consistent format
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _statusMessage = 'Position your face in the frame';
        });
      }

      // Start face detection with a small delay
      await Future.delayed(const Duration(milliseconds: 500));
      _startFaceDetection();
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Camera initialization failed: ${e.toString()}';
        });
      }
    }
  }

  void _startFaceDetection() {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _cameraController!.value.isStreamingImages) {
      return;
    }

    try {
      _cameraController!.startImageStream((CameraImage image) async {
        if (_isCapturing || _isProcessingStream) return;

        // Throttle detection to avoid overwhelming the system
        final now = DateTime.now();
        if (_lastDetectionTime != null &&
            now.difference(_lastDetectionTime!) <
                (widget.faceDetectionInterval ??
                    const Duration(milliseconds: 500))) {
          return;
        }

        _lastDetectionTime = now;
        _isProcessingStream = true;

        try {
          // Pass the current camera description to the service
          final faces =
              await FaceRecognitionService.detectFaces(image, _currentCamera!);

          if (mounted) {
            setState(() {
              _detectedFaces = faces; // Store all detected faces
              _faceDetected = faces.isNotEmpty &&
                  faces.length == 1 && // Only one face for auto-capture
                  _isFaceQualityGood(
                      faces.first); // Check quality for auto-capture
              _updateStatusMessage(faces);
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _statusMessage = 'Face detection error: ${e.toString()}';
              _faceDetected = false;
              _detectedFaces = null;
            });
          }
        } finally {
          _isProcessingStream = false;
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Failed to start face detection: ${e.toString()}';
        });
      }
    }
  }

  void _updateStatusMessage(List<Face> faces) {
    if (faces.isEmpty) {
      _statusMessage =
          'No face detected. Please position your face in the frame.';
    } else if (faces.length > 1) {
      _statusMessage =
          'Multiple faces detected. Please ensure only one face is visible.';
    } else {
      final face = faces.first;
      // _isFaceQualityGood already sets the specific status message if a quality issue is found
      if (_isFaceQualityGood(face)) {
        _statusMessage = 'Face detected! Tap capture to continue.';
      }
      // If _isFaceQualityGood returns false, it would have already updated _statusMessage
    }
  }

  bool _isFaceQualityGood(Face face) {
    // Check if face is large enough (minFaceArea)
    final faceArea = face.boundingBox.width * face.boundingBox.height;
    const double minFaceArea =
        180 * 180; // Increased minimum area (e.g., 180x180 pixels)

    if (faceArea < minFaceArea) {
      _statusMessage = 'Face too small. Please move closer to the camera.';
      return false;
    }

    // Check if face is centered enough relative to the widget's displayed size
    final previewSize = _cameraController?.value.previewSize;
    if (previewSize == null || context.size == null) {
      _statusMessage = 'Camera preview size or widget size not available.';
      return false;
    }

    // Scale the face bounding box to the widget's actual render box
    // Note: CameraPreview might rotate the image, so previewSize.width/height might be swapped
    final double scaleX = context.size!.width / previewSize.height;
    final double scaleY = context.size!.height / previewSize.width;

    final scaledFaceRect = Rect.fromLTRB(
      face.boundingBox.left * scaleX,
      face.boundingBox.top * scaleY,
      face.boundingBox.right * scaleX,
      face.boundingBox.bottom * scaleY,
    );

    final faceCenter = scaledFaceRect.center;
    final widgetCenter =
        Offset(context.size!.width / 2, context.size!.height / 2);
    final distance = (faceCenter - widgetCenter).distance;

    // Max acceptable distance from center, relative to the widget's smallest dimension
    const double maxCenterDistanceRatio =
        0.25; // e.g., 25% of the widget's shortest side
    final double maxCenterDistance =
        maxCenterDistanceRatio * (context.size!.shortestSide);

    if (distance > maxCenterDistance) {
      _statusMessage = 'Please center your face in the frame.';
      return false;
    }

    // Check head pose (yaw and pitch)
    // A small deviation is acceptable, but large angles indicate the user is not facing directly.
    const double maxAngleDeviation =
        15.0; // Max acceptable angle in degrees (adjust as needed)

    if (face.headEulerAngleY != null &&
        face.headEulerAngleY!.abs() > maxAngleDeviation) {
      _statusMessage =
          'Please face the camera directly (reduce side-to-side head turn).';
      return false;
    }
    if (face.headEulerAngleX != null &&
        face.headEulerAngleX!.abs() > maxAngleDeviation) {
      _statusMessage =
          'Please face the camera directly (reduce up-down head tilt).';
      return false;
    }
    if (face.headEulerAngleZ != null &&
        face.headEulerAngleZ!.abs() > maxAngleDeviation) {
      _statusMessage = 'Please keep your head straight (reduce head roll).';
      return false;
    }

    // Check eye open probability for liveness and quality
    const double minEyeOpenProbability =
        0.7; // Minimum probability for eyes to be considered open
    if (face.leftEyeOpenProbability != null &&
            face.leftEyeOpenProbability! < minEyeOpenProbability ||
        face.rightEyeOpenProbability != null &&
            face.rightEyeOpenProbability! < minEyeOpenProbability) {
      _statusMessage = 'Please open your eyes wider.';
      return false;
    }

    // Optional: Check for smiling probability if required for liveness
    // const double minSmilingProbability = 0.1;
    // if (face.smilingProbability != null && face.smilingProbability! < minSmilingProbability) {
    //   _statusMessage = 'Please show a slight smile.';
    //   return false;
    // }

    _statusMessage = 'Face detected and quality good.';
    return true;
  }

  /// Internal method to capture and process the face.
  /// Returns a map containing 'encoding' (List<double>) and 'imagePath' (String) on success,
  /// or null on failure.
  Future<Map<String, dynamic>?> _captureAndProcessFaceInternal() async {
    // Ensure a single face is detected before proceeding
    if (_detectedFaces == null || _detectedFaces!.isEmpty) {
      if (mounted) {
        _showErrorDialog('No face detected. Please try again.');
      }
      return null;
    }

    if (_detectedFaces!.length > 1) {
      if (mounted) {
        _showErrorDialog(
            'Multiple faces detected. Please ensure only one face is visible.');
      }
      return null;
    }

    final bestFace = _detectedFaces!.first;

    // Apply quality checks even for manual capture attempts.
    if (!_isFaceQualityGood(bestFace)) {
      if (mounted) {
        _showErrorDialog(
            _statusMessage ?? 'Face quality not sufficient. Please try again.');
      }
      return null;
    }

    setState(() {
      _isCapturing = true;
      _statusMessage = 'Processing face data...';
    });

    try {
      // Stop image stream before taking picture to avoid conflicts
      if (_cameraController!.value.isStreamingImages) {
        await _cameraController!.stopImageStream();
      }

      // Small delay to ensure stream is stopped
      await Future.delayed(const Duration(milliseconds: 100));

      // Capture image
      final XFile imageFile = await _cameraController!.takePicture();

      // Read image bytes for upload
      final Uint8List imageBytes = await imageFile.readAsBytes();

      // Extract face features using the service with the already detected best face
      final faceFeatures = FaceRecognitionService.extractFaceFeatures(bestFace);

      if (faceFeatures.isEmpty) {
        throw Exception(
            'Failed to extract face features from the detected face. Please try again.');
      }

      // Upload image to Supabase storage
      setState(() {
        _statusMessage = 'Uploading image...';
      });

      final fileName = 'face_${DateTime.now().millisecondsSinceEpoch}.jpg';
      String imageUrl = '';

      try {
        await SupabaseService.storage.from('face-images').uploadBinary(
            fileName, imageBytes,
            fileOptions: const FileOptions(upsert: false));

        // Get public URL
        imageUrl =
            SupabaseService.storage.from('face-images').getPublicUrl(fileName);

        setState(() {
          _statusMessage = 'Face captured successfully!';
        });

        return {
          'encoding': faceFeatures,
          'imagePath': imageUrl,
        };
      } catch (storageError) {
        throw Exception('Failed to upload image: ${storageError.toString()}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Face capture failed: ${e.toString()}';
        });

        // Show error dialog
        _showErrorDialog(e.toString());

        // Restart face detection after error
        await Future.delayed(const Duration(seconds: 2));
        _startFaceDetection(); // Restart stream for continued detection
      }
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  /// Public method to manually trigger face capture.
  /// Returns a map containing 'encoding' (List<double>) and 'imagePath' (String) on success,
  /// or null on failure.
  Future<Map<String, dynamic>?> captureImageManually() async {
    if (!_isInitialized ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      _showErrorDialog('Camera not initialized. Cannot capture manually.');
      return null;
    }
    if (_isCapturing) {
      _showErrorDialog('Already capturing. Please wait.');
      return null;
    }
    if (_detectedFaces == null || _detectedFaces!.isEmpty) {
      _showErrorDialog(
          'No face detected to capture manually. Please position your face.');
      return null;
    }

    final result = await _captureAndProcessFaceInternal();
    if (result != null) {
      // Call the widget's callback if capture was successful
      widget.onFaceCaptured(
          result['encoding'] as List<double>, result['imagePath'] as String);
      await Future.delayed(
          const Duration(seconds: 2)); // Auto-close after success (optional)
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
    return result;
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Capture Failed'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  InputImageRotation _getInputImageRotation() {
    if (_currentCamera == null) return InputImageRotation.rotation0deg;

    switch (_currentCamera!.sensorOrientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<void> _retryCapture() async {
    await _disposeCamera();
    await _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _faceDetected ? Colors.green : Colors.grey,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // Camera Preview
            if (_isInitialized &&
                _cameraController != null &&
                _cameraController!.value.isInitialized)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    // These dimensions are often swapped for portrait camera preview
                    width: _cameraController!.value.previewSize?.height ?? 0,
                    height: _cameraController!.value.previewSize?.width ?? 0,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              )
            else
              Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),

            // Face Detection Overlay
            if (_detectedFaces != null && _detectedFaces!.isNotEmpty)
              CustomPaint(
                painter: FaceDetectionPainter(
                  faces: _detectedFaces!,
                  // Pass the actual camera preview size for scaling
                  imageSize: Size(
                    _cameraController!.value.previewSize?.width ?? 0,
                    _cameraController!.value.previewSize?.height ?? 0,
                  ),
                  cameraLensDirection: _currentCamera?.lensDirection ??
                      CameraLensDirection.front,
                ),
                child: Container(),
              ),

            // Status Message and Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _statusMessage ?? 'Initializing...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Retry button
                        if (!_isInitialized ||
                            (_statusMessage?.contains('failed') == true ||
                                _statusMessage?.contains('error') == true))
                          ElevatedButton.icon(
                            onPressed: _isCapturing ? null : _retryCapture,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),

                        // Automatic Capture button (enabled only when good quality face detected)
                        if (_faceDetected && !_isCapturing && _isInitialized)
                          ElevatedButton.icon(
                            onPressed: () async {
                              final result =
                                  await _captureAndProcessFaceInternal();
                              if (result != null) {
                                widget.onFaceCaptured(
                                    result['encoding'] as List<double>,
                                    result['imagePath'] as String);
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                if (mounted) {
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Capture Face (Auto)'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),

                        // Manual Capture button (enabled if any face is detected)
                        // This button calls the public method which includes its own checks and calls the callback.
                        if ((_detectedFaces != null &&
                                _detectedFaces!.isNotEmpty) &&
                            !_isCapturing &&
                            _isInitialized)
                          ElevatedButton.icon(
                            onPressed: () =>
                                captureImageManually(), // Call the public method
                            icon: const Icon(Icons.touch_app),
                            label: const Text('Manual Capture'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Loading Overlay
            if (_isCapturing)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Processing face data...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for face detection overlay
class FaceDetectionPainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final CameraLensDirection cameraLensDirection;

  FaceDetectionPainter({
    required this.faces,
    required this.imageSize,
    required this.cameraLensDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Adjust scale based on camera lens direction for correct mirroring
    final bool isFrontCamera = cameraLensDirection == CameraLensDirection.front;
    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;

    for (final face in faces) {
      Rect rect = face.boundingBox;

      // Mirror the bounding box horizontally for front camera
      if (isFrontCamera) {
        rect = Rect.fromLTRB(
          imageSize.width - rect.right,
          rect.top,
          imageSize.width - rect.left,
          rect.bottom,
        );
      }

      final scaledRect = Rect.fromLTRB(
        rect.left * scaleX,
        rect.top * scaleY,
        rect.right * scaleX,
        rect.bottom * scaleY,
      );

      canvas.drawRect(scaledRect, paint);

      // Draw face landmarks if available
      _drawLandmarks(canvas, face, size, paint, isFrontCamera, scaleX, scaleY);
    }
  }

  void _drawLandmarks(Canvas canvas, Face face, Size canvasSize, Paint paint,
      bool isFrontCamera, double scaleX, double scaleY) {
    paint.style = PaintingStyle.fill;
    paint.color = Colors.red;

    for (final landmark in face.landmarks.values) {
      if (landmark != null) {
        double x = landmark.position.x.toDouble();
        if (isFrontCamera) {
          x = (imageSize.width - x); // Mirror X coordinate
        }

        final point = Offset(
          x * scaleX,
          landmark.position.y * scaleY,
        );
        canvas.drawCircle(point, 3.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
