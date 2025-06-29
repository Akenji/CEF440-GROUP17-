import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import '../../../../core/services/face_recognition_service.dart';

class CameraPreviewWidget extends StatefulWidget {
  final Function(bool isVerified, List<double>? faceFeatures) onFaceVerified;
  final List<double>? referenceFaceFeatures;
  final double verificationThreshold;
  final Duration detectionInterval;
  final double minFaceSize;
  final bool enableContinuousVerification;
  final Function(List<double> faceFeatures)? onManualCapture;

  const CameraPreviewWidget({
    super.key,
    required this.onFaceVerified,
    this.referenceFaceFeatures,
    this.verificationThreshold = 0.8,
    this.detectionInterval = const Duration(milliseconds: 500),
    this.minFaceSize = 50.0,
    this.enableContinuousVerification = true,
    this.onManualCapture,
  });

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  CameraController? _cameraController;
  CameraDescription? _currentCamera;
  bool _isInitialized = false;
  bool _faceDetected = false;
  bool _faceVerified = false;
  bool _isProcessingStream = false;
  String _statusMessage = 'Initializing camera...';
  DateTime? _lastDetectionTime;
  List<Face>? _detectedFaces;
  double _lastVerificationScore = 0.0;
  bool _isCapturing = false;
  bool _showManualCaptureButton = false;

