// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {
  String get id;
  String get email;
  String get fullName;
  UserRole get role;
  String? get avatarUrl;
  String? get phone;
  bool get isActive;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<UserModel> get copyWith =>
      _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, fullName, role,
      avatarUrl, phone, isActive, createdAt, updatedAt);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, fullName: $fullName, role: $role, avatarUrl: $avatarUrl, phone: $phone, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) =
      _$UserModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String email,
      String fullName,
      UserRole role,
      String? avatarUrl,
      String? phone,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res> implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = null,
    Object? role = null,
    Object? avatarUrl = freezed,
    Object? phone = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserModel implements UserModel {
  const _UserModel(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.role,
      this.avatarUrl,
      this.phone,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt});
  factory _UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String fullName;
  @override
  final UserRole role;
  @override
  final String? avatarUrl;
  @override
  final String? phone;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserModelCopyWith<_UserModel> get copyWith =>
      __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, fullName, role,
      avatarUrl, phone, isActive, createdAt, updatedAt);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, fullName: $fullName, role: $role, avatarUrl: $avatarUrl, phone: $phone, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(
          _UserModel value, $Res Function(_UserModel) _then) =
      __$UserModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String fullName,
      UserRole role,
      String? avatarUrl,
      String? phone,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$UserModelCopyWithImpl<$Res> implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = null,
    Object? role = null,
    Object? avatarUrl = freezed,
    Object? phone = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_UserModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$StudentModel {
  String? get id;
  String? get matricule;
  String? get departmentId;
  int? get level;
  int? get admissionYear;
  int? get graduationYear;
  int get currentSemester;
  String get currentAcademicYear;
  bool get isActive;
  DateTime? get createdAt;
  DateTime? get updatedAt;
  UserModel? get user;
  DepartmentModel? get department;

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StudentModelCopyWith<StudentModel> get copyWith =>
      _$StudentModelCopyWithImpl<StudentModel>(
          this as StudentModel, _$identity);

  /// Serializes this StudentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StudentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.matricule, matricule) ||
                other.matricule == matricule) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.admissionYear, admissionYear) ||
                other.admissionYear == admissionYear) &&
            (identical(other.graduationYear, graduationYear) ||
                other.graduationYear == graduationYear) &&
            (identical(other.currentSemester, currentSemester) ||
                other.currentSemester == currentSemester) &&
            (identical(other.currentAcademicYear, currentAcademicYear) ||
                other.currentAcademicYear == currentAcademicYear) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.department, department) ||
                other.department == department));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      matricule,
      departmentId,
      level,
      admissionYear,
      graduationYear,
      currentSemester,
      currentAcademicYear,
      isActive,
      createdAt,
      updatedAt,
      user,
      department);

  @override
  String toString() {
    return 'StudentModel(id: $id, matricule: $matricule, departmentId: $departmentId, level: $level, admissionYear: $admissionYear, graduationYear: $graduationYear, currentSemester: $currentSemester, currentAcademicYear: $currentAcademicYear, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, department: $department)';
  }
}

/// @nodoc
abstract mixin class $StudentModelCopyWith<$Res> {
  factory $StudentModelCopyWith(
          StudentModel value, $Res Function(StudentModel) _then) =
      _$StudentModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? matricule,
      String? departmentId,
      int? level,
      int? admissionYear,
      int? graduationYear,
      int currentSemester,
      String currentAcademicYear,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      UserModel? user,
      DepartmentModel? department});

  $UserModelCopyWith<$Res>? get user;
  $DepartmentModelCopyWith<$Res>? get department;
}

/// @nodoc
class _$StudentModelCopyWithImpl<$Res> implements $StudentModelCopyWith<$Res> {
  _$StudentModelCopyWithImpl(this._self, this._then);

