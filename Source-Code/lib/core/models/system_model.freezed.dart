// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SystemSettingsModel {
  String get id;
  String get settingKey;
  Map<String, dynamic> get settingValue;
  String? get description;
  bool get isPublic;
  String? get updatedBy;
  DateTime get updatedAt;

  /// Create a copy of SystemSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SystemSettingsModelCopyWith<SystemSettingsModel> get copyWith =>
      _$SystemSettingsModelCopyWithImpl<SystemSettingsModel>(
          this as SystemSettingsModel, _$identity);

  /// Serializes this SystemSettingsModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SystemSettingsModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.settingKey, settingKey) ||
                other.settingKey == settingKey) &&
            const DeepCollectionEquality()
                .equals(other.settingValue, settingValue) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      settingKey,
      const DeepCollectionEquality().hash(settingValue),
      description,
      isPublic,
      updatedBy,
      updatedAt);

  @override
  String toString() {
    return 'SystemSettingsModel(id: $id, settingKey: $settingKey, settingValue: $settingValue, description: $description, isPublic: $isPublic, updatedBy: $updatedBy, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $SystemSettingsModelCopyWith<$Res> {
  factory $SystemSettingsModelCopyWith(
          SystemSettingsModel value, $Res Function(SystemSettingsModel) _then) =
      _$SystemSettingsModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String settingKey,
      Map<String, dynamic> settingValue,
      String? description,
      bool isPublic,
      String? updatedBy,
      DateTime updatedAt});
}

/// @nodoc
class _$SystemSettingsModelCopyWithImpl<$Res>
    implements $SystemSettingsModelCopyWith<$Res> {
  _$SystemSettingsModelCopyWithImpl(this._self, this._then);

  final SystemSettingsModel _self;
  final $Res Function(SystemSettingsModel) _then;

  /// Create a copy of SystemSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? settingKey = null,
    Object? settingValue = null,
    Object? description = freezed,
    Object? isPublic = null,
    Object? updatedBy = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      settingKey: null == settingKey
          ? _self.settingKey
          : settingKey // ignore: cast_nullable_to_non_nullable
              as String,
      settingValue: null == settingValue
          ? _self.settingValue
          : settingValue // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _self.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedBy: freezed == updatedBy
          ? _self.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SystemSettingsModel implements SystemSettingsModel {
  const _SystemSettingsModel(
      {required this.id,
      required this.settingKey,
      required final Map<String, dynamic> settingValue,
      this.description,
      this.isPublic = false,
      this.updatedBy,
      required this.updatedAt})
      : _settingValue = settingValue;
  factory _SystemSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SystemSettingsModelFromJson(json);

  @override
  final String id;
  @override
  final String settingKey;
  final Map<String, dynamic> _settingValue;
  @override
  Map<String, dynamic> get settingValue {
    if (_settingValue is EqualUnmodifiableMapView) return _settingValue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settingValue);
  }

  @override
  final String? description;
  @override
  @JsonKey()
  final bool isPublic;
  @override
  final String? updatedBy;
  @override
  final DateTime updatedAt;

  /// Create a copy of SystemSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SystemSettingsModelCopyWith<_SystemSettingsModel> get copyWith =>
      __$SystemSettingsModelCopyWithImpl<_SystemSettingsModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SystemSettingsModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SystemSettingsModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.settingKey, settingKey) ||
                other.settingKey == settingKey) &&
            const DeepCollectionEquality()
                .equals(other._settingValue, _settingValue) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      settingKey,
      const DeepCollectionEquality().hash(_settingValue),
      description,
      isPublic,
      updatedBy,
      updatedAt);

  @override
  String toString() {
    return 'SystemSettingsModel(id: $id, settingKey: $settingKey, settingValue: $settingValue, description: $description, isPublic: $isPublic, updatedBy: $updatedBy, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$SystemSettingsModelCopyWith<$Res>
    implements $SystemSettingsModelCopyWith<$Res> {
  factory _$SystemSettingsModelCopyWith(_SystemSettingsModel value,
          $Res Function(_SystemSettingsModel) _then) =
      __$SystemSettingsModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String settingKey,
      Map<String, dynamic> settingValue,
      String? description,
      bool isPublic,
      String? updatedBy,
      DateTime updatedAt});
}

