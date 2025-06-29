// attendance_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';
import 'academic_model.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

enum SessionStatus {
  scheduled,
  active,
  ended,
  cancelled
}
enum AttendanceStatus {
  present,
  absent,
  late,
  excused
}

@freezed
abstract class AttendanceSessionModel with _$AttendanceSessionModel {
  const factory AttendanceSessionModel({
    required String id,
    required String courseId,
    required String lecturerId,
    required String title,
    String? description,
    @Default('lecture') String sessionType,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    DateTime? actualStart,
    DateTime? actualEnd,
    @Default(SessionStatus.scheduled) SessionStatus status,
    String? locationName,
    double? locationLatitude,
    double? locationLongitude,
    @Default(100) int geofenceRadius,
    @Default(true) bool requireGeofence,
    @Default(true) bool requireFaceRecognition,
    @Default(true) bool autoEndSession,
    @Default(15) int lateThresholdMinutes,
    required DateTime createdAt,
    required DateTime updatedAt,
    CourseModel? course,
    LecturerModel? lecturer,
    List<AttendanceRecordModel>? attendanceRecords,
  }) = _AttendanceSessionModel;

  factory AttendanceSessionModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSessionModelFromJson(json);
}

@freezed
abstract class AttendanceRecordModel with _$AttendanceRecordModel {
  const factory AttendanceRecordModel({
    required String id,
    required String sessionId,
    required String studentId,
    required AttendanceStatus status,
    required DateTime markedAt,
    double? locationLatitude,
    double? locationLongitude,
    double? distanceFromSession,
    double? faceConfidence,
    String? faceImageUrl,
    @Default({}) Map<String, dynamic> deviceInfo,
    String? ipAddress,
    @Default(false) bool isManualOverride,
    String? overrideReason,
    String? overrideBy,
    @Default('face_location') String verificationMethod,
    required DateTime createdAt,
    AttendanceSessionModel? session,
    StudentModel? student,
  }) = _AttendanceRecordModel;

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);
}

@freezed
abstract class FaceDataModel with _$FaceDataModel {
  const factory FaceDataModel({
    required String id,
    required String studentId,
    required List<int> faceEncoding,
    String? faceImageUrl,
    @Default(0.8) double confidenceThreshold,
    @Default([]) List<List<int>> backupEncodings,
    required DateTime lastUpdated,
    @Default(false) bool isVerified,
    @Default(0) int verificationAttempts,
    required DateTime createdAt,
    required DateTime updatedAt,
    StudentModel? student,
  }) = _FaceDataModel;

  factory FaceDataModel.fromJson(Map<String, dynamic> json) =>
      _$FaceDataModelFromJson(json);
}