  final StudentModel _self;
  final $Res Function(StudentModel) _then;

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? matricule = freezed,
    Object? departmentId = freezed,
    Object? level = freezed,
    Object? admissionYear = freezed,
    Object? graduationYear = freezed,
    Object? currentSemester = null,
    Object? currentAcademicYear = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? user = freezed,
    Object? department = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      matricule: freezed == matricule
          ? _self.matricule
          : matricule // ignore: cast_nullable_to_non_nullable
              as String?,
      departmentId: freezed == departmentId
          ? _self.departmentId
          : departmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      level: freezed == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int?,
      admissionYear: freezed == admissionYear
          ? _self.admissionYear
          : admissionYear // ignore: cast_nullable_to_non_nullable
              as int?,
      graduationYear: freezed == graduationYear
          ? _self.graduationYear
          : graduationYear // ignore: cast_nullable_to_non_nullable
              as int?,
      currentSemester: null == currentSemester
          ? _self.currentSemester
          : currentSemester // ignore: cast_nullable_to_non_nullable
              as int,
      currentAcademicYear: null == currentAcademicYear
          ? _self.currentAcademicYear
          : currentAcademicYear // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as DepartmentModel?,
    ));
  }

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DepartmentModelCopyWith<$Res>? get department {
    if (_self.department == null) {
      return null;
    }

    return $DepartmentModelCopyWith<$Res>(_self.department!, (value) {
      return _then(_self.copyWith(department: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _StudentModel implements StudentModel {
  const _StudentModel(
      {this.id,
      this.matricule,
      this.departmentId,
      this.level,
      this.admissionYear,
      this.graduationYear,
      this.currentSemester = 1,
      this.currentAcademicYear = '2024-2025',
      this.isActive = true,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.department});
  factory _StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  @override
  final String? id;
  @override
  final String? matricule;
  @override
  final String? departmentId;
  @override
  final int? level;
  @override
  final int? admissionYear;
  @override
  final int? graduationYear;
  @override
  @JsonKey()
  final int currentSemester;
  @override
  @JsonKey()
  final String currentAcademicYear;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final UserModel? user;
  @override
  final DepartmentModel? department;

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StudentModelCopyWith<_StudentModel> get copyWith =>
      __$StudentModelCopyWithImpl<_StudentModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StudentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StudentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.matricule, matricule) ||
                other.matricule == matricule) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.admissionYear, admissionYear) ||
                other.admissionYear == admissionYear) &&
            (identical(other.graduationYear, graduationYear) ||
                other.graduationYear == graduationYear) &&
            (identical(other.currentSemester, currentSemester) ||
                other.currentSemester == currentSemester) &&
            (identical(other.currentAcademicYear, currentAcademicYear) ||
                other.currentAcademicYear == currentAcademicYear) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.department, department) ||
                other.department == department));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      matricule,
      departmentId,
      level,
      admissionYear,
      graduationYear,
      currentSemester,
      currentAcademicYear,
      isActive,
      createdAt,
      updatedAt,
      user,
      department);

  @override
  String toString() {
    return 'StudentModel(id: $id, matricule: $matricule, departmentId: $departmentId, level: $level, admissionYear: $admissionYear, graduationYear: $graduationYear, currentSemester: $currentSemester, currentAcademicYear: $currentAcademicYear, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, department: $department)';
  }
}

/// @nodoc
abstract mixin class _$StudentModelCopyWith<$Res>
    implements $StudentModelCopyWith<$Res> {
  factory _$StudentModelCopyWith(
          _StudentModel value, $Res Function(_StudentModel) _then) =
      __$StudentModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? matricule,
      String? departmentId,
      int? level,
      int? admissionYear,
      int? graduationYear,
      int currentSemester,
      String currentAcademicYear,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      UserModel? user,
      DepartmentModel? department});

  @override
  $UserModelCopyWith<$Res>? get user;
  @override
  $DepartmentModelCopyWith<$Res>? get department;
}

/// @nodoc
class __$StudentModelCopyWithImpl<$Res>
    implements _$StudentModelCopyWith<$Res> {
  __$StudentModelCopyWithImpl(this._self, this._then);

  final _StudentModel _self;
  final $Res Function(_StudentModel) _then;

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? matricule = freezed,
    Object? departmentId = freezed,
    Object? level = freezed,
    Object? admissionYear = freezed,
    Object? graduationYear = freezed,
    Object? currentSemester = null,
    Object? currentAcademicYear = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? user = freezed,
    Object? department = freezed,
  }) {
    return _then(_StudentModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      matricule: freezed == matricule
          ? _self.matricule
          : matricule // ignore: cast_nullable_to_non_nullable
              as String?,
      departmentId: freezed == departmentId
          ? _self.departmentId
          : departmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      level: freezed == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int?,
      admissionYear: freezed == admissionYear
          ? _self.admissionYear
          : admissionYear // ignore: cast_nullable_to_non_nullable
              as int?,
      graduationYear: freezed == graduationYear
          ? _self.graduationYear
          : graduationYear // ignore: cast_nullable_to_non_nullable
              as int?,
      currentSemester: null == currentSemester
          ? _self.currentSemester
          : currentSemester // ignore: cast_nullable_to_non_nullable
              as int,
      currentAcademicYear: null == currentAcademicYear
          ? _self.currentAcademicYear
          : currentAcademicYear // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as DepartmentModel?,
    ));
  }

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }

  /// Create a copy of StudentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DepartmentModelCopyWith<$Res>? get department {
    if (_self.department == null) {
      return null;
    }

    return $DepartmentModelCopyWith<$Res>(_self.department!, (value) {
      return _then(_self.copyWith(department: value));
    });
  }
}

