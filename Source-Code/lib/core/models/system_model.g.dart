// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SystemSettingsModel _$SystemSettingsModelFromJson(Map<String, dynamic> json) =>
    _SystemSettingsModel(
      id: json['id'] as String,
      settingKey: json['settingKey'] as String,
      settingValue: json['settingValue'] as Map<String, dynamic>,
      description: json['description'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      updatedBy: json['updatedBy'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SystemSettingsModelToJson(
        _SystemSettingsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'settingKey': instance.settingKey,
      'settingValue': instance.settingValue,
      'description': instance.description,
      'isPublic': instance.isPublic,
      'updatedBy': instance.updatedBy,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_EnrollmentSettings _$EnrollmentSettingsFromJson(Map<String, dynamic> json) =>
    _EnrollmentSettings(
      maxCoursesPerSemester:
          (json['maxCoursesPerSemester'] as num?)?.toInt() ?? 8,
      minCreditsPerSemester:
          (json['minCreditsPerSemester'] as num?)?.toInt() ?? 12,
      maxCreditsPerSemester:
          (json['maxCreditsPerSemester'] as num?)?.toInt() ?? 21,
    );

Map<String, dynamic> _$EnrollmentSettingsToJson(_EnrollmentSettings instance) =>
    <String, dynamic>{
      'maxCoursesPerSemester': instance.maxCoursesPerSemester,
      'minCreditsPerSemester': instance.minCreditsPerSemester,
      'maxCreditsPerSemester': instance.maxCreditsPerSemester,
    };

_AttendanceSettings _$AttendanceSettingsFromJson(Map<String, dynamic> json) =>
    _AttendanceSettings(
      geofenceRadius: (json['geofenceRadius'] as num?)?.toDouble() ?? 100.0,
      faceConfidenceThreshold:
          (json['faceConfidenceThreshold'] as num?)?.toDouble() ?? 0.8,
      lateThresholdMinutes:
          (json['lateThresholdMinutes'] as num?)?.toInt() ?? 15,
    );

Map<String, dynamic> _$AttendanceSettingsToJson(_AttendanceSettings instance) =>
    <String, dynamic>{
      'geofenceRadius': instance.geofenceRadius,
      'faceConfidenceThreshold': instance.faceConfidenceThreshold,
      'lateThresholdMinutes': instance.lateThresholdMinutes,
    };
