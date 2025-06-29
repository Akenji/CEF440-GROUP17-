// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceSessionModel {
  String get id;
  String get courseId;
  String get lecturerId;
  String get title;
  String? get description;
  String get sessionType;
  DateTime get scheduledStart;
  DateTime get scheduledEnd;
  DateTime? get actualStart;
  DateTime? get actualEnd;
  SessionStatus get status;
  String? get locationName;
  double? get locationLatitude;
  double? get locationLongitude;
  int get geofenceRadius;
  bool get requireGeofence;
  bool get requireFaceRecognition;
  bool get autoEndSession;
  int get lateThresholdMinutes;
  DateTime get createdAt;
  DateTime get updatedAt;
  CourseModel? get course;
  LecturerModel? get lecturer;
  List<AttendanceRecordModel>? get attendanceRecords;

  /// Create a copy of AttendanceSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AttendanceSessionModelCopyWith<AttendanceSessionModel> get copyWith =>
      _$AttendanceSessionModelCopyWithImpl<AttendanceSessionModel>(
          this as AttendanceSessionModel, _$identity);

  /// Serializes this AttendanceSessionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AttendanceSessionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.lecturerId, lecturerId) ||
                other.lecturerId == lecturerId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.scheduledStart, scheduledStart) ||
                other.scheduledStart == scheduledStart) &&
            (identical(other.scheduledEnd, scheduledEnd) ||
                other.scheduledEnd == scheduledEnd) &&
            (identical(other.actualStart, actualStart) ||
                other.actualStart == actualStart) &&
            (identical(other.actualEnd, actualEnd) ||
                other.actualEnd == actualEnd) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationLatitude, locationLatitude) ||
                other.locationLatitude == locationLatitude) &&
            (identical(other.locationLongitude, locationLongitude) ||
                other.locationLongitude == locationLongitude) &&
            (identical(other.geofenceRadius, geofenceRadius) ||
                other.geofenceRadius == geofenceRadius) &&
            (identical(other.requireGeofence, requireGeofence) ||
                other.requireGeofence == requireGeofence) &&
            (identical(other.requireFaceRecognition, requireFaceRecognition) ||
                other.requireFaceRecognition == requireFaceRecognition) &&
            (identical(other.autoEndSession, autoEndSession) ||
                other.autoEndSession == autoEndSession) &&
            (identical(other.lateThresholdMinutes, lateThresholdMinutes) ||
                other.lateThresholdMinutes == lateThresholdMinutes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.lecturer, lecturer) ||
                other.lecturer == lecturer) &&
            const DeepCollectionEquality()
                .equals(other.attendanceRecords, attendanceRecords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        courseId,
        lecturerId,
        title,
        description,
        sessionType,
        scheduledStart,
        scheduledEnd,
        actualStart,
        actualEnd,
        status,
        locationName,
        locationLatitude,
        locationLongitude,
        geofenceRadius,
        requireGeofence,
        requireFaceRecognition,
        autoEndSession,
        lateThresholdMinutes,
        createdAt,
        updatedAt,
        course,
        lecturer,
        const DeepCollectionEquality().hash(attendanceRecords)
      ]);

  @override
  String toString() {
    return 'AttendanceSessionModel(id: $id, courseId: $courseId, lecturerId: $lecturerId, title: $title, description: $description, sessionType: $sessionType, scheduledStart: $scheduledStart, scheduledEnd: $scheduledEnd, actualStart: $actualStart, actualEnd: $actualEnd, status: $status, locationName: $locationName, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, geofenceRadius: $geofenceRadius, requireGeofence: $requireGeofence, requireFaceRecognition: $requireFaceRecognition, autoEndSession: $autoEndSession, lateThresholdMinutes: $lateThresholdMinutes, createdAt: $createdAt, updatedAt: $updatedAt, course: $course, lecturer: $lecturer, attendanceRecords: $attendanceRecords)';
  }
}

/// @nodoc
abstract mixin class $AttendanceSessionModelCopyWith<$Res> {
  factory $AttendanceSessionModelCopyWith(AttendanceSessionModel value,
          $Res Function(AttendanceSessionModel) _then) =
      _$AttendanceSessionModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String courseId,
      String lecturerId,
      String title,
      String? description,
      String sessionType,
      DateTime scheduledStart,
      DateTime scheduledEnd,
      DateTime? actualStart,
      DateTime? actualEnd,
      SessionStatus status,
      String? locationName,
      double? locationLatitude,
      double? locationLongitude,
      int geofenceRadius,
      bool requireGeofence,
      bool requireFaceRecognition,
      bool autoEndSession,
      int lateThresholdMinutes,
      DateTime createdAt,
      DateTime updatedAt,
      CourseModel? course,
      LecturerModel? lecturer,
      List<AttendanceRecordModel>? attendanceRecords});

  $CourseModelCopyWith<$Res>? get course;
  $LecturerModelCopyWith<$Res>? get lecturer;
}