/// @nodoc
mixin _$LecturerModel {
  String get id;
  String get employeeId;
  String get departmentId;
  String? get title;
  String? get specialization;
  DateTime? get hireDate;
  String? get officeLocation;
  String? get officeHours;
  bool get isActive;
  DateTime get createdAt;
  DateTime get updatedAt;
  UserModel? get user;
  DepartmentModel? get department;

  /// Create a copy of LecturerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LecturerModelCopyWith<LecturerModel> get copyWith =>
      _$LecturerModelCopyWithImpl<LecturerModel>(
          this as LecturerModel, _$identity);

  /// Serializes this LecturerModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LecturerModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            (identical(other.hireDate, hireDate) ||
                other.hireDate == hireDate) &&
            (identical(other.officeLocation, officeLocation) ||
                other.officeLocation == officeLocation) &&
            (identical(other.officeHours, officeHours) ||
                other.officeHours == officeHours) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.department, department) ||
                other.department == department));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      employeeId,
      departmentId,
      title,
      specialization,
      hireDate,
      officeLocation,
      officeHours,
      isActive,
      createdAt,
      updatedAt,
      user,
      department);

  @override
  String toString() {
    return 'LecturerModel(id: $id, employeeId: $employeeId, departmentId: $departmentId, title: $title, specialization: $specialization, hireDate: $hireDate, officeLocation: $officeLocation, officeHours: $officeHours, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, department: $department)';
  }
}

/// @nodoc
abstract mixin class $LecturerModelCopyWith<$Res> {
  factory $LecturerModelCopyWith(
          LecturerModel value, $Res Function(LecturerModel) _then) =
      _$LecturerModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String employeeId,
      String departmentId,
      String? title,
      String? specialization,
      DateTime? hireDate,
      String? officeLocation,
      String? officeHours,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt,
      UserModel? user,
      DepartmentModel? department});

  $UserModelCopyWith<$Res>? get user;
  $DepartmentModelCopyWith<$Res>? get department;
}

/// @nodoc
class _$LecturerModelCopyWithImpl<$Res>
    implements $LecturerModelCopyWith<$Res> {
  _$LecturerModelCopyWithImpl(this._self, this._then);

  final LecturerModel _self;
  final $Res Function(LecturerModel) _then;

  /// Create a copy of LecturerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? departmentId = null,
    Object? title = freezed,
    Object? specialization = freezed,
    Object? hireDate = freezed,
    Object? officeLocation = freezed,
    Object? officeHours = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? user = freezed,
    Object? department = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _self.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      departmentId: null == departmentId
          ? _self.departmentId
          : departmentId // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      specialization: freezed == specialization
          ? _self.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      hireDate: freezed == hireDate
          ? _self.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      officeLocation: freezed == officeLocation
          ? _self.officeLocation
          : officeLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      officeHours: freezed == officeHours
          ? _self.officeHours
          : officeHours // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as DepartmentModel?,
    ));
  }

  /// Create a copy of LecturerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }

  /// Create a copy of LecturerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DepartmentModelCopyWith<$Res>? get department {
    if (_self.department == null) {
      return null;
    }

    return $DepartmentModelCopyWith<$Res>(_self.department!, (value) {
      return _then(_self.copyWith(department: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _LecturerModel implements LecturerModel {
  const _LecturerModel(
      {required this.id,
      required this.employeeId,
      required this.departmentId,
      this.title,
      this.specialization,
      this.hireDate,
      this.officeLocation,
      this.officeHours,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt,
      this.user,
      this.department});
  factory _LecturerModel.fromJson(Map<String, dynamic> json) =>
      _$LecturerModelFromJson(json);

  @override
  final String id;
  @override
  final String employeeId;
  @override
  final String departmentId;
  @override
  final String? title;
  @override
  final String? specialization;
  @override
  final DateTime? hireDate;
  @override
  final String? officeLocation;
  @override
  final String? officeHours;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final UserModel? user;
  @override
  final DepartmentModel? department;

  /// Create a copy of LecturerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LecturerModelCopyWith<_LecturerModel> get copyWith =>
      __$LecturerModelCopyWithImpl<_LecturerModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LecturerModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LecturerModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            (identical(other.hireDate, hireDate) ||
                other.hireDate == hireDate) &&
            (identical(other.officeLocation, officeLocation) ||
                other.officeLocation == officeLocation) &&
            (identical(other.officeHours, officeHours) ||
                other.officeHours == officeHours) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.department, department) ||
                other.department == department));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      employeeId,
      departmentId,
      title,
      specialization,
      hireDate,
      officeLocation,
      officeHours,
      isActive,
      createdAt,
      updatedAt,
      user,
      department);

  @override
  String toString() {
    return 'LecturerModel(id: $id, employeeId: $employeeId, departmentId: $departmentId, title: $title, specialization: $specialization, hireDate: $hireDate, officeLocation: $officeLocation, officeHours: $officeHours, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, department: $department)';
  }
}