/// @nodoc
class __$SystemSettingsModelCopyWithImpl<$Res>
    implements _$SystemSettingsModelCopyWith<$Res> {
  __$SystemSettingsModelCopyWithImpl(this._self, this._then);

  final _SystemSettingsModel _self;
  final $Res Function(_SystemSettingsModel) _then;

  /// Create a copy of SystemSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? settingKey = null,
    Object? settingValue = null,
    Object? description = freezed,
    Object? isPublic = null,
    Object? updatedBy = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_SystemSettingsModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      settingKey: null == settingKey
          ? _self.settingKey
          : settingKey // ignore: cast_nullable_to_non_nullable
              as String,
      settingValue: null == settingValue
          ? _self._settingValue
          : settingValue // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _self.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedBy: freezed == updatedBy
          ? _self.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$EnrollmentSettings {
  int get maxCoursesPerSemester;
  int get minCreditsPerSemester;
  int get maxCreditsPerSemester;

  /// Create a copy of EnrollmentSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EnrollmentSettingsCopyWith<EnrollmentSettings> get copyWith =>
      _$EnrollmentSettingsCopyWithImpl<EnrollmentSettings>(
          this as EnrollmentSettings, _$identity);

  /// Serializes this EnrollmentSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnrollmentSettings &&
            (identical(other.maxCoursesPerSemester, maxCoursesPerSemester) ||
                other.maxCoursesPerSemester == maxCoursesPerSemester) &&
            (identical(other.minCreditsPerSemester, minCreditsPerSemester) ||
                other.minCreditsPerSemester == minCreditsPerSemester) &&
            (identical(other.maxCreditsPerSemester, maxCreditsPerSemester) ||
                other.maxCreditsPerSemester == maxCreditsPerSemester));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, maxCoursesPerSemester,
      minCreditsPerSemester, maxCreditsPerSemester);

  @override
  String toString() {
    return 'EnrollmentSettings(maxCoursesPerSemester: $maxCoursesPerSemester, minCreditsPerSemester: $minCreditsPerSemester, maxCreditsPerSemester: $maxCreditsPerSemester)';
  }
}

/// @nodoc
abstract mixin class $EnrollmentSettingsCopyWith<$Res> {
  factory $EnrollmentSettingsCopyWith(
          EnrollmentSettings value, $Res Function(EnrollmentSettings) _then) =
      _$EnrollmentSettingsCopyWithImpl;
  @useResult
  $Res call(
      {int maxCoursesPerSemester,
      int minCreditsPerSemester,
      int maxCreditsPerSemester});
}

/// @nodoc
class _$EnrollmentSettingsCopyWithImpl<$Res>
    implements $EnrollmentSettingsCopyWith<$Res> {
  _$EnrollmentSettingsCopyWithImpl(this._self, this._then);

  final EnrollmentSettings _self;
  final $Res Function(EnrollmentSettings) _then;

  /// Create a copy of EnrollmentSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxCoursesPerSemester = null,
    Object? minCreditsPerSemester = null,
    Object? maxCreditsPerSemester = null,
  }) {
    return _then(_self.copyWith(
      maxCoursesPerSemester: null == maxCoursesPerSemester
          ? _self.maxCoursesPerSemester
          : maxCoursesPerSemester // ignore: cast_nullable_to_non_nullable
              as int,
      minCreditsPerSemester: null == minCreditsPerSemester
          ? _self.minCreditsPerSemester
          : minCreditsPerSemester // ignore: cast_nullable_to_non_nullable
              as int,
      maxCreditsPerSemester: null == maxCreditsPerSemester
          ? _self.maxCreditsPerSemester
          : maxCreditsPerSemester // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _EnrollmentSettings implements EnrollmentSettings {
  const _EnrollmentSettings(
      {this.maxCoursesPerSemester = 8,
      this.minCreditsPerSemester = 12,
      this.maxCreditsPerSemester = 21});
  factory _EnrollmentSettings.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentSettingsFromJson(json);

  @override
  @JsonKey()
  final int maxCoursesPerSemester;
  @override
  @JsonKey()
  final int minCreditsPerSemester;
  @override
  @JsonKey()
  final int maxCreditsPerSemester;

  /// Create a copy of EnrollmentSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EnrollmentSettingsCopyWith<_EnrollmentSettings> get copyWith =>
      __$EnrollmentSettingsCopyWithImpl<_EnrollmentSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EnrollmentSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EnrollmentSettings &&
            (identical(other.maxCoursesPerSemester, maxCoursesPerSemester) ||
                other.maxCoursesPerSemester == maxCoursesPerSemester) &&
            (identical(other.minCreditsPerSemester, minCreditsPerSemester) ||
                other.minCreditsPerSemester == minCreditsPerSemester) &&
            (identical(other.maxCreditsPerSemester, maxCreditsPerSemester) ||
                other.maxCreditsPerSemester == maxCreditsPerSemester));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, maxCoursesPerSemester,
      minCreditsPerSemester, maxCreditsPerSemester);

  @override
  String toString() {
    return 'EnrollmentSettings(maxCoursesPerSemester: $maxCoursesPerSemester, minCreditsPerSemester: $minCreditsPerSemester, maxCreditsPerSemester: $maxCreditsPerSemester)';
  }
}