/// @nodoc
class _$AttendanceSessionModelCopyWithImpl<$Res>
    implements $AttendanceSessionModelCopyWith<$Res> {
  _$AttendanceSessionModelCopyWithImpl(this._self, this._then);

  final AttendanceSessionModel _self;
  final $Res Function(AttendanceSessionModel) _then;

  /// Create a copy of AttendanceSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? lecturerId = null,
    Object? title = null,
    Object? description = freezed,
    Object? sessionType = null,
    Object? scheduledStart = null,
    Object? scheduledEnd = null,
    Object? actualStart = freezed,
    Object? actualEnd = freezed,
    Object? status = null,
    Object? locationName = freezed,
    Object? locationLatitude = freezed,
    Object? locationLongitude = freezed,
    Object? geofenceRadius = null,
    Object? requireGeofence = null,
    Object? requireFaceRecognition = null,
    Object? autoEndSession = null,
    Object? lateThresholdMinutes = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? course = freezed,
    Object? lecturer = freezed,
    Object? attendanceRecords = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      courseId: null == courseId
          ? _self.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String,
      lecturerId: null == lecturerId
          ? _self.lecturerId
          : lecturerId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionType: null == sessionType
          ? _self.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledStart: null == scheduledStart
          ? _self.scheduledStart
          : scheduledStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledEnd: null == scheduledEnd
          ? _self.scheduledEnd
          : scheduledEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actualStart: freezed == actualStart
          ? _self.actualStart
          : actualStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEnd: freezed == actualEnd
          ? _self.actualEnd
          : actualEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as SessionStatus,
      locationName: freezed == locationName
          ? _self.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationLatitude: freezed == locationLatitude
          ? _self.locationLatitude
          : locationLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLongitude: freezed == locationLongitude
          ? _self.locationLongitude
          : locationLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      geofenceRadius: null == geofenceRadius
          ? _self.geofenceRadius
          : geofenceRadius // ignore: cast_nullable_to_non_nullable
              as int,
      requireGeofence: null == requireGeofence
          ? _self.requireGeofence
          : requireGeofence // ignore: cast_nullable_to_non_nullable
              as bool,
      requireFaceRecognition: null == requireFaceRecognition
          ? _self.requireFaceRecognition
          : requireFaceRecognition // ignore: cast_nullable_to_non_nullable
              as bool,
      autoEndSession: null == autoEndSession
          ? _self.autoEndSession
          : autoEndSession // ignore: cast_nullable_to_non_nullable
              as bool,
      lateThresholdMinutes: null == lateThresholdMinutes
          ? _self.lateThresholdMinutes
          : lateThresholdMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      course: freezed == course
          ? _self.course
          : course // ignore: cast_nullable_to_non_nullable
              as CourseModel?,
      lecturer: freezed == lecturer
          ? _self.lecturer
          : lecturer // ignore: cast_nullable_to_non_nullable
              as LecturerModel?,
      attendanceRecords: freezed == attendanceRecords
          ? _self.attendanceRecords
          : attendanceRecords // ignore: cast_nullable_to_non_nullable
              as List<AttendanceRecordModel>?,
    ));
  }

  /// Create a copy of AttendanceSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CourseModelCopyWith<$Res>? get course {
    if (_self.course == null) {
      return null;
    }

    return $CourseModelCopyWith<$Res>(_self.course!, (value) {
      return _then(_self.copyWith(course: value));
    });
  }

  /// Create a copy of AttendanceSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LecturerModelCopyWith<$Res>? get lecturer {
    if (_self.lecturer == null) {
      return null;
    }

    return $LecturerModelCopyWith<$Res>(_self.lecturer!, (value) {
      return _then(_self.copyWith(lecturer: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _AttendanceSessionModel implements AttendanceSessionModel {
  const _AttendanceSessionModel(
      {required this.id,
      required this.courseId,
      required this.lecturerId,
      required this.title,
      this.description,
      this.sessionType = 'lecture',
      required this.scheduledStart,
      required this.scheduledEnd,
      this.actualStart,
      this.actualEnd,
      this.status = SessionStatus.scheduled,
      this.locationName,
      this.locationLatitude,
      this.locationLongitude,
      this.geofenceRadius = 100,
      this.requireGeofence = true,
      this.requireFaceRecognition = true,
      this.autoEndSession = true,
      this.lateThresholdMinutes = 15,
      required this.createdAt,
      required this.updatedAt,
      this.course,
      this.lecturer,
      final List<AttendanceRecordModel>? attendanceRecords})
      : _attendanceRecords = attendanceRecords;
  factory _AttendanceSessionModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSessionModelFromJson(json);

  @override
  final String id;
  @override
  final String courseId;
  @override
  final String lecturerId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey()
  final String sessionType;
  @override
  final DateTime scheduledStart;
  @override
  final DateTime scheduledEnd;
  @override
  final DateTime? actualStart;
  @override
  final DateTime? actualEnd;
  @override
  @JsonKey()
  final SessionStatus status;
  @override
  final String? locationName;
  @override
  final double? locationLatitude;
  @override
  final double? locationLongitude;
  @override
  @JsonKey()
  final int geofenceRadius;
  @override
  @JsonKey()
  final bool requireGeofence;
  @override
  @JsonKey()
  final bool requireFaceRecognition;
  @override
  @JsonKey()
  final bool autoEndSession;
  @override
  @JsonKey()
  final int lateThresholdMinutes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final CourseModel? course;
  @override
  final LecturerModel? lecturer;
  final List<AttendanceRecordModel>? _attendanceRecords;
  @override
  List<AttendanceRecordModel>? get attendanceRecords {
    final value = _attendanceRecords;
    if (value == null) return null;
    if (_attendanceRecords is EqualUnmodifiableListView)
      return _attendanceRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of AttendanceSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AttendanceSessionModelCopyWith<_AttendanceSessionModel> get copyWith =>
      __$AttendanceSessionModelCopyWithImpl<_AttendanceSessionModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AttendanceSessionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AttendanceSessionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.lecturerId, lecturerId) ||
                other.lecturerId == lecturerId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.scheduledStart, scheduledStart) ||
                other.scheduledStart == scheduledStart) &&
            (identical(other.scheduledEnd, scheduledEnd) ||
                other.scheduledEnd == scheduledEnd) &&
            (identical(other.actualStart, actualStart) ||
                other.actualStart == actualStart) &&
            (identical(other.actualEnd, actualEnd) ||
                other.actualEnd == actualEnd) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationLatitude, locationLatitude) ||
                other.locationLatitude == locationLatitude) &&
            (identical(other.locationLongitude, locationLongitude) ||
                other.locationLongitude == locationLongitude) &&
            (identical(other.geofenceRadius, geofenceRadius) ||
                other.geofenceRadius == geofenceRadius) &&
            (identical(other.requireGeofence, requireGeofence) ||
                other.requireGeofence == requireGeofence) &&
            (identical(other.requireFaceRecognition, requireFaceRecognition) ||
                other.requireFaceRecognition == requireFaceRecognition) &&
            (identical(other.autoEndSession, autoEndSession) ||
                other.autoEndSession == autoEndSession) &&
            (identical(other.lateThresholdMinutes, lateThresholdMinutes) ||
                other.lateThresholdMinutes == lateThresholdMinutes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.lecturer, lecturer) ||
                other.lecturer == lecturer) &&
            const DeepCollectionEquality()
                .equals(other._attendanceRecords, _attendanceRecords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        courseId,
        lecturerId,
        title,
        description,
        sessionType,
        scheduledStart,
        scheduledEnd,
        actualStart,
        actualEnd,
        status,
        locationName,
        locationLatitude,
        locationLongitude,
        geofenceRadius,
        requireGeofence,
        requireFaceRecognition,
        autoEndSession,
        lateThresholdMinutes,
        createdAt,
        updatedAt,
        course,
        lecturer,
        const DeepCollectionEquality().hash(_attendanceRecords)
      ]);

  @override
  String toString() {
    return 'AttendanceSessionModel(id: $id, courseId: $courseId, lecturerId: $lecturerId, title: $title, description: $description, sessionType: $sessionType, scheduledStart: $scheduledStart, scheduledEnd: $scheduledEnd, actualStart: $actualStart, actualEnd: $actualEnd, status: $status, locationName: $locationName, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, geofenceRadius: $geofenceRadius, requireGeofence: $requireGeofence, requireFaceRecognition: $requireFaceRecognition, autoEndSession: $autoEndSession, lateThresholdMinutes: $lateThresholdMinutes, createdAt: $createdAt, updatedAt: $updatedAt, course: $course, lecturer: $lecturer, attendanceRecords: $attendanceRecords)';
  }
}