/// @nodoc
abstract mixin class _$LecturerModelCopyWith<$Res>
    implements $LecturerModelCopyWith<$Res> {
  factory _$LecturerModelCopyWith(
          _LecturerModel value, $Res Function(_LecturerModel) _then) =
      __$LecturerModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String employeeId,
      String departmentId,
      String? title,
      String? specialization,
      DateTime? hireDate,
      String? officeLocation,
      String? officeHours,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt,
      UserModel? user,
      DepartmentModel? department});

  @override
  $UserModelCopyWith<$Res>? get user;
  @override
  $DepartmentModelCopyWith<$Res>? get department;
}

/// @nodoc
class __$LecturerModelCopyWithImpl<$Res>
    implements _$LecturerModelCopyWith<$Res> {
  __$LecturerModelCopyWithImpl(this._self, this._then);

  final _LecturerModel _self;
  final $Res Function(_LecturerModel) _then;

  /// Create a copy of LecturerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? departmentId = null,
    Object? title = freezed,
    Object? specialization = freezed,
    Object? hireDate = freezed,
    Object? officeLocation = freezed,
    Object? officeHours = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? user = freezed,
    Object? department = freezed,
  }) {
    return _then(_LecturerModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _self.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      departmentId: null == departmentId
          ? _self.departmentId
          : departmentId // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      specialization: freezed == specialization
          ? _self.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      hireDate: freezed == hireDate
          ? _self.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      officeLocation: freezed == officeLocation
          ? _self.officeLocation
          : officeLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      officeHours: freezed == officeHours
          ? _self.officeHours
          : officeHours // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as DepartmentModel?,
    ));
  }

  /// Create a copy of LecturerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }

  /// Create a copy of LecturerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DepartmentModelCopyWith<$Res>? get department {
    if (_self.department == null) {
      return null;
    }

    return $DepartmentModelCopyWith<$Res>(_self.department!, (value) {
      return _then(_self.copyWith(department: value));
    });
  }
}

/// @nodoc
mixin _$AdminModel {
  String get id;
  String? get departmentId;
  String get adminLevel;
  Map<String, dynamic> get permissions;
  DateTime get createdAt;
  DateTime get updatedAt;
  UserModel? get user;
  DepartmentModel? get department;

  /// Create a copy of AdminModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminModelCopyWith<AdminModel> get copyWith =>
      _$AdminModelCopyWithImpl<AdminModel>(this as AdminModel, _$identity);

  /// Serializes this AdminModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.adminLevel, adminLevel) ||
                other.adminLevel == adminLevel) &&
            const DeepCollectionEquality()
                .equals(other.permissions, permissions) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.department, department) ||
                other.department == department));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      departmentId,
      adminLevel,
      const DeepCollectionEquality().hash(permissions),
      createdAt,
      updatedAt,
      user,
      department);

  @override
  String toString() {
    return 'AdminModel(id: $id, departmentId: $departmentId, adminLevel: $adminLevel, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, department: $department)';
  }
}

