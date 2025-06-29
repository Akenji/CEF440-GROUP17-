// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceSessionModel _$AttendanceSessionModelFromJson(
        Map<String, dynamic> json) =>
    _AttendanceSessionModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      lecturerId: json['lecturerId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      sessionType: json['sessionType'] as String? ?? 'lecture',
      scheduledStart: DateTime.parse(json['scheduledStart'] as String),
      scheduledEnd: DateTime.parse(json['scheduledEnd'] as String),
      actualStart: json['actualStart'] == null
          ? null
          : DateTime.parse(json['actualStart'] as String),
      actualEnd: json['actualEnd'] == null
          ? null
          : DateTime.parse(json['actualEnd'] as String),
      status: $enumDecodeNullable(_$SessionStatusEnumMap, json['status']) ??
          SessionStatus.scheduled,
      locationName: json['locationName'] as String?,
      locationLatitude: (json['locationLatitude'] as num?)?.toDouble(),
      locationLongitude: (json['locationLongitude'] as num?)?.toDouble(),
      geofenceRadius: (json['geofenceRadius'] as num?)?.toInt() ?? 100,
      requireGeofence: json['requireGeofence'] as bool? ?? true,
      requireFaceRecognition: json['requireFaceRecognition'] as bool? ?? true,
      autoEndSession: json['autoEndSession'] as bool? ?? true,
      lateThresholdMinutes:
          (json['lateThresholdMinutes'] as num?)?.toInt() ?? 15,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      course: json['course'] == null
          ? null
          : CourseModel.fromJson(json['course'] as Map<String, dynamic>),
      lecturer: json['lecturer'] == null
          ? null
          : LecturerModel.fromJson(json['lecturer'] as Map<String, dynamic>),
      attendanceRecords: (json['attendanceRecords'] as List<dynamic>?)
          ?.map(
              (e) => AttendanceRecordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttendanceSessionModelToJson(
        _AttendanceSessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'lecturerId': instance.lecturerId,
      'title': instance.title,
      'description': instance.description,
      'sessionType': instance.sessionType,
      'scheduledStart': instance.scheduledStart.toIso8601String(),
      'scheduledEnd': instance.scheduledEnd.toIso8601String(),
      'actualStart': instance.actualStart?.toIso8601String(),
      'actualEnd': instance.actualEnd?.toIso8601String(),
      'status': _$SessionStatusEnumMap[instance.status]!,
      'locationName': instance.locationName,
      'locationLatitude': instance.locationLatitude,
      'locationLongitude': instance.locationLongitude,
      'geofenceRadius': instance.geofenceRadius,
      'requireGeofence': instance.requireGeofence,
      'requireFaceRecognition': instance.requireFaceRecognition,
      'autoEndSession': instance.autoEndSession,
      'lateThresholdMinutes': instance.lateThresholdMinutes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'course': instance.course,
      'lecturer': instance.lecturer,
      'attendanceRecords': instance.attendanceRecords,
    };

const _$SessionStatusEnumMap = {
  SessionStatus.scheduled: 'scheduled',
  SessionStatus.active: 'active',
  SessionStatus.ended: 'ended',
  SessionStatus.cancelled: 'cancelled',
};

_AttendanceRecordModel _$AttendanceRecordModelFromJson(
        Map<String, dynamic> json) =>
    _AttendanceRecordModel(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      studentId: json['studentId'] as String,
      status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
      markedAt: DateTime.parse(json['markedAt'] as String),
      locationLatitude: (json['locationLatitude'] as num?)?.toDouble(),
      locationLongitude: (json['locationLongitude'] as num?)?.toDouble(),
      distanceFromSession: (json['distanceFromSession'] as num?)?.toDouble(),
      faceConfidence: (json['faceConfidence'] as num?)?.toDouble(),
      faceImageUrl: json['faceImageUrl'] as String?,
      deviceInfo: json['deviceInfo'] as Map<String, dynamic>? ?? const {},
      ipAddress: json['ipAddress'] as String?,
      isManualOverride: json['isManualOverride'] as bool? ?? false,
      overrideReason: json['overrideReason'] as String?,
      overrideBy: json['overrideBy'] as String?,
      verificationMethod:
          json['verificationMethod'] as String? ?? 'face_location',
      createdAt: DateTime.parse(json['createdAt'] as String),
      session: json['session'] == null
          ? null
          : AttendanceSessionModel.fromJson(
              json['session'] as Map<String, dynamic>),
      student: json['student'] == null
          ? null
          : StudentModel.fromJson(json['student'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AttendanceRecordModelToJson(
        _AttendanceRecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'studentId': instance.studentId,
      'status': _$AttendanceStatusEnumMap[instance.status]!,
      'markedAt': instance.markedAt.toIso8601String(),
      'locationLatitude': instance.locationLatitude,
      'locationLongitude': instance.locationLongitude,
      'distanceFromSession': instance.distanceFromSession,
      'faceConfidence': instance.faceConfidence,
      'faceImageUrl': instance.faceImageUrl,
      'deviceInfo': instance.deviceInfo,
      'ipAddress': instance.ipAddress,
      'isManualOverride': instance.isManualOverride,
      'overrideReason': instance.overrideReason,
      'overrideBy': instance.overrideBy,
      'verificationMethod': instance.verificationMethod,
      'createdAt': instance.createdAt.toIso8601String(),
      'session': instance.session,
      'student': instance.student,
    };

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.absent: 'absent',
  AttendanceStatus.late: 'late',
  AttendanceStatus.excused: 'excused',
};

_FaceDataModel _$FaceDataModelFromJson(Map<String, dynamic> json) =>
    _FaceDataModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      faceEncoding: (json['faceEncoding'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      faceImageUrl: json['faceImageUrl'] as String?,
      confidenceThreshold:
          (json['confidenceThreshold'] as num?)?.toDouble() ?? 0.8,
      backupEncodings: (json['backupEncodings'] as List<dynamic>?)
              ?.map((e) =>
                  (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
              .toList() ??
          const [],
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
      verificationAttempts:
          (json['verificationAttempts'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      student: json['student'] == null
          ? null
          : StudentModel.fromJson(json['student'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FaceDataModelToJson(_FaceDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'faceEncoding': instance.faceEncoding,
      'faceImageUrl': instance.faceImageUrl,
      'confidenceThreshold': instance.confidenceThreshold,
      'backupEncodings': instance.backupEncodings,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'isVerified': instance.isVerified,
      'verificationAttempts': instance.verificationAttempts,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'student': instance.student,
    };