/// @nodoc
abstract mixin class _$AttendanceSessionModelCopyWith<$Res>
    implements $AttendanceSessionModelCopyWith<$Res> {
  factory _$AttendanceSessionModelCopyWith(_AttendanceSessionModel value,
          $Res Function(_AttendanceSessionModel) _then) =
      __$AttendanceSessionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String courseId,
      String lecturerId,
      String title,
      String? description,
      String sessionType,
      DateTime scheduledStart,
      DateTime scheduledEnd,
      DateTime? actualStart,
      DateTime? actualEnd,
      SessionStatus status,
      String? locationName,
      double? locationLatitude,
      double? locationLongitude,
      int geofenceRadius,
      bool requireGeofence,
      bool requireFaceRecognition,
      bool autoEndSession,
      int lateThresholdMinutes,
      DateTime createdAt,
      DateTime updatedAt,
      CourseModel? course,
      LecturerModel? lecturer,
      List<AttendanceRecordModel>? attendanceRecords});

  @override
  $CourseModelCopyWith<$Res>? get course;
  @override
  $LecturerModelCopyWith<$Res>? get lecturer;
}

/// @nodoc
class __$AttendanceSessionModelCopyWithImpl<$Res>
    implements _$AttendanceSessionModelCopyWith<$Res> {
  __$AttendanceSessionModelCopyWithImpl(this._self, this._then);

  final _AttendanceSessionModel _self;
  final $Res Function(_AttendanceSessionModel) _then;

  /// Create a copy of AttendanceSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? lecturerId = null,
    Object? title = null,
    Object? description = freezed,
    Object? sessionType = null,
    Object? scheduledStart = null,
    Object? scheduledEnd = null,
    Object? actualStart = freezed,
    Object? actualEnd = freezed,
    Object? status = null,
    Object? locationName = freezed,
    Object? locationLatitude = freezed,
    Object? locationLongitude = freezed,
    Object? geofenceRadius = null,
    Object? requireGeofence = null,
    Object? requireFaceRecognition = null,
    Object? autoEndSession = null,
    Object? lateThresholdMinutes = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? course = freezed,
    Object? lecturer = freezed,
    Object? attendanceRecords = freezed,
  }) {
    return _then(_AttendanceSessionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      courseId: null == courseId
          ? _self.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String,
      lecturerId: null == lecturerId
          ? _self.lecturerId
          : lecturerId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionType: null == sessionType
          ? _self.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledStart: null == scheduledStart
          ? _self.scheduledStart
          : scheduledStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledEnd: null == scheduledEnd
          ? _self.scheduledEnd
          : scheduledEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actualStart: freezed == actualStart
          ? _self.actualStart
          : actualStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEnd: freezed == actualEnd
          ? _self.actualEnd
          : actualEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as SessionStatus,
      locationName: freezed == locationName
          ? _self.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationLatitude: freezed == locationLatitude
          ? _self.locationLatitude
          : locationLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLongitude: freezed == locationLongitude
          ? _self.locationLongitude
          : locationLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      geofenceRadius: null == geofenceRadius
          ? _self.geofenceRadius
          : geofenceRadius // ignore: cast_nullable_to_non_nullable
              as int,
      requireGeofence: null == requireGeofence
          ? _self.requireGeofence
          : requireGeofence // ignore: cast_nullable_to_non_nullable
              as bool,
      requireFaceRecognition: null == requireFaceRecognition
          ? _self.requireFaceRecognition
          : requireFaceRecognition // ignore: cast_nullable_to_non_nullable
              as bool,
      autoEndSession: null == autoEndSession
          ? _self.autoEndSession
          : autoEndSession // ignore: cast_nullable_to_non_nullable
              as bool,
      lateThresholdMinutes: null == lateThresholdMinutes
          ? _self.lateThresholdMinutes
          : lateThresholdMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      course: freezed == course
          ? _self.course
          : course // ignore: cast_nullable_to_non_nullable
              as CourseModel?,
      lecturer: freezed == lecturer
          ? _self.lecturer
          : lecturer // ignore: cast_nullable_to_non_nullable
              as LecturerModel?,
      attendanceRecords: freezed == attendanceRecords
          ? _self._attendanceRecords
          : attendanceRecords // ignore: cast_nullable_to_non_nullable
              as List<AttendanceRecordModel>?,
    ));
  }

  /// Create a copy of AttendanceSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CourseModelCopyWith<$Res>? get course {
    if (_self.course == null) {
      return null;
    }

    return $CourseModelCopyWith<$Res>(_self.course!, (value) {
      return _then(_self.copyWith(course: value));
    });
  }

  /// Create a copy of AttendanceSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LecturerModelCopyWith<$Res>? get lecturer {
    if (_self.lecturer == null) {
      return null;
    }

    return $LecturerModelCopyWith<$Res>(_self.lecturer!, (value) {
      return _then(_self.copyWith(lecturer: value));
    });
  }
}