  // Debugging variables
  bool _debugMode = true;
  String _debugInfo = '';

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

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _statusMessage = 'No cameras available on this device';
          _showManualCaptureButton = false;
        });
        return;
      }

      // Prefer front camera for face verification
      _currentCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        _currentCamera!,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _statusMessage = _getInitialStatusMessage();
          _debugInfo =
              'Camera: ${_currentCamera!.name}, Resolution: ${_cameraController!.value.previewSize}';
          _showManualCaptureButton = true;
        });

        // Start face detection with initialization delay
        await Future.delayed(const Duration(milliseconds: 1000));
        if (mounted) {
          _startFaceDetection();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Camera error: ${e.toString()}';
          _showManualCaptureButton = false;
        });
      }
    }
  }

  String _getInitialStatusMessage() {
    if (widget.referenceFaceFeatures != null) {
      return 'Position your face for verification';
    } else {
      return 'Position your face in the frame';
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
        if (_isProcessingStream || _isCapturing) return;

        final now = DateTime.now();
        if (_lastDetectionTime != null &&
            now.difference(_lastDetectionTime!) < widget.detectionInterval) {
          return;
        }

        _lastDetectionTime = now;
        _isProcessingStream = true;

        try {
          final faces = await _detectFacesFromCameraImage(image);

          if (mounted) {
            setState(() {
              _debugInfo =
                  'Frame: ${image.width}x${image.height}, Format: ${image.format.group.name}, Faces: ${faces.length}';
            });
            await _processFaceDetectionResults(faces);
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _statusMessage = 'Face detection error. Try manual capture.';
              _debugInfo = 'Error: $e';
              _faceDetected = false;
              _faceVerified = false;
              _showManualCaptureButton = true;
            });
            _notifyVerificationResult(false, null);
          }
        } finally {
          _isProcessingStream = false;
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage =
              'Failed to start face detection. Use manual capture.';
          _showManualCaptureButton = true;
        });
      }
    }
  }

  Future<List<Face>> _detectFacesFromCameraImage(CameraImage image) async {
    try {
      // Use only the first plane for most image formats
      final plane = image.planes.first;

      final inputImageFormat = _getInputImageFormat(image.format);
      if (inputImageFormat == null) {
        throw Exception('Unsupported image format: ${image.format.group}');
      }

      final imageRotation = _getImageRotation();

      final inputImage = InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: imageRotation,
          format: inputImageFormat,
          bytesPerRow: plane.bytesPerRow,
        ),
      );

      final options = FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
        enableClassification: true,
        enableTracking: false,
        minFaceSize: 0.1,
        performanceMode: FaceDetectorMode.accurate,
      );

      final faceDetector = FaceDetector(options: options);
      final List<Face> faces = await faceDetector.processImage(inputImage);

      await faceDetector.close();
      return faces;
    } catch (e) {
      debugPrint('Face detection error: $e');
      rethrow;
    }
  }

  Future<List<Face>> _detectFacesFromImageFile(XFile imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);

      final options = FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
        enableClassification: true,
        enableTracking: false,
        minFaceSize: 0.1,
        performanceMode: FaceDetectorMode.accurate,
      );

      final faceDetector = FaceDetector(options: options);
      final List<Face> faces = await faceDetector.processImage(inputImage);

      await faceDetector.close();
      return faces;
    } catch (e) {
      debugPrint('Face detection from file error: $e');
      rethrow;
    }
  }

  InputImageRotation _getImageRotation() {
    if (_currentCamera == null) return InputImageRotation.rotation0deg;

    // Adjust rotation based on camera orientation
    switch (_currentCamera!.sensorOrientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return _currentCamera!.lensDirection == CameraLensDirection.front
            ? InputImageRotation.rotation270deg
            : InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return _currentCamera!.lensDirection == CameraLensDirection.front
            ? InputImageRotation.rotation90deg
            : InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  InputImageFormat? _getInputImageFormat(ImageFormat format) {
    switch (format.group) {
      case ImageFormatGroup.yuv420:
        return InputImageFormat.yuv420;
      case ImageFormatGroup.bgra8888:
        return InputImageFormat.bgra8888;
      case ImageFormatGroup.nv21:
        return InputImageFormat.nv21;
      case ImageFormatGroup.jpeg:
        return InputImageFormat.nv21; // Fallback
      default:
        return null;
    }
  }

  Future<void> _processFaceDetectionResults(List<Face> faces) async {
    setState(() {
      _detectedFaces = faces;
      _faceDetected = faces.isNotEmpty;
      _showManualCaptureButton = faces.isEmpty || faces.length > 1;
    });

    if (faces.isEmpty) {
      setState(() {
        _statusMessage =
            'No face detected. Use manual capture or reposition face.';
        _faceVerified = false;
      });
      _notifyVerificationResult(false, null);
      return;
    }

    if (faces.length > 1) {
      setState(() {
        _statusMessage =
            'Multiple faces detected (${faces.length}). Use manual capture or ensure only one face.';
        _faceVerified = false;
      });
      _notifyVerificationResult(false, null);
      return;
    }

    final face = faces.first;

    final qualityInfo = _checkFaceQuality(face);
    if (!qualityInfo['isGood']) {
      setState(() {
        _statusMessage = '${qualityInfo['message']} Or use manual capture.';
        _faceVerified = false;
        _showManualCaptureButton = true;
      });
      _notifyVerificationResult(false, null);
      return;
    }

    setState(() {
      _showManualCaptureButton = false; // Hide when automatic detection works
    });

    List<double> currentFaceFeatures = [];
    try {
      currentFaceFeatures = FaceRecognitionService.extractFaceFeatures(face);
    } catch (e) {
      setState(() {
        _statusMessage = 'Feature extraction error. Try manual capture.';
        _faceVerified = false;
        _showManualCaptureButton = true;
      });
      _notifyVerificationResult(false, null);
      return;
    }

    if (currentFaceFeatures.isEmpty) {
      setState(() {
        _statusMessage = 'Unable to extract face features. Try manual capture.';
        _faceVerified = false;
        _showManualCaptureButton = true;
      });
      _notifyVerificationResult(false, null);
      return;
    }

    // If we have reference features, perform face verification
    if (widget.referenceFaceFeatures != null) {
      final similarity = FaceRecognitionService.compareFaces(
        widget.referenceFaceFeatures!,
        currentFaceFeatures,
      );

      _lastVerificationScore = similarity;
      final isVerified = similarity >= widget.verificationThreshold;

      setState(() {
        _faceVerified = isVerified;
        if (isVerified) {
          _statusMessage =
              'Face verified! (${(similarity * 100).toStringAsFixed(1)}% match)';
        } else {
          _statusMessage =
              'Face not verified. (${(similarity * 100).toStringAsFixed(1)}% match - need ${(widget.verificationThreshold * 100).toStringAsFixed(1)}%)';
        }
      });

      _notifyVerificationResult(isVerified, currentFaceFeatures);
    } else {
      // No reference features, just detect presence
      setState(() {
        _statusMessage = 'Face detected and ready!';
        _faceVerified = true;
      });

      _notifyVerificationResult(true, currentFaceFeatures);
    }
  }

  Map<String, dynamic> _checkFaceQuality(Face face) {
    final faceSize = face.boundingBox.width < face.boundingBox.height
        ? face.boundingBox.width
        : face.boundingBox.height;

    if (faceSize < widget.minFaceSize) {
      return {
        'isGood': false,
        'message':
            'Face too small (${faceSize.toStringAsFixed(1)}px). Move closer.'
      };
    }

    final imageSize = _cameraController?.value.previewSize;
    if (imageSize != null) {
      final imageCenter = Offset(imageSize.width / 2, imageSize.height / 2);
      final faceCenter = face.boundingBox.center;
      final distance = (faceCenter - imageCenter).distance;
      final maxDistance = (imageSize.width + imageSize.height) / 3;

      if (distance > maxDistance) {
        return {'isGood': false, 'message': 'Center your face in the frame.'};
      }
    }

    // Head pose checks
    const maxAngleDeviation = 20.0; // More lenient
    if (face.headEulerAngleX != null &&
        face.headEulerAngleY != null &&
        face.headEulerAngleZ != null) {
      if (face.headEulerAngleX!.abs() > maxAngleDeviation ||
          face.headEulerAngleY!.abs() > maxAngleDeviation ||
          face.headEulerAngleZ!.abs() > maxAngleDeviation) {
        return {'isGood': false, 'message': 'Keep your head straight.'};
      }
    }

    // Eye openness check
    final leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
    final rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;

    if (leftEyeOpen < 0.3 || rightEyeOpen < 0.3) {
      return {'isGood': false, 'message': 'Please keep your eyes open.'};
    }

    return {'isGood': true, 'message': 'Face quality good'};
  }

  void _notifyVerificationResult(bool isVerified, List<double>? features) {
    if (widget.enableContinuousVerification) {
      widget.onFaceVerified(isVerified, features);
    } else {
      if (_faceVerified != isVerified) {
        widget.onFaceVerified(isVerified, features);
      }
    }
  }

  Future<void> _retryInitialization() async {
    await _disposeCamera();
    await _initializeCamera();
  }

  Color _getBorderColor() {
    if (!_faceDetected) return Colors.grey;
    if (widget.referenceFaceFeatures != null) {
      return _faceVerified ? Colors.green : Colors.red;
    }
    return Colors.green;
  }

  Future<void> _captureFaceManually() async {
    if (!_isInitialized || _cameraController == null || _isCapturing) return;

    setState(() {
      _isCapturing = true;
      _statusMessage = 'Capturing face...';
    });

    try {
      // Stop the image stream temporarily
      if (_cameraController!.value.isStreamingImages) {
        await _cameraController!.stopImageStream();
      }

      // Take a picture
      final XFile image = await _cameraController!.takePicture();

      // Process the captured image
      final faces = await _detectFacesFromImageFile(image);

      if (faces.isEmpty) {
        if (mounted) {
          setState(() {
            _statusMessage =
                'No face detected in captured photo. Please try again.';
          });
        }
        _notifyVerificationResult(false, null);
        return;
      }

      if (faces.length > 1) {
        if (mounted) {
          setState(() {
            _statusMessage =
                'Multiple faces detected in photo (${faces.length}). Ensure only one face is visible.';
          });
        }
        _notifyVerificationResult(false, null);
        return;
      }

      final capturedFace = faces.first;

      // More lenient quality check for manual capture
      final qualityInfo = _checkFaceQualityForManualCapture(capturedFace);

      if (!qualityInfo['isGood']) {
        if (mounted) {
          setState(() {
            _statusMessage = 'Captured face quality: ${qualityInfo['message']}';
          });
        }
        _notifyVerificationResult(false, null);
        return;
      }

      final capturedFaceFeatures =
          FaceRecognitionService.extractFaceFeatures(capturedFace);

      if (capturedFaceFeatures.isNotEmpty) {
        // Perform verification if reference features exist
        if (widget.referenceFaceFeatures != null) {
          final similarity = FaceRecognitionService.compareFaces(
            widget.referenceFaceFeatures!,
            capturedFaceFeatures,
          );

          final isVerified = similarity >= widget.verificationThreshold;

          if (mounted) {
            setState(() {
              _faceVerified = isVerified;
              if (isVerified) {
                _statusMessage =
                    'Manual capture successful! Face verified (${(similarity * 100).toStringAsFixed(1)}% match)';
              } else {
                _statusMessage =
                    'Manual capture complete but face not verified (${(similarity * 100).toStringAsFixed(1)}% match)';
              }
            });
          }

          widget.onManualCapture?.call(capturedFaceFeatures);
          _notifyVerificationResult(isVerified, capturedFaceFeatures);
        } else {
          // No reference features, just successful capture
          if (mounted) {
            setState(() {
              _statusMessage = 'Manual face capture successful!';
              _faceVerified = true;
            });
          }

          widget.onManualCapture?.call(capturedFaceFeatures);
          _notifyVerificationResult(true, capturedFaceFeatures);
        }
      } else {
        if (mounted) {
          setState(() {
            _statusMessage =
                'Could not extract features from captured face. Try again.';
          });
        }
        _notifyVerificationResult(false, null);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Manual capture error: ${e.toString()}';
          _faceVerified = false;
        });
      }
      _notifyVerificationResult(false, null);
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });

        // Restart the stream if continuous verification is enabled
        if (widget.enableContinuousVerification &&
            _cameraController != null &&
            !_cameraController!.value.isStreamingImages) {
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) _startFaceDetection();
        }
      }
    }
  }

  Map<String, dynamic> _checkFaceQualityForManualCapture(Face face) {
    // More lenient quality check for manual capture
    final faceSize = face.boundingBox.width < face.boundingBox.height
        ? face.boundingBox.width
        : face.boundingBox.height;

    if (faceSize < (widget.minFaceSize * 0.7)) {
      // 30% more lenient
      return {
        'isGood': false,
        'message': 'Face too small, move closer and try again.'
      };
    }

    // More lenient head pose checks for manual capture
    const maxAngleDeviation = 35.0; // More lenient than automatic
    if (face.headEulerAngleX != null &&
        face.headEulerAngleY != null &&
        face.headEulerAngleZ != null) {
      if (face.headEulerAngleX!.abs() > maxAngleDeviation ||
          face.headEulerAngleY!.abs() > maxAngleDeviation ||
          face.headEulerAngleZ!.abs() > maxAngleDeviation) {
        return {
          'isGood': false,
          'message':
              'Head angle too extreme, try to face the camera more directly.'
        };
      }
    }

    return {'isGood': true, 'message': 'Quality acceptable for manual capture'};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300, // Increased height for better visibility
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getBorderColor(),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                // Camera preview or loading state
                if (_isInitialized && _cameraController != null)
                  _buildCameraPreview()
                else
                  _buildLoadingState(),

                // Face detection overlay
                if (_faceDetected && _detectedFaces != null && _isInitialized)
                  CustomPaint(
                    painter: FaceDetectionPainter(
                      faces: _detectedFaces!,
                      imageSize: Size(
                        _cameraController?.value.previewSize?.width ?? 0,
                        _cameraController?.value.previewSize?.height ?? 0,
                      ),
                      isVerified: _faceVerified,
                    ),
                    child: Container(),
                  ),

                // Status overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildStatusOverlay(),
                ),

                // Debug info (remove in production)
                if (_debugMode)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.black.withOpacity(0.7),
                      child: Text(
                        _debugInfo,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                // Retry button
                if (!_isInitialized && _statusMessage.contains('error'))
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: _retryInitialization,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Manual Capture Button - always show when initialized
        if (_isInitialized)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Manual capture button
                ElevatedButton.icon(
                  onPressed: !_isCapturing ? _captureFaceManually : null,
                  icon: _isCapturing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.camera_alt),
                  label: Text(_isCapturing ? 'Capturing...' : 'Manual Capture'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    backgroundColor: _isCapturing
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                  ),
                ),

                // Retry detection button
                if (_showManualCaptureButton)
                  ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        _statusMessage = 'Restarting detection...';
                        _showManualCaptureButton = false;
                      });

                      if (_cameraController!.value.isStreamingImages) {
                        await _cameraController!.stopImageStream();
                      }

                      await Future.delayed(const Duration(milliseconds: 500));
                      if (mounted) {
                        _startFaceDetection();
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry Auto'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCameraPreview() {
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

  Widget _buildLoadingState() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_statusMessage.contains('error'))
              const CircularProgressIndicator(color: Colors.white)
            else
              const Icon(Icons.error, color: Colors.red, size: 32),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _statusMessage,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOverlay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _statusMessage,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: _faceVerified ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          // Show verification score if available
          if (widget.referenceFaceFeatures != null &&
              (_faceDetected || _lastVerificationScore > 0))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: LinearProgressIndicator(
                value: _lastVerificationScore,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _faceVerified ? Colors.green : Colors.red,
                ),
                minHeight: 2,
              ),
            ),
        ],
      ),
    );
  }
}


class FaceDetectionPainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final bool isVerified;

  FaceDetectionPainter({
    required this.faces,
    required this.imageSize,
    required this.isVerified,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isVerified ? Colors.green : Colors.orange
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final face in faces) {
      final rect = _scaleRect(face.boundingBox, size);

      // Draw face bounding box
      canvas.drawRect(rect, paint);

      // Draw corner indicators
      _drawCornerIndicators(canvas, rect, paint);

      // Draw face landmarks
      _drawLandmarks(canvas, face, size);
    }
  }

  void _drawCornerIndicators(Canvas canvas, Rect rect, Paint paint) {
    final cornerLength = 20.0;
    paint.strokeWidth = 3.0;

    // Top-left corner
    canvas.drawLine(rect.topLeft, rect.topLeft + Offset(cornerLength, 0), paint);
    canvas.drawLine(rect.topLeft, rect.topLeft + Offset(0, cornerLength), paint);

    // Top-right corner
    canvas.drawLine(rect.topRight, rect.topRight - Offset(cornerLength, 0), paint);
    canvas.drawLine(rect.topRight, rect.topRight + Offset(0, cornerLength), paint);

    // Bottom-left corner
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + Offset(cornerLength, 0), paint);
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft - Offset(0, cornerLength), paint);

    // Bottom-right corner
    canvas.drawLine(rect.bottomRight, rect.bottomRight - Offset(cornerLength, 0), paint);
    canvas.drawLine(rect.bottomRight, rect.bottomRight - Offset(0, cornerLength), paint);
  }

  void _drawLandmarks(Canvas canvas, Face face, Size size) {
    final landmarkPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (final entry in face.landmarks.entries) {
      final landmark = entry.value;
      if (landmark != null) {
        final point = _scalePoint(
          Offset(
            landmark.position.x.toDouble(),
            landmark.position.y.toDouble(),
          ),
          size,
        );
        canvas.drawCircle(point, 4.0, landmarkPaint);
      }
    }
  }

  Rect _scaleRect(Rect rect, Size size) {
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;
    return Rect.fromLTWH(
      rect.left * scaleX,
      rect.top * scaleY,
      rect.width * scaleX,
      rect.height * scaleY,
    );
  }

  Offset _scalePoint(Offset point, Size size) {
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;
    return Offset(point.dx * scaleX, point.dy * scaleY);
  }

  @override
  bool shouldRepaint(covariant FaceDetectionPainter oldDelegate) {
    return oldDelegate.faces != faces ||
           oldDelegate.imageSize != imageSize ||
           oldDelegate.isVerified != isVerified;
  }
}
