// system_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';


part 'system_model.freezed.dart';
part 'system_model.g.dart';

@freezed
abstract class SystemSettingsModel with _$SystemSettingsModel {
  const factory SystemSettingsModel({
    required String id,
    required String settingKey,
    required Map<String, dynamic> settingValue,
    String? description,
    @Default(false) bool isPublic,
    String? updatedBy,
    required DateTime updatedAt,
  }) = _SystemSettingsModel;

  factory SystemSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SystemSettingsModelFromJson(json);
}

@freezed
abstract class EnrollmentSettings with _$EnrollmentSettings {
  const factory EnrollmentSettings({
    @Default(8) int maxCoursesPerSemester,
    @Default(12) int minCreditsPerSemester,
    @Default(21) int maxCreditsPerSemester,
  }) = _EnrollmentSettings;

  factory EnrollmentSettings.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentSettingsFromJson(json);
}

@freezed
abstract class AttendanceSettings with _$AttendanceSettings {
  const factory AttendanceSettings({
    @Default(100.0) double geofenceRadius,
    @Default(0.8) double faceConfidenceThreshold,
    @Default(15) int lateThresholdMinutes,
  }) = _AttendanceSettings;

  factory AttendanceSettings.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSettingsFromJson(json);
}