/// @nodoc
mixin _$AttendanceRecordModel {
  String get id;
  String get sessionId;
  String get studentId;
  AttendanceStatus get status;
  DateTime get markedAt;
  double? get locationLatitude;
  double? get locationLongitude;
  double? get distanceFromSession;
  double? get faceConfidence;
  String? get faceImageUrl;
  Map<String, dynamic> get deviceInfo;
  String? get ipAddress;
  bool get isManualOverride;
  String? get overrideReason;
  String? get overrideBy;
  String get verificationMethod;
  DateTime get createdAt;
  AttendanceSessionModel? get session;
  StudentModel? get student;

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AttendanceRecordModelCopyWith<AttendanceRecordModel> get copyWith =>
      _$AttendanceRecordModelCopyWithImpl<AttendanceRecordModel>(
          this as AttendanceRecordModel, _$identity);

  /// Serializes this AttendanceRecordModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AttendanceRecordModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.markedAt, markedAt) ||
                other.markedAt == markedAt) &&
            (identical(other.locationLatitude, locationLatitude) ||
                other.locationLatitude == locationLatitude) &&
            (identical(other.locationLongitude, locationLongitude) ||
                other.locationLongitude == locationLongitude) &&
            (identical(other.distanceFromSession, distanceFromSession) ||
                other.distanceFromSession == distanceFromSession) &&
            (identical(other.faceConfidence, faceConfidence) ||
                other.faceConfidence == faceConfidence) &&
            (identical(other.faceImageUrl, faceImageUrl) ||
                other.faceImageUrl == faceImageUrl) &&
            const DeepCollectionEquality()
                .equals(other.deviceInfo, deviceInfo) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.isManualOverride, isManualOverride) ||
                other.isManualOverride == isManualOverride) &&
            (identical(other.overrideReason, overrideReason) ||
                other.overrideReason == overrideReason) &&
            (identical(other.overrideBy, overrideBy) ||
                other.overrideBy == overrideBy) &&
            (identical(other.verificationMethod, verificationMethod) ||
                other.verificationMethod == verificationMethod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.student, student) || other.student == student));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        sessionId,
        studentId,
        status,
        markedAt,
        locationLatitude,
        locationLongitude,
        distanceFromSession,
        faceConfidence,
        faceImageUrl,
        const DeepCollectionEquality().hash(deviceInfo),
        ipAddress,
        isManualOverride,
        overrideReason,
        overrideBy,
        verificationMethod,
        createdAt,
        session,
        student
      ]);

  @override
  String toString() {
    return 'AttendanceRecordModel(id: $id, sessionId: $sessionId, studentId: $studentId, status: $status, markedAt: $markedAt, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, distanceFromSession: $distanceFromSession, faceConfidence: $faceConfidence, faceImageUrl: $faceImageUrl, deviceInfo: $deviceInfo, ipAddress: $ipAddress, isManualOverride: $isManualOverride, overrideReason: $overrideReason, overrideBy: $overrideBy, verificationMethod: $verificationMethod, createdAt: $createdAt, session: $session, student: $student)';
  }
}