/// @nodoc
abstract mixin class $AdminModelCopyWith<$Res> {
  factory $AdminModelCopyWith(
          AdminModel value, $Res Function(AdminModel) _then) =
      _$AdminModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? departmentId,
      String adminLevel,
      Map<String, dynamic> permissions,
      DateTime createdAt,
      DateTime updatedAt,
      UserModel? user,
      DepartmentModel? department});

  $UserModelCopyWith<$Res>? get user;
  $DepartmentModelCopyWith<$Res>? get department;
}

/// @nodoc
class _$AdminModelCopyWithImpl<$Res> implements $AdminModelCopyWith<$Res> {
  _$AdminModelCopyWithImpl(this._self, this._then);

  final AdminModel _self;
  final $Res Function(AdminModel) _then;

  /// Create a copy of AdminModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? departmentId = freezed,
    Object? adminLevel = null,
    Object? permissions = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? user = freezed,
    Object? department = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      departmentId: freezed == departmentId
          ? _self.departmentId
          : departmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      adminLevel: null == adminLevel
          ? _self.adminLevel
          : adminLevel // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _self.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as DepartmentModel?,
    ));
  }

  /// Create a copy of AdminModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }

  /// Create a copy of AdminModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DepartmentModelCopyWith<$Res>? get department {
    if (_self.department == null) {
      return null;
    }

    return $DepartmentModelCopyWith<$Res>(_self.department!, (value) {
      return _then(_self.copyWith(department: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _AdminModel implements AdminModel {
  const _AdminModel(
      {required this.id,
      this.departmentId,
      this.adminLevel = 'department',
      final Map<String, dynamic> permissions = const {},
      required this.createdAt,
      required this.updatedAt,
      this.user,
      this.department})
      : _permissions = permissions;
  factory _AdminModel.fromJson(Map<String, dynamic> json) =>
      _$AdminModelFromJson(json);

  @override
  final String id;
  @override
  final String? departmentId;
  @override
  @JsonKey()
  final String adminLevel;
  final Map<String, dynamic> _permissions;
  @override
  @JsonKey()
  Map<String, dynamic> get permissions {
    if (_permissions is EqualUnmodifiableMapView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_permissions);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final UserModel? user;
  @override
  final DepartmentModel? department;

  /// Create a copy of AdminModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdminModelCopyWith<_AdminModel> get copyWith =>
      __$AdminModelCopyWithImpl<_AdminModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AdminModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.adminLevel, adminLevel) ||
                other.adminLevel == adminLevel) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.department, department) ||
                other.department == department));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      departmentId,
      adminLevel,
      const DeepCollectionEquality().hash(_permissions),
      createdAt,
      updatedAt,
      user,
      department);

  @override
  String toString() {
    return 'AdminModel(id: $id, departmentId: $departmentId, adminLevel: $adminLevel, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, department: $department)';
  }
}

/// @nodoc
abstract mixin class _$AdminModelCopyWith<$Res>
    implements $AdminModelCopyWith<$Res> {
  factory _$AdminModelCopyWith(
          _AdminModel value, $Res Function(_AdminModel) _then) =
      __$AdminModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? departmentId,
      String adminLevel,
      Map<String, dynamic> permissions,
      DateTime createdAt,
      DateTime updatedAt,
      UserModel? user,
      DepartmentModel? department});

  @override
  $UserModelCopyWith<$Res>? get user;
  @override
  $DepartmentModelCopyWith<$Res>? get department;
}

/// @nodoc
class __$AdminModelCopyWithImpl<$Res> implements _$AdminModelCopyWith<$Res> {
  __$AdminModelCopyWithImpl(this._self, this._then);

  final _AdminModel _self;
  final $Res Function(_AdminModel) _then;

  /// Create a copy of AdminModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? departmentId = freezed,
    Object? adminLevel = null,
    Object? permissions = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? user = freezed,
    Object? department = freezed,
  }) {
    return _then(_AdminModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      departmentId: freezed == departmentId
          ? _self.departmentId
          : departmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      adminLevel: null == adminLevel
          ? _self.adminLevel
          : adminLevel // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _self._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as DepartmentModel?,
    ));
  }

  /// Create a copy of AdminModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }

  /// Create a copy of AdminModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DepartmentModelCopyWith<$Res>? get department {
    if (_self.department == null) {
      return null;
    }

    return $DepartmentModelCopyWith<$Res>(_self.department!, (value) {
      return _then(_self.copyWith(department: value));
    });
  }
}

// dart format on