/// @nodoc
abstract mixin class _$EnrollmentSettingsCopyWith<$Res>
    implements $EnrollmentSettingsCopyWith<$Res> {
  factory _$EnrollmentSettingsCopyWith(
          _EnrollmentSettings value, $Res Function(_EnrollmentSettings) _then) =
      __$EnrollmentSettingsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int maxCoursesPerSemester,
      int minCreditsPerSemester,
      int maxCreditsPerSemester});
}

/// @nodoc
class __$EnrollmentSettingsCopyWithImpl<$Res>
    implements _$EnrollmentSettingsCopyWith<$Res> {
  __$EnrollmentSettingsCopyWithImpl(this._self, this._then);

  final _EnrollmentSettings _self;
  final $Res Function(_EnrollmentSettings) _then;

  /// Create a copy of EnrollmentSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? maxCoursesPerSemester = null,
    Object? minCreditsPerSemester = null,
    Object? maxCreditsPerSemester = null,
  }) {
    return _then(_EnrollmentSettings(
      maxCoursesPerSemester: null == maxCoursesPerSemester
          ? _self.maxCoursesPerSemester
          : maxCoursesPerSemester // ignore: cast_nullable_to_non_nullable
              as int,
      minCreditsPerSemester: null == minCreditsPerSemester
          ? _self.minCreditsPerSemester
          : minCreditsPerSemester // ignore: cast_nullable_to_non_nullable
              as int,
      maxCreditsPerSemester: null == maxCreditsPerSemester
          ? _self.maxCreditsPerSemester
          : maxCreditsPerSemester // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$AttendanceSettings {
  double get geofenceRadius;
  double get faceConfidenceThreshold;
  int get lateThresholdMinutes;

  /// Create a copy of AttendanceSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AttendanceSettingsCopyWith<AttendanceSettings> get copyWith =>
      _$AttendanceSettingsCopyWithImpl<AttendanceSettings>(
          this as AttendanceSettings, _$identity);

  /// Serializes this AttendanceSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AttendanceSettings &&
            (identical(other.geofenceRadius, geofenceRadius) ||
                other.geofenceRadius == geofenceRadius) &&
            (identical(
                    other.faceConfidenceThreshold, faceConfidenceThreshold) ||
                other.faceConfidenceThreshold == faceConfidenceThreshold) &&
            (identical(other.lateThresholdMinutes, lateThresholdMinutes) ||
                other.lateThresholdMinutes == lateThresholdMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, geofenceRadius,
      faceConfidenceThreshold, lateThresholdMinutes);

  @override
  String toString() {
    return 'AttendanceSettings(geofenceRadius: $geofenceRadius, faceConfidenceThreshold: $faceConfidenceThreshold, lateThresholdMinutes: $lateThresholdMinutes)';
  }
}

/// @nodoc
abstract mixin class $AttendanceSettingsCopyWith<$Res> {
  factory $AttendanceSettingsCopyWith(
          AttendanceSettings value, $Res Function(AttendanceSettings) _then) =
      _$AttendanceSettingsCopyWithImpl;
  @useResult
  $Res call(
      {double geofenceRadius,
      double faceConfidenceThreshold,
      int lateThresholdMinutes});
}

/// @nodoc
class _$AttendanceSettingsCopyWithImpl<$Res>
    implements $AttendanceSettingsCopyWith<$Res> {
  _$AttendanceSettingsCopyWithImpl(this._self, this._then);

  final AttendanceSettings _self;
  final $Res Function(AttendanceSettings) _then;

  /// Create a copy of AttendanceSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geofenceRadius = null,
    Object? faceConfidenceThreshold = null,
    Object? lateThresholdMinutes = null,
  }) {
    return _then(_self.copyWith(
      geofenceRadius: null == geofenceRadius
          ? _self.geofenceRadius
          : geofenceRadius // ignore: cast_nullable_to_non_nullable
              as double,
      faceConfidenceThreshold: null == faceConfidenceThreshold
          ? _self.faceConfidenceThreshold
          : faceConfidenceThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      lateThresholdMinutes: null == lateThresholdMinutes
          ? _self.lateThresholdMinutes
          : lateThresholdMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AttendanceSettings implements AttendanceSettings {
  const _AttendanceSettings(
      {this.geofenceRadius = 100.0,
      this.faceConfidenceThreshold = 0.8,
      this.lateThresholdMinutes = 15});
  factory _AttendanceSettings.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSettingsFromJson(json);

  @override
  @JsonKey()
  final double geofenceRadius;
  @override
  @JsonKey()
  final double faceConfidenceThreshold;
  @override
  @JsonKey()
  final int lateThresholdMinutes;

  /// Create a copy of AttendanceSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AttendanceSettingsCopyWith<_AttendanceSettings> get copyWith =>
      __$AttendanceSettingsCopyWithImpl<_AttendanceSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AttendanceSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AttendanceSettings &&
            (identical(other.geofenceRadius, geofenceRadius) ||
                other.geofenceRadius == geofenceRadius) &&
            (identical(
                    other.faceConfidenceThreshold, faceConfidenceThreshold) ||
                other.faceConfidenceThreshold == faceConfidenceThreshold) &&
            (identical(other.lateThresholdMinutes, lateThresholdMinutes) ||
                other.lateThresholdMinutes == lateThresholdMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, geofenceRadius,
      faceConfidenceThreshold, lateThresholdMinutes);

  @override
  String toString() {
    return 'AttendanceSettings(geofenceRadius: $geofenceRadius, faceConfidenceThreshold: $faceConfidenceThreshold, lateThresholdMinutes: $lateThresholdMinutes)';
  }
}

/// @nodoc
abstract mixin class _$AttendanceSettingsCopyWith<$Res>
    implements $AttendanceSettingsCopyWith<$Res> {
  factory _$AttendanceSettingsCopyWith(
          _AttendanceSettings value, $Res Function(_AttendanceSettings) _then) =
      __$AttendanceSettingsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double geofenceRadius,
      double faceConfidenceThreshold,
      int lateThresholdMinutes});
}

/// @nodoc
class __$AttendanceSettingsCopyWithImpl<$Res>
    implements _$AttendanceSettingsCopyWith<$Res> {
  __$AttendanceSettingsCopyWithImpl(this._self, this._then);

  final _AttendanceSettings _self;
  final $Res Function(_AttendanceSettings) _then;

  /// Create a copy of AttendanceSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? geofenceRadius = null,
    Object? faceConfidenceThreshold = null,
    Object? lateThresholdMinutes = null,
  }) {
    return _then(_AttendanceSettings(
      geofenceRadius: null == geofenceRadius
          ? _self.geofenceRadius
          : geofenceRadius // ignore: cast_nullable_to_non_nullable
              as double,
      faceConfidenceThreshold: null == faceConfidenceThreshold
          ? _self.faceConfidenceThreshold
          : faceConfidenceThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      lateThresholdMinutes: null == lateThresholdMinutes
          ? _self.lateThresholdMinutes
          : lateThresholdMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