/// @nodoc
abstract mixin class $AttendanceRecordModelCopyWith<$Res> {
  factory $AttendanceRecordModelCopyWith(AttendanceRecordModel value,
          $Res Function(AttendanceRecordModel) _then) =
      _$AttendanceRecordModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String sessionId,
      String studentId,
      AttendanceStatus status,
      DateTime markedAt,
      double? locationLatitude,
      double? locationLongitude,
      double? distanceFromSession,
      double? faceConfidence,
      String? faceImageUrl,
      Map<String, dynamic> deviceInfo,
      String? ipAddress,
      bool isManualOverride,
      String? overrideReason,
      String? overrideBy,
      String verificationMethod,
      DateTime createdAt,
      AttendanceSessionModel? session,
      StudentModel? student});

  $AttendanceSessionModelCopyWith<$Res>? get session;
  $StudentModelCopyWith<$Res>? get student;
}

/// @nodoc
class _$AttendanceRecordModelCopyWithImpl<$Res>
    implements $AttendanceRecordModelCopyWith<$Res> {
  _$AttendanceRecordModelCopyWithImpl(this._self, this._then);

  final AttendanceRecordModel _self;
  final $Res Function(AttendanceRecordModel) _then;

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? studentId = null,
    Object? status = null,
    Object? markedAt = null,
    Object? locationLatitude = freezed,
    Object? locationLongitude = freezed,
    Object? distanceFromSession = freezed,
    Object? faceConfidence = freezed,
    Object? faceImageUrl = freezed,
    Object? deviceInfo = null,
    Object? ipAddress = freezed,
    Object? isManualOverride = null,
    Object? overrideReason = freezed,
    Object? overrideBy = freezed,
    Object? verificationMethod = null,
    Object? createdAt = null,
    Object? session = freezed,
    Object? student = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as AttendanceStatus,
      markedAt: null == markedAt
          ? _self.markedAt
          : markedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      locationLatitude: freezed == locationLatitude
          ? _self.locationLatitude
          : locationLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLongitude: freezed == locationLongitude
          ? _self.locationLongitude
          : locationLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceFromSession: freezed == distanceFromSession
          ? _self.distanceFromSession
          : distanceFromSession // ignore: cast_nullable_to_non_nullable
              as double?,
      faceConfidence: freezed == faceConfidence
          ? _self.faceConfidence
          : faceConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      faceImageUrl: freezed == faceImageUrl
          ? _self.faceImageUrl
          : faceImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceInfo: null == deviceInfo
          ? _self.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      ipAddress: freezed == ipAddress
          ? _self.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      isManualOverride: null == isManualOverride
          ? _self.isManualOverride
          : isManualOverride // ignore: cast_nullable_to_non_nullable
              as bool,
      overrideReason: freezed == overrideReason
          ? _self.overrideReason
          : overrideReason // ignore: cast_nullable_to_non_nullable
              as String?,
      overrideBy: freezed == overrideBy
          ? _self.overrideBy
          : overrideBy // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationMethod: null == verificationMethod
          ? _self.verificationMethod
          : verificationMethod // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      session: freezed == session
          ? _self.session
          : session // ignore: cast_nullable_to_non_nullable
              as AttendanceSessionModel?,
      student: freezed == student
          ? _self.student
          : student // ignore: cast_nullable_to_non_nullable
              as StudentModel?,
    ));
  }

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AttendanceSessionModelCopyWith<$Res>? get session {
    if (_self.session == null) {
      return null;
    }

    return $AttendanceSessionModelCopyWith<$Res>(_self.session!, (value) {
      return _then(_self.copyWith(session: value));
    });
  }

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StudentModelCopyWith<$Res>? get student {
    if (_self.student == null) {
      return null;
    }

    return $StudentModelCopyWith<$Res>(_self.student!, (value) {
      return _then(_self.copyWith(student: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _AttendanceRecordModel implements AttendanceRecordModel {
  const _AttendanceRecordModel(
      {required this.id,
      required this.sessionId,
      required this.studentId,
      required this.status,
      required this.markedAt,
      this.locationLatitude,
      this.locationLongitude,
      this.distanceFromSession,
      this.faceConfidence,
      this.faceImageUrl,
      final Map<String, dynamic> deviceInfo = const {},
      this.ipAddress,
      this.isManualOverride = false,
      this.overrideReason,
      this.overrideBy,
      this.verificationMethod = 'face_location',
      required this.createdAt,
      this.session,
      this.student})
      : _deviceInfo = deviceInfo;
  factory _AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);

  @override
  final String id;
  @override
  final String sessionId;
  @override
  final String studentId;
  @override
  final AttendanceStatus status;
  @override
  final DateTime markedAt;
  @override
  final double? locationLatitude;
  @override
  final double? locationLongitude;
  @override
  final double? distanceFromSession;
  @override
  final double? faceConfidence;
  @override
  final String? faceImageUrl;
  final Map<String, dynamic> _deviceInfo;
  @override
  @JsonKey()
  Map<String, dynamic> get deviceInfo {
    if (_deviceInfo is EqualUnmodifiableMapView) return _deviceInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_deviceInfo);
  }

  @override
  final String? ipAddress;
  @override
  @JsonKey()
  final bool isManualOverride;
  @override
  final String? overrideReason;
  @override
  final String? overrideBy;
  @override
  @JsonKey()
  final String verificationMethod;
  @override
  final DateTime createdAt;
  @override
  final AttendanceSessionModel? session;
  @override
  final StudentModel? student;

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AttendanceRecordModelCopyWith<_AttendanceRecordModel> get copyWith =>
      __$AttendanceRecordModelCopyWithImpl<_AttendanceRecordModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AttendanceRecordModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AttendanceRecordModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.markedAt, markedAt) ||
                other.markedAt == markedAt) &&
            (identical(other.locationLatitude, locationLatitude) ||
                other.locationLatitude == locationLatitude) &&
            (identical(other.locationLongitude, locationLongitude) ||
                other.locationLongitude == locationLongitude) &&
            (identical(other.distanceFromSession, distanceFromSession) ||
                other.distanceFromSession == distanceFromSession) &&
            (identical(other.faceConfidence, faceConfidence) ||
                other.faceConfidence == faceConfidence) &&
            (identical(other.faceImageUrl, faceImageUrl) ||
                other.faceImageUrl == faceImageUrl) &&
            const DeepCollectionEquality()
                .equals(other._deviceInfo, _deviceInfo) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.isManualOverride, isManualOverride) ||
                other.isManualOverride == isManualOverride) &&
            (identical(other.overrideReason, overrideReason) ||
                other.overrideReason == overrideReason) &&
            (identical(other.overrideBy, overrideBy) ||
                other.overrideBy == overrideBy) &&
            (identical(other.verificationMethod, verificationMethod) ||
                other.verificationMethod == verificationMethod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.student, student) || other.student == student));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        sessionId,
        studentId,
        status,
        markedAt,
        locationLatitude,
        locationLongitude,
        distanceFromSession,
        faceConfidence,
        faceImageUrl,
        const DeepCollectionEquality().hash(_deviceInfo),
        ipAddress,
        isManualOverride,
        overrideReason,
        overrideBy,
        verificationMethod,
        createdAt,
        session,
        student
      ]);

  @override
  String toString() {
    return 'AttendanceRecordModel(id: $id, sessionId: $sessionId, studentId: $studentId, status: $status, markedAt: $markedAt, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, distanceFromSession: $distanceFromSession, faceConfidence: $faceConfidence, faceImageUrl: $faceImageUrl, deviceInfo: $deviceInfo, ipAddress: $ipAddress, isManualOverride: $isManualOverride, overrideReason: $overrideReason, overrideBy: $overrideBy, verificationMethod: $verificationMethod, createdAt: $createdAt, session: $session, student: $student)';
  }
}

