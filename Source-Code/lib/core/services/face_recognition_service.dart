import 'dart:math' as math;
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:flutter/services.dart';

class FaceRecognitionService {
  static final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.accurate,
      minFaceSize: 0.1,
    ),
  );

  static const double _featureScalingFactor = 10000.0;

  static Future<List<Face>> detectFaces(
    CameraImage cameraImage,
    CameraDescription camera,
  ) async {
    try {
      final inputImage = _buildInputImage(cameraImage, camera);
      if (inputImage == null) {
        if (kDebugMode) print('Failed to build input image');
        return [];
      }

      final faces = await _faceDetector.processImage(inputImage);
      if (kDebugMode) print('Detected ${faces.length} faces');
      return faces;
    } catch (e) {
      if (kDebugMode) print('Face detection error: $e');
      return [];
    }
  }

  static InputImage? _buildInputImage(
    CameraImage cameraImage,
    CameraDescription camera,
  ) {
    try {
      final format = _getInputImageFormat(cameraImage.format);
      if (format == null) {
        if (kDebugMode) print('Unsupported image format: ${cameraImage.format.group}');
        return null;
      }

      final rotation = _getImageRotation(camera);

      final allBytes = WriteBuffer();
      for (final plane in cameraImage.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(
            cameraImage.width.toDouble(),
            cameraImage.height.toDouble(),
          ),
          rotation: rotation,
          format: format,
          bytesPerRow: cameraImage.planes[0].bytesPerRow,
        ),
      );
    } catch (e) {
      if (kDebugMode) print('Error building input image: $e');
      return null;
    }
  }

  static InputImageFormat? _getInputImageFormat(ImageFormat format) {
    switch (format.group) {
      case ImageFormatGroup.yuv420:
        return InputImageFormat.yuv420;
      case ImageFormatGroup.bgra8888:
        return InputImageFormat.bgra8888;
      case ImageFormatGroup.nv21:
        return InputImageFormat.nv21;
      case ImageFormatGroup.jpeg:
        return InputImageFormat.nv21;
      default:
        if (kDebugMode) print('Unsupported format: ${format.group}');
        return null;
    }
  }

  static InputImageRotation _getImageRotation(CameraDescription camera) {
    switch (camera.sensorOrientation) {
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

  static List<double> extractFaceFeatures(Face face) {
    final features = <double>[];

    try {
      final boundingBox = face.boundingBox;
      features.addAll([
        boundingBox.left,
        boundingBox.top,
        boundingBox.width,
        boundingBox.height,
        boundingBox.center.dx,
        boundingBox.center.dy,
      ]);

      features.add(face.smilingProbability ?? 0.0);
      features.add(face.leftEyeOpenProbability ?? 0.0);
      features.add(face.rightEyeOpenProbability ?? 0.0);

      _addLandmarkFeatures(face, features);
      _addContourFeatures(face, features);

      features.add(face.headEulerAngleX ?? 0.0);
      features.add(face.headEulerAngleY ?? 0.0);
      features.add(face.headEulerAngleZ ?? 0.0);

      if (kDebugMode) print('Extracted ${features.length} features');
    } catch (e) {
      if (kDebugMode) print('Feature extraction error: $e');
    }

    return features;
  }

  static void _addLandmarkFeatures(Face face, List<double> features) {
    final landmarkTypes = [
      FaceLandmarkType.leftEye,
      FaceLandmarkType.rightEye,
      FaceLandmarkType.noseBase,
      FaceLandmarkType.leftEar,
      FaceLandmarkType.rightEar,
      FaceLandmarkType.leftMouth,
      FaceLandmarkType.rightMouth,
      FaceLandmarkType.bottomMouth,
      FaceLandmarkType.leftCheek,
      FaceLandmarkType.rightCheek,
    ];

    for (final type in landmarkTypes) {
      final landmark = face.landmarks[type];
      if (landmark != null) {
        features.add(landmark.position.x.toDouble());
        features.add(landmark.position.y.toDouble());
      } else {
        features.addAll([0.0, 0.0]);
      }
    }
  }

  static void _addContourFeatures(Face face, List<double> features) {
    final contourTypes = [
      FaceContourType.face,
      FaceContourType.leftEye,
      FaceContourType.rightEye,
      FaceContourType.upperLipTop,
      FaceContourType.lowerLipBottom,
    ];

    for (final type in contourTypes) {
      final contour = face.contours[type];
      if (contour != null && contour.points.isNotEmpty) {
        final indices = _getSampleIndices(contour.points.length, 3);
        for (final index in indices) {
          final point = contour.points[index];
          features.add(point.x.toDouble());
          features.add(point.y.toDouble());
        }
      } else {
        features.addAll(List.filled(6, 0.0));
      }
    }
  }

  static List<int> _getSampleIndices(int length, int sampleCount) {
    if (length <= sampleCount) {
      return List.generate(length, (i) => i);
    }

    final indices = <int>[];
    final step = length / sampleCount;
    for (int i = 0; i < sampleCount; i++) {
      indices.add((i * step).round().clamp(0, length - 1));
    }
    return indices;
  }

  static List<int> convertFeaturesToIntegers(List<double> features) {
    return features.map((e) => (e * _featureScalingFactor).round()).toList();
  }

  static List<double> convertIntegersToFeatures(List<int> intFeatures) {
    return intFeatures.map((e) => e / _featureScalingFactor).toList();
  }

  static double compareFaces(List<double> features1, List<double> features2) {
    if (features1.isEmpty || features2.isEmpty) return 0.0;

    final maxLength = math.max(features1.length, features2.length);
    final padded1 = List<double>.from(features1)..addAll(List.filled(maxLength - features1.length, 0.0));
    final padded2 = List<double>.from(features2)..addAll(List.filled(maxLength - features2.length, 0.0));

    double weightedSum = 0.0;
    double totalWeight = 0.0;

    for (int i = 0; i < maxLength; i++) {
      final weight = i < 10 ? 2.0 : 1.0;
      final diff = padded1[i] - padded2[i];
      weightedSum += weight * diff * diff;
      totalWeight += weight;
    }

    final normalizedDistance = math.sqrt(weightedSum / totalWeight);
    final similarity = 1.0 / (1.0 + normalizedDistance);
    return similarity.clamp(0.0, 1.0);
  }

  static double cosineSimilarity(List<double> features1, List<double> features2) {
    if (features1.isEmpty || features2.isEmpty) return 0.0;

    final minLength = math.min(features1.length, features2.length);
    double dot = 0.0, norm1 = 0.0, norm2 = 0.0;

    for (int i = 0; i < minLength; i++) {
      dot += features1[i] * features2[i];
      norm1 += features1[i] * features1[i];
      norm2 += features2[i] * features2[i];
    }

    if (norm1 == 0.0 || norm2 == 0.0) return 0.0;

    final similarity = dot / (math.sqrt(norm1) * math.sqrt(norm2));
    return similarity.clamp(-1.0, 1.0);
  }

  static bool isValidFaceForRecognition(Face face) {
    if (face.boundingBox.width < 50 || face.boundingBox.height < 50) return false;

    final leftEyeOpen = face.leftEyeOpenProbability ?? 0.5;
    final rightEyeOpen = face.rightEyeOpenProbability ?? 0.5;

    if (leftEyeOpen < 0.3 || rightEyeOpen < 0.3) return false;

    final headX = face.headEulerAngleX?.abs() ?? 0.0;
    final headY = face.headEulerAngleY?.abs() ?? 0.0;
    final headZ = face.headEulerAngleZ?.abs() ?? 0.0;

    if (headX > 30 || headY > 30 || headZ > 30) return false;

    return true;
  }

  static Future<void> dispose() async {
    try {
      await _faceDetector.close();
    } catch (e) {
      if (kDebugMode) print('Disposal error: $e');
    }
  }
}