/// @nodoc
abstract mixin class _$AttendanceRecordModelCopyWith<$Res>
    implements $AttendanceRecordModelCopyWith<$Res> {
  factory _$AttendanceRecordModelCopyWith(_AttendanceRecordModel value,
          $Res Function(_AttendanceRecordModel) _then) =
      __$AttendanceRecordModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String sessionId,
      String studentId,
      AttendanceStatus status,
      DateTime markedAt,
      double? locationLatitude,
      double? locationLongitude,
      double? distanceFromSession,
      double? faceConfidence,
      String? faceImageUrl,
      Map<String, dynamic> deviceInfo,
      String? ipAddress,
      bool isManualOverride,
      String? overrideReason,
      String? overrideBy,
      String verificationMethod,
      DateTime createdAt,
      AttendanceSessionModel? session,
      StudentModel? student});

  @override
  $AttendanceSessionModelCopyWith<$Res>? get session;
  @override
  $StudentModelCopyWith<$Res>? get student;
}

/// @nodoc
class __$AttendanceRecordModelCopyWithImpl<$Res>
    implements _$AttendanceRecordModelCopyWith<$Res> {
  __$AttendanceRecordModelCopyWithImpl(this._self, this._then);

  final _AttendanceRecordModel _self;
  final $Res Function(_AttendanceRecordModel) _then;

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? studentId = null,
    Object? status = null,
    Object? markedAt = null,
    Object? locationLatitude = freezed,
    Object? locationLongitude = freezed,
    Object? distanceFromSession = freezed,
    Object? faceConfidence = freezed,
    Object? faceImageUrl = freezed,
    Object? deviceInfo = null,
    Object? ipAddress = freezed,
    Object? isManualOverride = null,
    Object? overrideReason = freezed,
    Object? overrideBy = freezed,
    Object? verificationMethod = null,
    Object? createdAt = null,
    Object? session = freezed,
    Object? student = freezed,
  }) {
    return _then(_AttendanceRecordModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as AttendanceStatus,
      markedAt: null == markedAt
          ? _self.markedAt
          : markedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      locationLatitude: freezed == locationLatitude
          ? _self.locationLatitude
          : locationLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      locationLongitude: freezed == locationLongitude
          ? _self.locationLongitude
          : locationLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceFromSession: freezed == distanceFromSession
          ? _self.distanceFromSession
          : distanceFromSession // ignore: cast_nullable_to_non_nullable
              as double?,
      faceConfidence: freezed == faceConfidence
          ? _self.faceConfidence
          : faceConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      faceImageUrl: freezed == faceImageUrl
          ? _self.faceImageUrl
          : faceImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceInfo: null == deviceInfo
          ? _self._deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      ipAddress: freezed == ipAddress
          ? _self.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      isManualOverride: null == isManualOverride
          ? _self.isManualOverride
          : isManualOverride // ignore: cast_nullable_to_non_nullable
              as bool,
      overrideReason: freezed == overrideReason
          ? _self.overrideReason
          : overrideReason // ignore: cast_nullable_to_non_nullable
              as String?,
      overrideBy: freezed == overrideBy
          ? _self.overrideBy
          : overrideBy // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationMethod: null == verificationMethod
          ? _self.verificationMethod
          : verificationMethod // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      session: freezed == session
          ? _self.session
          : session // ignore: cast_nullable_to_non_nullable
              as AttendanceSessionModel?,
      student: freezed == student
          ? _self.student
          : student // ignore: cast_nullable_to_non_nullable
              as StudentModel?,
    ));
  }

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AttendanceSessionModelCopyWith<$Res>? get session {
    if (_self.session == null) {
      return null;
    }

    return $AttendanceSessionModelCopyWith<$Res>(_self.session!, (value) {
      return _then(_self.copyWith(session: value));
    });
  }

  /// Create a copy of AttendanceRecordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StudentModelCopyWith<$Res>? get student {
    if (_self.student == null) {
      return null;
    }

    return $StudentModelCopyWith<$Res>(_self.student!, (value) {
      return _then(_self.copyWith(student: value));
    });
  }
}

/// @nodoc
mixin _$FaceDataModel {
  String get id;
  String get studentId;
  List<int> get faceEncoding;
  String? get faceImageUrl;
  double get confidenceThreshold;
  List<List<int>> get backupEncodings;
  DateTime get lastUpdated;
  bool get isVerified;
  int get verificationAttempts;
  DateTime get createdAt;
  DateTime get updatedAt;
  StudentModel? get student;

  /// Create a copy of FaceDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FaceDataModelCopyWith<FaceDataModel> get copyWith =>
      _$FaceDataModelCopyWithImpl<FaceDataModel>(
          this as FaceDataModel, _$identity);

  /// Serializes this FaceDataModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FaceDataModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            const DeepCollectionEquality()
                .equals(other.faceEncoding, faceEncoding) &&
            (identical(other.faceImageUrl, faceImageUrl) ||
                other.faceImageUrl == faceImageUrl) &&
            (identical(other.confidenceThreshold, confidenceThreshold) ||
                other.confidenceThreshold == confidenceThreshold) &&
            const DeepCollectionEquality()
                .equals(other.backupEncodings, backupEncodings) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.verificationAttempts, verificationAttempts) ||
                other.verificationAttempts == verificationAttempts) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.student, student) || other.student == student));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      const DeepCollectionEquality().hash(faceEncoding),
      faceImageUrl,
      confidenceThreshold,
      const DeepCollectionEquality().hash(backupEncodings),
      lastUpdated,
      isVerified,
      verificationAttempts,
      createdAt,
      updatedAt,
      student);

  @override
  String toString() {
    return 'FaceDataModel(id: $id, studentId: $studentId, faceEncoding: $faceEncoding, faceImageUrl: $faceImageUrl, confidenceThreshold: $confidenceThreshold, backupEncodings: $backupEncodings, lastUpdated: $lastUpdated, isVerified: $isVerified, verificationAttempts: $verificationAttempts, createdAt: $createdAt, updatedAt: $updatedAt, student: $student)';
  }
}

/// @nodoc
abstract mixin class $FaceDataModelCopyWith<$Res> {
  factory $FaceDataModelCopyWith(
          FaceDataModel value, $Res Function(FaceDataModel) _then) =
      _$FaceDataModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String studentId,
      List<int> faceEncoding,
      String? faceImageUrl,
      double confidenceThreshold,
      List<List<int>> backupEncodings,
      DateTime lastUpdated,
      bool isVerified,
      int verificationAttempts,
      DateTime createdAt,
      DateTime updatedAt,
      StudentModel? student});

  $StudentModelCopyWith<$Res>? get student;
}

/// @nodoc
class _$FaceDataModelCopyWithImpl<$Res>
    implements $FaceDataModelCopyWith<$Res> {
  _$FaceDataModelCopyWithImpl(this._self, this._then);

  final FaceDataModel _self;
  final $Res Function(FaceDataModel) _then;

  /// Create a copy of FaceDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? faceEncoding = null,
    Object? faceImageUrl = freezed,
    Object? confidenceThreshold = null,
    Object? backupEncodings = null,
    Object? lastUpdated = null,
    Object? isVerified = null,
    Object? verificationAttempts = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? student = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      faceEncoding: null == faceEncoding
          ? _self.faceEncoding
          : faceEncoding // ignore: cast_nullable_to_non_nullable
              as List<int>,
      faceImageUrl: freezed == faceImageUrl
          ? _self.faceImageUrl
          : faceImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      confidenceThreshold: null == confidenceThreshold
          ? _self.confidenceThreshold
          : confidenceThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      backupEncodings: null == backupEncodings
          ? _self.backupEncodings
          : backupEncodings // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isVerified: null == isVerified
          ? _self.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      verificationAttempts: null == verificationAttempts
          ? _self.verificationAttempts
          : verificationAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      student: freezed == student
          ? _self.student
          : student // ignore: cast_nullable_to_non_nullable
              as StudentModel?,
    ));
  }

  /// Create a copy of FaceDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StudentModelCopyWith<$Res>? get student {
    if (_self.student == null) {
      return null;
    }

    return $StudentModelCopyWith<$Res>(_self.student!, (value) {
      return _then(_self.copyWith(student: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _FaceDataModel implements FaceDataModel {
  const _FaceDataModel(
      {required this.id,
      required this.studentId,
      required final List<int> faceEncoding,
      this.faceImageUrl,
      this.confidenceThreshold = 0.8,
      final List<List<int>> backupEncodings = const [],
      required this.lastUpdated,
      this.isVerified = false,
      this.verificationAttempts = 0,
      required this.createdAt,
      required this.updatedAt,
      this.student})
      : _faceEncoding = faceEncoding,
        _backupEncodings = backupEncodings;
  factory _FaceDataModel.fromJson(Map<String, dynamic> json) =>
      _$FaceDataModelFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  final List<int> _faceEncoding;
  @override
  List<int> get faceEncoding {
    if (_faceEncoding is EqualUnmodifiableListView) return _faceEncoding;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_faceEncoding);
  }

  @override
  final String? faceImageUrl;
  @override
  @JsonKey()
  final double confidenceThreshold;
  final List<List<int>> _backupEncodings;
  @override
  @JsonKey()
  List<List<int>> get backupEncodings {
    if (_backupEncodings is EqualUnmodifiableListView) return _backupEncodings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_backupEncodings);
  }

  @override
  final DateTime lastUpdated;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final int verificationAttempts;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final StudentModel? student;

  /// Create a copy of FaceDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FaceDataModelCopyWith<_FaceDataModel> get copyWith =>
      __$FaceDataModelCopyWithImpl<_FaceDataModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FaceDataModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FaceDataModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            const DeepCollectionEquality()
                .equals(other._faceEncoding, _faceEncoding) &&
            (identical(other.faceImageUrl, faceImageUrl) ||
                other.faceImageUrl == faceImageUrl) &&
            (identical(other.confidenceThreshold, confidenceThreshold) ||
                other.confidenceThreshold == confidenceThreshold) &&
            const DeepCollectionEquality()
                .equals(other._backupEncodings, _backupEncodings) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.verificationAttempts, verificationAttempts) ||
                other.verificationAttempts == verificationAttempts) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.student, student) || other.student == student));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      const DeepCollectionEquality().hash(_faceEncoding),
      faceImageUrl,
      confidenceThreshold,
      const DeepCollectionEquality().hash(_backupEncodings),
      lastUpdated,
      isVerified,
      verificationAttempts,
      createdAt,
      updatedAt,
      student);

  @override
  String toString() {
    return 'FaceDataModel(id: $id, studentId: $studentId, faceEncoding: $faceEncoding, faceImageUrl: $faceImageUrl, confidenceThreshold: $confidenceThreshold, backupEncodings: $backupEncodings, lastUpdated: $lastUpdated, isVerified: $isVerified, verificationAttempts: $verificationAttempts, createdAt: $createdAt, updatedAt: $updatedAt, student: $student)';
  }
}

/// @nodoc
abstract mixin class _$FaceDataModelCopyWith<$Res>
    implements $FaceDataModelCopyWith<$Res> {
  factory _$FaceDataModelCopyWith(
          _FaceDataModel value, $Res Function(_FaceDataModel) _then) =
      __$FaceDataModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String studentId,
      List<int> faceEncoding,
      String? faceImageUrl,
      double confidenceThreshold,
      List<List<int>> backupEncodings,
      DateTime lastUpdated,
      bool isVerified,
      int verificationAttempts,
      DateTime createdAt,
      DateTime updatedAt,
      StudentModel? student});

  @override
  $StudentModelCopyWith<$Res>? get student;
}

/// @nodoc
class __$FaceDataModelCopyWithImpl<$Res>
    implements _$FaceDataModelCopyWith<$Res> {
  __$FaceDataModelCopyWithImpl(this._self, this._then);

  final _FaceDataModel _self;
  final $Res Function(_FaceDataModel) _then;

  /// Create a copy of FaceDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? faceEncoding = null,
    Object? faceImageUrl = freezed,
    Object? confidenceThreshold = null,
    Object? backupEncodings = null,
    Object? lastUpdated = null,
    Object? isVerified = null,
    Object? verificationAttempts = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? student = freezed,
  }) {
    return _then(_FaceDataModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      faceEncoding: null == faceEncoding
          ? _self._faceEncoding
          : faceEncoding // ignore: cast_nullable_to_non_nullable
              as List<int>,
      faceImageUrl: freezed == faceImageUrl
          ? _self.faceImageUrl
          : faceImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      confidenceThreshold: null == confidenceThreshold
          ? _self.confidenceThreshold
          : confidenceThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      backupEncodings: null == backupEncodings
          ? _self._backupEncodings
          : backupEncodings // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isVerified: null == isVerified
          ? _self.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      verificationAttempts: null == verificationAttempts
          ? _self.verificationAttempts
          : verificationAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      student: freezed == student
          ? _self.student
          : student // ignore: cast_nullable_to_non_nullable
              as StudentModel?,
    ));
  }

  /// Create a copy of FaceDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StudentModelCopyWith<$Res>? get student {
    if (_self.student == null) {
      return null;
    }

    return $StudentModelCopyWith<$Res>(_self.student!, (value) {
      return _then(_self.copyWith(student: value));
    });
  }
}

// dart format on
