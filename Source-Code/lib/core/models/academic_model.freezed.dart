// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'academic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FacultyModel {
  String get id;
  String get name;
  String get code;
  String? get description;
  bool get isActive;
  String get createdAt;
  String get updatedAt;

  /// Create a copy of FacultyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FacultyModelCopyWith<FacultyModel> get copyWith =>
      _$FacultyModelCopyWithImpl<FacultyModel>(
          this as FacultyModel, _$identity);

  /// Serializes this FacultyModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FacultyModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, code, description, isActive, createdAt, updatedAt);

  @override
  String toString() {
    return 'FacultyModel(id: $id, name: $name, code: $code, description: $description, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $FacultyModelCopyWith<$Res> {
  factory $FacultyModelCopyWith(
          FacultyModel value, $Res Function(FacultyModel) _then) =
      _$FacultyModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String code,
      String? description,
      bool isActive,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class _$FacultyModelCopyWithImpl<$Res> implements $FacultyModelCopyWith<$Res> {
  _$FacultyModelCopyWithImpl(this._self, this._then);

  final FacultyModel _self;
  final $Res Function(FacultyModel) _then;

  /// Create a copy of FacultyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _FacultyModel implements FacultyModel {
  const _FacultyModel(
      {required this.id,
      required this.name,
      required this.code,
      this.description,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt});
  factory _FacultyModel.fromJson(Map<String, dynamic> json) =>
      _$FacultyModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String code;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  /// Create a copy of FacultyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FacultyModelCopyWith<_FacultyModel> get copyWith =>
      __$FacultyModelCopyWithImpl<_FacultyModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FacultyModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FacultyModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, code, description, isActive, createdAt, updatedAt);

  @override
  String toString() {
    return 'FacultyModel(id: $id, name: $name, code: $code, description: $description, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$FacultyModelCopyWith<$Res>
    implements $FacultyModelCopyWith<$Res> {
  factory _$FacultyModelCopyWith(
          _FacultyModel value, $Res Function(_FacultyModel) _then) =
      __$FacultyModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String code,
      String? description,
      bool isActive,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class __$FacultyModelCopyWithImpl<$Res>
    implements _$FacultyModelCopyWith<$Res> {
  __$FacultyModelCopyWithImpl(this._self, this._then);

  final _FacultyModel _self;
  final $Res Function(_FacultyModel) _then;

  /// Create a copy of FacultyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_FacultyModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$DepartmentModel {
  String get id;
  String get facultyId;
  String get name;
  String get code;
  String? get description;
  bool get isActive;
  String get createdAt;
  String get updatedAt;
  FacultyModel? get faculty;

  /// Create a copy of DepartmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DepartmentModelCopyWith<DepartmentModel> get copyWith =>
      _$DepartmentModelCopyWithImpl<DepartmentModel>(
          this as DepartmentModel, _$identity);

  /// Serializes this DepartmentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DepartmentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.facultyId, facultyId) ||
                other.facultyId == facultyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.faculty, faculty) || other.faculty == faculty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, facultyId, name, code,
      description, isActive, createdAt, updatedAt, faculty);

  @override
  String toString() {
    return 'DepartmentModel(id: $id, facultyId: $facultyId, name: $name, code: $code, description: $description, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, faculty: $faculty)';
  }
}

/// @nodoc
abstract mixin class $DepartmentModelCopyWith<$Res> {
  factory $DepartmentModelCopyWith(
          DepartmentModel value, $Res Function(DepartmentModel) _then) =
      _$DepartmentModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String facultyId,
      String name,
      String code,
      String? description,
      bool isActive,
      String createdAt,
      String updatedAt,
      FacultyModel? faculty});

  $FacultyModelCopyWith<$Res>? get faculty;
}

/// @nodoc
class _$DepartmentModelCopyWithImpl<$Res>
    implements $DepartmentModelCopyWith<$Res> {
  _$DepartmentModelCopyWithImpl(this._self, this._then);

  final DepartmentModel _self;
  final $Res Function(DepartmentModel) _then;

  /// Create a copy of DepartmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? facultyId = null,
    Object? name = null,
    Object? code = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? faculty = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      facultyId: null == facultyId
          ? _self.facultyId
          : facultyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      faculty: freezed == faculty
          ? _self.faculty
          : faculty // ignore: cast_nullable_to_non_nullable
              as FacultyModel?,
    ));
  }

  /// Create a copy of DepartmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FacultyModelCopyWith<$Res>? get faculty {
    if (_self.faculty == null) {
      return null;
    }

    return $FacultyModelCopyWith<$Res>(_self.faculty!, (value) {
      return _then(_self.copyWith(faculty: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _DepartmentModel implements DepartmentModel {
  const _DepartmentModel(
      {required this.id,
      required this.facultyId,
      required this.name,
      required this.code,
      this.description,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt,
      this.faculty});
  factory _DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);

  @override
  final String id;
  @override
  final String facultyId;
  @override
  final String name;
  @override
  final String code;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final FacultyModel? faculty;

  /// Create a copy of DepartmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DepartmentModelCopyWith<_DepartmentModel> get copyWith =>
      __$DepartmentModelCopyWithImpl<_DepartmentModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DepartmentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DepartmentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.facultyId, facultyId) ||
                other.facultyId == facultyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.faculty, faculty) || other.faculty == faculty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, facultyId, name, code,
      description, isActive, createdAt, updatedAt, faculty);

  @override
  String toString() {
    return 'DepartmentModel(id: $id, facultyId: $facultyId, name: $name, code: $code, description: $description, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, faculty: $faculty)';
  }
}

/// @nodoc
abstract mixin class _$DepartmentModelCopyWith<$Res>
    implements $DepartmentModelCopyWith<$Res> {
  factory _$DepartmentModelCopyWith(
          _DepartmentModel value, $Res Function(_DepartmentModel) _then) =
      __$DepartmentModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String facultyId,
      String name,
      String code,
      String? description,
      bool isActive,
      String createdAt,
      String updatedAt,
      FacultyModel? faculty});

  @override
  $FacultyModelCopyWith<$Res>? get faculty;
}

/// @nodoc
class __$DepartmentModelCopyWithImpl<$Res>
    implements _$DepartmentModelCopyWith<$Res> {
  __$DepartmentModelCopyWithImpl(this._self, this._then);

  final _DepartmentModel _self;
  final $Res Function(_DepartmentModel) _then;

  /// Create a copy of DepartmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? facultyId = null,
    Object? name = null,
    Object? code = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? faculty = freezed,
  }) {
    return _then(_DepartmentModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      facultyId: null == facultyId
          ? _self.facultyId
          : facultyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      faculty: freezed == faculty
          ? _self.faculty
          : faculty // ignore: cast_nullable_to_non_nullable
              as FacultyModel?,
    ));
  }

  /// Create a copy of DepartmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FacultyModelCopyWith<$Res>? get faculty {
    if (_self.faculty == null) {
      return null;
    }

    return $FacultyModelCopyWith<$Res>(_self.faculty!, (value) {
      return _then(_self.copyWith(faculty: value));
    });
  }
}

/// @nodoc
mixin _$CourseModel {
  String get id;
  String get departmentId;
  String get code;
  String get title;
  String? get description;
  int get credits;
  int get level;
  int get semester;
  String get academicYear;
  int get maxEnrollment;
  int get currentEnrollment;
  String? get enrollmentStartDate;
  String? get enrollmentEndDate;
  String? get courseStartDate;
  String? get courseEndDate;
  List<String> get prerequisites;
  bool get isActive;
  String get createdAt;
  String get updatedAt;
  DepartmentModel? get department;
  List<Map<String, dynamic>> get lecturers;
  List<StudentModel>? get students;
  List<CoursePrerequisiteModel> get coursePrerequisites;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CourseModelCopyWith<CourseModel> get copyWith =>
      _$CourseModelCopyWithImpl<CourseModel>(this as CourseModel, _$identity);

  /// Serializes this CourseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CourseModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.credits, credits) || other.credits == credits) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.semester, semester) ||
                other.semester == semester) &&
            (identical(other.academicYear, academicYear) ||
                other.academicYear == academicYear) &&
            (identical(other.maxEnrollment, maxEnrollment) ||
                other.maxEnrollment == maxEnrollment) &&
            (identical(other.currentEnrollment, currentEnrollment) ||
                other.currentEnrollment == currentEnrollment) &&
            (identical(other.enrollmentStartDate, enrollmentStartDate) ||
                other.enrollmentStartDate == enrollmentStartDate) &&
            (identical(other.enrollmentEndDate, enrollmentEndDate) ||
                other.enrollmentEndDate == enrollmentEndDate) &&
            (identical(other.courseStartDate, courseStartDate) ||
                other.courseStartDate == courseStartDate) &&
            (identical(other.courseEndDate, courseEndDate) ||
                other.courseEndDate == courseEndDate) &&
            const DeepCollectionEquality()
                .equals(other.prerequisites, prerequisites) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.department, department) ||
                other.department == department) &&
            const DeepCollectionEquality().equals(other.lecturers, lecturers) &&
            const DeepCollectionEquality().equals(other.students, students) &&
            const DeepCollectionEquality()
                .equals(other.coursePrerequisites, coursePrerequisites));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        departmentId,
        code,
        title,
        description,
        credits,
        level,
        semester,
        academicYear,
        maxEnrollment,
        currentEnrollment,
        enrollmentStartDate,
        enrollmentEndDate,
        courseStartDate,
        courseEndDate,
        const DeepCollectionEquality().hash(prerequisites),
        isActive,
        createdAt,
        updatedAt,
        department,
        const DeepCollectionEquality().hash(lecturers),
        const DeepCollectionEquality().hash(students),
        const DeepCollectionEquality().hash(coursePrerequisites)
      ]);

  @override
  String toString() {
    return 'CourseModel(id: $id, departmentId: $departmentId, code: $code, title: $title, description: $description, credits: $credits, level: $level, semester: $semester, academicYear: $academicYear, maxEnrollment: $maxEnrollment, currentEnrollment: $currentEnrollment, enrollmentStartDate: $enrollmentStartDate, enrollmentEndDate: $enrollmentEndDate, courseStartDate: $courseStartDate, courseEndDate: $courseEndDate, prerequisites: $prerequisites, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, department: $department, lecturers: $lecturers, students: $students, coursePrerequisites: $coursePrerequisites)';
  }
}

/// @nodoc
abstract mixin class $CourseModelCopyWith<$Res> {
  factory $CourseModelCopyWith(
          CourseModel value, $Res Function(CourseModel) _then) =
      _$CourseModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String departmentId,
      String code,
      String title,
      String? description,
      int credits,
      int level,
      int semester,
      String academicYear,
      int maxEnrollment,
      int currentEnrollment,
      String? enrollmentStartDate,
      String? enrollmentEndDate,
      String? courseStartDate,
      String? courseEndDate,
      List<String> prerequisites,
      bool isActive,
      String createdAt,
      String updatedAt,
      DepartmentModel? department,
      List<Map<String, dynamic>> lecturers,
      List<StudentModel>? students,
      List<CoursePrerequisiteModel> coursePrerequisites});

  $DepartmentModelCopyWith<$Res>? get department;
}

/// @nodoc
class _$CourseModelCopyWithImpl<$Res> implements $CourseModelCopyWith<$Res> {
  _$CourseModelCopyWithImpl(this._self, this._then);

  final CourseModel _self;
  final $Res Function(CourseModel) _then;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? departmentId = null,
    Object? code = null,
    Object? title = null,
    Object? description = freezed,
    Object? credits = null,
    Object? level = null,
    Object? semester = null,
    Object? academicYear = null,
    Object? maxEnrollment = null,
    Object? currentEnrollment = null,
    Object? enrollmentStartDate = freezed,
    Object? enrollmentEndDate = freezed,
    Object? courseStartDate = freezed,
    Object? courseEndDate = freezed,
    Object? prerequisites = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? department = freezed,
    Object? lecturers = null,
    Object? students = freezed,
    Object? coursePrerequisites = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      departmentId: null == departmentId
          ? _self.departmentId
          : departmentId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      credits: null == credits
          ? _self.credits
          : credits // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      semester: null == semester
          ? _self.semester
          : semester // ignore: cast_nullable_to_non_nullable
              as int,
      academicYear: null == academicYear
          ? _self.academicYear
          : academicYear // ignore: cast_nullable_to_non_nullable
              as String,
      maxEnrollment: null == maxEnrollment
          ? _self.maxEnrollment
          : maxEnrollment // ignore: cast_nullable_to_non_nullable
              as int,
      currentEnrollment: null == currentEnrollment
          ? _self.currentEnrollment
          : currentEnrollment // ignore: cast_nullable_to_non_nullable
              as int,
      enrollmentStartDate: freezed == enrollmentStartDate
          ? _self.enrollmentStartDate
          : enrollmentStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      enrollmentEndDate: freezed == enrollmentEndDate
          ? _self.enrollmentEndDate
          : enrollmentEndDate // ignore: cast_nullable_to_non_nullable
              as String?,
      courseStartDate: freezed == courseStartDate
          ? _self.courseStartDate
          : courseStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      courseEndDate: freezed == courseEndDate
          ? _self.courseEndDate
          : courseEndDate // ignore: cast_nullable_to_non_nullable
              as String?,
      prerequisites: null == prerequisites
          ? _self.prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as DepartmentModel?,
      lecturers: null == lecturers
          ? _self.lecturers
          : lecturers // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      students: freezed == students
          ? _self.students
          : students // ignore: cast_nullable_to_non_nullable
              as List<StudentModel>?,
      coursePrerequisites: null == coursePrerequisites
          ? _self.coursePrerequisites
          : coursePrerequisites // ignore: cast_nullable_to_non_nullable
              as List<CoursePrerequisiteModel>,
    ));
  }

  /// Create a copy of CourseModel
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
class _CourseModel implements CourseModel {
  const _CourseModel(
      {required this.id,
      required this.departmentId,
      required this.code,
      required this.title,
      this.description,
      this.credits = 3,
      required this.level,
      required this.semester,
      required this.academicYear,
      this.maxEnrollment = 100,
      this.currentEnrollment = 0,
      this.enrollmentStartDate,
      this.enrollmentEndDate,
      this.courseStartDate,
      this.courseEndDate,
      final List<String> prerequisites = const [],
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt,
      this.department,
      final List<Map<String, dynamic>> lecturers = const [],
      final List<StudentModel>? students,
      final List<CoursePrerequisiteModel> coursePrerequisites = const []})
      : _prerequisites = prerequisites,
        _lecturers = lecturers,
        _students = students,
        _coursePrerequisites = coursePrerequisites;
  factory _CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  @override
  final String id;
  @override
  final String departmentId;
  @override
  final String code;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey()
  final int credits;
  @override
  final int level;
  @override
  final int semester;
  @override
  final String academicYear;
  @override
  @JsonKey()
  final int maxEnrollment;
  @override
  @JsonKey()
  final int currentEnrollment;
  @override
  final String? enrollmentStartDate;
  @override
  final String? enrollmentEndDate;
  @override
  final String? courseStartDate;
  @override
  final String? courseEndDate;
  final List<String> _prerequisites;
  @override
  @JsonKey()
  List<String> get prerequisites {
    if (_prerequisites is EqualUnmodifiableListView) return _prerequisites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prerequisites);
  }

  @override
  @JsonKey()
  final bool isActive;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final DepartmentModel? department;
  final List<Map<String, dynamic>> _lecturers;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get lecturers {
    if (_lecturers is EqualUnmodifiableListView) return _lecturers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lecturers);
  }

  final List<StudentModel>? _students;
  @override
  List<StudentModel>? get students {
    final value = _students;
    if (value == null) return null;
    if (_students is EqualUnmodifiableListView) return _students;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<CoursePrerequisiteModel> _coursePrerequisites;
  @override
  @JsonKey()
  List<CoursePrerequisiteModel> get coursePrerequisites {
    if (_coursePrerequisites is EqualUnmodifiableListView)
      return _coursePrerequisites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coursePrerequisites);
  }

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CourseModelCopyWith<_CourseModel> get copyWith =>
      __$CourseModelCopyWithImpl<_CourseModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CourseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CourseModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.credits, credits) || other.credits == credits) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.semester, semester) ||
                other.semester == semester) &&
            (identical(other.academicYear, academicYear) ||
                other.academicYear == academicYear) &&
            (identical(other.maxEnrollment, maxEnrollment) ||
                other.maxEnrollment == maxEnrollment) &&
            (identical(other.currentEnrollment, currentEnrollment) ||
                other.currentEnrollment == currentEnrollment) &&
            (identical(other.enrollmentStartDate, enrollmentStartDate) ||
                other.enrollmentStartDate == enrollmentStartDate) &&
            (identical(other.enrollmentEndDate, enrollmentEndDate) ||
                other.enrollmentEndDate == enrollmentEndDate) &&
            (identical(other.courseStartDate, courseStartDate) ||
                other.courseStartDate == courseStartDate) &&
            (identical(other.courseEndDate, courseEndDate) ||
                other.courseEndDate == courseEndDate) &&
            const DeepCollectionEquality()
                .equals(other._prerequisites, _prerequisites) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.department, department) ||
                other.department == department) &&
            const DeepCollectionEquality()
                .equals(other._lecturers, _lecturers) &&
            const DeepCollectionEquality().equals(other._students, _students) &&
            const DeepCollectionEquality()
                .equals(other._coursePrerequisites, _coursePrerequisites));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        departmentId,
        code,
        title,
        description,
        credits,
        level,
        semester,
        academicYear,
        maxEnrollment,
        currentEnrollment,
        enrollmentStartDate,
        enrollmentEndDate,
        courseStartDate,
        courseEndDate,
        const DeepCollectionEquality().hash(_prerequisites),
        isActive,
        createdAt,
        updatedAt,
        department,
        const DeepCollectionEquality().hash(_lecturers),
        const DeepCollectionEquality().hash(_students),
        const DeepCollectionEquality().hash(_coursePrerequisites)
      ]);

  @override
  String toString() {
    return 'CourseModel(id: $id, departmentId: $departmentId, code: $code, title: $title, description: $description, credits: $credits, level: $level, semester: $semester, academicYear: $academicYear, maxEnrollment: $maxEnrollment, currentEnrollment: $currentEnrollment, enrollmentStartDate: $enrollmentStartDate, enrollmentEndDate: $enrollmentEndDate, courseStartDate: $courseStartDate, courseEndDate: $courseEndDate, prerequisites: $prerequisites, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, department: $department, lecturers: $lecturers, students: $students, coursePrerequisites: $coursePrerequisites)';
  }
}

/// @nodoc
abstract mixin class _$CourseModelCopyWith<$Res>
    implements $CourseModelCopyWith<$Res> {
  factory _$CourseModelCopyWith(
          _CourseModel value, $Res Function(_CourseModel) _then) =
      __$CourseModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String departmentId,
      String code,
      String title,
      String? description,
      int credits,
      int level,
      int semester,
      String academicYear,
      int maxEnrollment,
      int currentEnrollment,
      String? enrollmentStartDate,
      String? enrollmentEndDate,
      String? courseStartDate,
      String? courseEndDate,
      List<String> prerequisites,
      bool isActive,
      String createdAt,
      String updatedAt,
      DepartmentModel? department,
      List<Map<String, dynamic>> lecturers,
      List<StudentModel>? students,
      List<CoursePrerequisiteModel> coursePrerequisites});

  @override
  $DepartmentModelCopyWith<$Res>? get department;
}

/// @nodoc
class __$CourseModelCopyWithImpl<$Res> implements _$CourseModelCopyWith<$Res> {
  __$CourseModelCopyWithImpl(this._self, this._then);

  final _CourseModel _self;
  final $Res Function(_CourseModel) _then;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? departmentId = null,
    Object? code = null,
    Object? title = null,
    Object? description = freezed,
    Object? credits = null,
    Object? level = null,
    Object? semester = null,
    Object? academicYear = null,
    Object? maxEnrollment = null,
    Object? currentEnrollment = null,
    Object? enrollmentStartDate = freezed,
    Object? enrollmentEndDate = freezed,
    Object? courseStartDate = freezed,
    Object? courseEndDate = freezed,
    Object? prerequisites = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? department = freezed,
    Object? lecturers = null,
    Object? students = freezed,
    Object? coursePrerequisites = null,
  }) {
    return _then(_CourseModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      departmentId: null == departmentId
          ? _self.departmentId
          : departmentId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      credits: null == credits
          ? _self.credits
          : credits // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      semester: null == semester
          ? _self.semester
          : semester // ignore: cast_nullable_to_non_nullable
              as int,
      academicYear: null == academicYear
          ? _self.academicYear
          : academicYear // ignore: cast_nullable_to_non_nullable
              as String,
      maxEnrollment: null == maxEnrollment
          ? _self.maxEnrollment
          : maxEnrollment // ignore: cast_nullable_to_non_nullable
              as int,
      currentEnrollment: null == currentEnrollment
          ? _self.currentEnrollment
          : currentEnrollment // ignore: cast_nullable_to_non_nullable
              as int,
      enrollmentStartDate: freezed == enrollmentStartDate
          ? _self.enrollmentStartDate
          : enrollmentStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      enrollmentEndDate: freezed == enrollmentEndDate
          ? _self.enrollmentEndDate
          : enrollmentEndDate // ignore: cast_nullable_to_non_nullable
              as String?,
      courseStartDate: freezed == courseStartDate
          ? _self.courseStartDate
          : courseStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      courseEndDate: freezed == courseEndDate
          ? _self.courseEndDate
          : courseEndDate // ignore: cast_nullable_to_non_nullable
              as String?,
      prerequisites: null == prerequisites
          ? _self._prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as DepartmentModel?,
      lecturers: null == lecturers
          ? _self._lecturers
          : lecturers // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      students: freezed == students
          ? _self._students
          : students // ignore: cast_nullable_to_non_nullable
              as List<StudentModel>?,
      coursePrerequisites: null == coursePrerequisites
          ? _self._coursePrerequisites
          : coursePrerequisites // ignore: cast_nullable_to_non_nullable
              as List<CoursePrerequisiteModel>,
    ));
  }

  /// Create a copy of CourseModel
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
mixin _$CoursePrerequisiteModel {
  String get id;
  String get courseId;
  String get prerequisiteCourseId;
  bool get isMandatory;
  String get minimumGrade;
  String get createdAt;
  CourseModel? get course;
  CourseModel? get prerequisiteCourse;

  /// Create a copy of CoursePrerequisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CoursePrerequisiteModelCopyWith<CoursePrerequisiteModel> get copyWith =>
      _$CoursePrerequisiteModelCopyWithImpl<CoursePrerequisiteModel>(
          this as CoursePrerequisiteModel, _$identity);

  /// Serializes this CoursePrerequisiteModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CoursePrerequisiteModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.prerequisiteCourseId, prerequisiteCourseId) ||
                other.prerequisiteCourseId == prerequisiteCourseId) &&
            (identical(other.isMandatory, isMandatory) ||
                other.isMandatory == isMandatory) &&
            (identical(other.minimumGrade, minimumGrade) ||
                other.minimumGrade == minimumGrade) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.prerequisiteCourse, prerequisiteCourse) ||
                other.prerequisiteCourse == prerequisiteCourse));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      courseId,
      prerequisiteCourseId,
      isMandatory,
      minimumGrade,
      createdAt,
      course,
      prerequisiteCourse);

  @override
  String toString() {
    return 'CoursePrerequisiteModel(id: $id, courseId: $courseId, prerequisiteCourseId: $prerequisiteCourseId, isMandatory: $isMandatory, minimumGrade: $minimumGrade, createdAt: $createdAt, course: $course, prerequisiteCourse: $prerequisiteCourse)';
  }
}

/// @nodoc
abstract mixin class $CoursePrerequisiteModelCopyWith<$Res> {
  factory $CoursePrerequisiteModelCopyWith(CoursePrerequisiteModel value,
          $Res Function(CoursePrerequisiteModel) _then) =
      _$CoursePrerequisiteModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String courseId,
      String prerequisiteCourseId,
      bool isMandatory,
      String minimumGrade,
      String createdAt,
      CourseModel? course,
      CourseModel? prerequisiteCourse});

  $CourseModelCopyWith<$Res>? get course;
  $CourseModelCopyWith<$Res>? get prerequisiteCourse;
}

/// @nodoc
class _$CoursePrerequisiteModelCopyWithImpl<$Res>
    implements $CoursePrerequisiteModelCopyWith<$Res> {
  _$CoursePrerequisiteModelCopyWithImpl(this._self, this._then);

  final CoursePrerequisiteModel _self;
  final $Res Function(CoursePrerequisiteModel) _then;

  /// Create a copy of CoursePrerequisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? prerequisiteCourseId = null,
    Object? isMandatory = null,
    Object? minimumGrade = null,
    Object? createdAt = null,
    Object? course = freezed,
    Object? prerequisiteCourse = freezed,
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
      prerequisiteCourseId: null == prerequisiteCourseId
          ? _self.prerequisiteCourseId
          : prerequisiteCourseId // ignore: cast_nullable_to_non_nullable
              as String,
      isMandatory: null == isMandatory
          ? _self.isMandatory
          : isMandatory // ignore: cast_nullable_to_non_nullable
              as bool,
      minimumGrade: null == minimumGrade
          ? _self.minimumGrade
          : minimumGrade // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      course: freezed == course
          ? _self.course
          : course // ignore: cast_nullable_to_non_nullable
              as CourseModel?,
      prerequisiteCourse: freezed == prerequisiteCourse
          ? _self.prerequisiteCourse
          : prerequisiteCourse // ignore: cast_nullable_to_non_nullable
              as CourseModel?,
    ));
  }

  /// Create a copy of CoursePrerequisiteModel
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

  /// Create a copy of CoursePrerequisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CourseModelCopyWith<$Res>? get prerequisiteCourse {
    if (_self.prerequisiteCourse == null) {
      return null;
    }

    return $CourseModelCopyWith<$Res>(_self.prerequisiteCourse!, (value) {
      return _then(_self.copyWith(prerequisiteCourse: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _CoursePrerequisiteModel implements CoursePrerequisiteModel {
  const _CoursePrerequisiteModel(
      {required this.id,
      required this.courseId,
      required this.prerequisiteCourseId,
      this.isMandatory = true,
      this.minimumGrade = 'D',
      required this.createdAt,
      this.course,
      this.prerequisiteCourse});
  factory _CoursePrerequisiteModel.fromJson(Map<String, dynamic> json) =>
      _$CoursePrerequisiteModelFromJson(json);

  @override
  final String id;
  @override
  final String courseId;
  @override
  final String prerequisiteCourseId;
  @override
  @JsonKey()
  final bool isMandatory;
  @override
  @JsonKey()
  final String minimumGrade;
  @override
  final String createdAt;
  @override
  final CourseModel? course;
  @override
  final CourseModel? prerequisiteCourse;

  /// Create a copy of CoursePrerequisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CoursePrerequisiteModelCopyWith<_CoursePrerequisiteModel> get copyWith =>
      __$CoursePrerequisiteModelCopyWithImpl<_CoursePrerequisiteModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CoursePrerequisiteModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CoursePrerequisiteModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.prerequisiteCourseId, prerequisiteCourseId) ||
                other.prerequisiteCourseId == prerequisiteCourseId) &&
            (identical(other.isMandatory, isMandatory) ||
                other.isMandatory == isMandatory) &&
            (identical(other.minimumGrade, minimumGrade) ||
                other.minimumGrade == minimumGrade) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.prerequisiteCourse, prerequisiteCourse) ||
                other.prerequisiteCourse == prerequisiteCourse));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      courseId,
      prerequisiteCourseId,
      isMandatory,
      minimumGrade,
      createdAt,
      course,
      prerequisiteCourse);

  @override
  String toString() {
    return 'CoursePrerequisiteModel(id: $id, courseId: $courseId, prerequisiteCourseId: $prerequisiteCourseId, isMandatory: $isMandatory, minimumGrade: $minimumGrade, createdAt: $createdAt, course: $course, prerequisiteCourse: $prerequisiteCourse)';
  }
}

/// @nodoc
abstract mixin class _$CoursePrerequisiteModelCopyWith<$Res>
    implements $CoursePrerequisiteModelCopyWith<$Res> {
  factory _$CoursePrerequisiteModelCopyWith(_CoursePrerequisiteModel value,
          $Res Function(_CoursePrerequisiteModel) _then) =
      __$CoursePrerequisiteModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String courseId,
      String prerequisiteCourseId,
      bool isMandatory,
      String minimumGrade,
      String createdAt,
      CourseModel? course,
      CourseModel? prerequisiteCourse});

  @override
  $CourseModelCopyWith<$Res>? get course;
  @override
  $CourseModelCopyWith<$Res>? get prerequisiteCourse;
}

/// @nodoc
class __$CoursePrerequisiteModelCopyWithImpl<$Res>
    implements _$CoursePrerequisiteModelCopyWith<$Res> {
  __$CoursePrerequisiteModelCopyWithImpl(this._self, this._then);

  final _CoursePrerequisiteModel _self;
  final $Res Function(_CoursePrerequisiteModel) _then;

  /// Create a copy of CoursePrerequisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? prerequisiteCourseId = null,
    Object? isMandatory = null,
    Object? minimumGrade = null,
    Object? createdAt = null,
    Object? course = freezed,
    Object? prerequisiteCourse = freezed,
  }) {
    return _then(_CoursePrerequisiteModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      courseId: null == courseId
          ? _self.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String,
      prerequisiteCourseId: null == prerequisiteCourseId
          ? _self.prerequisiteCourseId
          : prerequisiteCourseId // ignore: cast_nullable_to_non_nullable
              as String,
      isMandatory: null == isMandatory
          ? _self.isMandatory
          : isMandatory // ignore: cast_nullable_to_non_nullable
              as bool,
      minimumGrade: null == minimumGrade
          ? _self.minimumGrade
          : minimumGrade // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      course: freezed == course
          ? _self.course
          : course // ignore: cast_nullable_to_non_nullable
              as CourseModel?,
      prerequisiteCourse: freezed == prerequisiteCourse
          ? _self.prerequisiteCourse
          : prerequisiteCourse // ignore: cast_nullable_to_non_nullable
              as CourseModel?,
    ));
  }

  /// Create a copy of CoursePrerequisiteModel
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

  /// Create a copy of CoursePrerequisiteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CourseModelCopyWith<$Res>? get prerequisiteCourse {
    if (_self.prerequisiteCourse == null) {
      return null;
    }

    return $CourseModelCopyWith<$Res>(_self.prerequisiteCourse!, (value) {
      return _then(_self.copyWith(prerequisiteCourse: value));
    });
  }
}

/// @nodoc
mixin _$CourseAssignmentModel {
  String get id;
  String get courseId;
  String get lecturerId;
  bool get isPrimary;
  String get role;
  String get assignedAt;
  CourseModel? get course;
  LecturerModel? get lecturer;

  /// Create a copy of CourseAssignmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CourseAssignmentModelCopyWith<CourseAssignmentModel> get copyWith =>
      _$CourseAssignmentModelCopyWithImpl<CourseAssignmentModel>(
          this as CourseAssignmentModel, _$identity);

  /// Serializes this CourseAssignmentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CourseAssignmentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.lecturerId, lecturerId) ||
                other.lecturerId == lecturerId) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.lecturer, lecturer) ||
                other.lecturer == lecturer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, courseId, lecturerId,
      isPrimary, role, assignedAt, course, lecturer);

  @override
  String toString() {
    return 'CourseAssignmentModel(id: $id, courseId: $courseId, lecturerId: $lecturerId, isPrimary: $isPrimary, role: $role, assignedAt: $assignedAt, course: $course, lecturer: $lecturer)';
  }
}

/// @nodoc
abstract mixin class $CourseAssignmentModelCopyWith<$Res> {
  factory $CourseAssignmentModelCopyWith(CourseAssignmentModel value,
          $Res Function(CourseAssignmentModel) _then) =
      _$CourseAssignmentModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String courseId,
      String lecturerId,
      bool isPrimary,
      String role,
      String assignedAt,
      CourseModel? course,
      LecturerModel? lecturer});

  $CourseModelCopyWith<$Res>? get course;
  $LecturerModelCopyWith<$Res>? get lecturer;
}

/// @nodoc
class _$CourseAssignmentModelCopyWithImpl<$Res>
    implements $CourseAssignmentModelCopyWith<$Res> {
  _$CourseAssignmentModelCopyWithImpl(this._self, this._then);

  final CourseAssignmentModel _self;
  final $Res Function(CourseAssignmentModel) _then;

  /// Create a copy of CourseAssignmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? lecturerId = null,
    Object? isPrimary = null,
    Object? role = null,
    Object? assignedAt = null,
    Object? course = freezed,
    Object? lecturer = freezed,
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
      isPrimary: null == isPrimary
          ? _self.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      assignedAt: null == assignedAt
          ? _self.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as String,
      course: freezed == course
          ? _self.course
          : course // ignore: cast_nullable_to_non_nullable
              as CourseModel?,
      lecturer: freezed == lecturer
          ? _self.lecturer
          : lecturer // ignore: cast_nullable_to_non_nullable
              as LecturerModel?,
    ));
  }

  /// Create a copy of CourseAssignmentModel
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

  /// Create a copy of CourseAssignmentModel
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
class _CourseAssignmentModel implements CourseAssignmentModel {
  const _CourseAssignmentModel(
      {required this.id,
      required this.courseId,
      required this.lecturerId,
      this.isPrimary = false,
      this.role = 'instructor',
      required this.assignedAt,
      this.course,
      this.lecturer});
  factory _CourseAssignmentModel.fromJson(Map<String, dynamic> json) =>
      _$CourseAssignmentModelFromJson(json);

  @override
  final String id;
  @override
  final String courseId;
  @override
  final String lecturerId;
  @override
  @JsonKey()
  final bool isPrimary;
  @override
  @JsonKey()
  final String role;
  @override
  final String assignedAt;
  @override
  final CourseModel? course;
  @override
  final LecturerModel? lecturer;

  /// Create a copy of CourseAssignmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CourseAssignmentModelCopyWith<_CourseAssignmentModel> get copyWith =>
      __$CourseAssignmentModelCopyWithImpl<_CourseAssignmentModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CourseAssignmentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CourseAssignmentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.lecturerId, lecturerId) ||
                other.lecturerId == lecturerId) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.lecturer, lecturer) ||
                other.lecturer == lecturer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, courseId, lecturerId,
      isPrimary, role, assignedAt, course, lecturer);

  @override
  String toString() {
    return 'CourseAssignmentModel(id: $id, courseId: $courseId, lecturerId: $lecturerId, isPrimary: $isPrimary, role: $role, assignedAt: $assignedAt, course: $course, lecturer: $lecturer)';
  }
}

/// @nodoc
abstract mixin class _$CourseAssignmentModelCopyWith<$Res>
    implements $CourseAssignmentModelCopyWith<$Res> {
  factory _$CourseAssignmentModelCopyWith(_CourseAssignmentModel value,
          $Res Function(_CourseAssignmentModel) _then) =
      __$CourseAssignmentModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String courseId,
      String lecturerId,
      bool isPrimary,
      String role,
      String assignedAt,
      CourseModel? course,
      LecturerModel? lecturer});

  @override
  $CourseModelCopyWith<$Res>? get course;
  @override
  $LecturerModelCopyWith<$Res>? get lecturer;
}

/// @nodoc
class __$CourseAssignmentModelCopyWithImpl<$Res>
    implements _$CourseAssignmentModelCopyWith<$Res> {
  __$CourseAssignmentModelCopyWithImpl(this._self, this._then);

  final _CourseAssignmentModel _self;
  final $Res Function(_CourseAssignmentModel) _then;

  /// Create a copy of CourseAssignmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? lecturerId = null,
    Object? isPrimary = null,
    Object? role = null,
    Object? assignedAt = null,
    Object? course = freezed,
    Object? lecturer = freezed,
  }) {
    return _then(_CourseAssignmentModel(
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
      isPrimary: null == isPrimary
          ? _self.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      assignedAt: null == assignedAt
          ? _self.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as String,
      course: freezed == course
          ? _self.course
          : course // ignore: cast_nullable_to_non_nullable
              as CourseModel?,
      lecturer: freezed == lecturer
          ? _self.lecturer
          : lecturer // ignore: cast_nullable_to_non_nullable
              as LecturerModel?,
    ));
  }

  /// Create a copy of CourseAssignmentModel
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

  /// Create a copy of CourseAssignmentModel
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
mixin _$CourseEnrollmentModel {
  String get id;
  String get courseId;
  String get studentId;
  EnrollmentStatus get status;
  String get enrolledAt;
  String? get droppedAt;
  String? get grade;
  double? get gradePoints;
  bool get isActive;
  String get createdAt;
  String get updatedAt;
  CourseModel? get course;
  StudentModel? get student;

  /// Create a copy of CourseEnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CourseEnrollmentModelCopyWith<CourseEnrollmentModel> get copyWith =>
      _$CourseEnrollmentModelCopyWithImpl<CourseEnrollmentModel>(
          this as CourseEnrollmentModel, _$identity);

  /// Serializes this CourseEnrollmentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CourseEnrollmentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.enrolledAt, enrolledAt) ||
                other.enrolledAt == enrolledAt) &&
            (identical(other.droppedAt, droppedAt) ||
                other.droppedAt == droppedAt) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.gradePoints, gradePoints) ||
                other.gradePoints == gradePoints) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.student, student) || other.student == student));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      courseId,
      studentId,
      status,
      enrolledAt,
      droppedAt,
      grade,
      gradePoints,
      isActive,
      createdAt,
      updatedAt,
      course,
      student);

  @override
  String toString() {
    return 'CourseEnrollmentModel(id: $id, courseId: $courseId, studentId: $studentId, status: $status, enrolledAt: $enrolledAt, droppedAt: $droppedAt, grade: $grade, gradePoints: $gradePoints, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, course: $course, student: $student)';
  }
}

/// @nodoc
abstract mixin class $CourseEnrollmentModelCopyWith<$Res> {
  factory $CourseEnrollmentModelCopyWith(CourseEnrollmentModel value,
          $Res Function(CourseEnrollmentModel) _then) =
      _$CourseEnrollmentModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String courseId,
      String studentId,
      EnrollmentStatus status,
      String enrolledAt,
      String? droppedAt,
      String? grade,
      double? gradePoints,
      bool isActive,
      String createdAt,
      String updatedAt,
      CourseModel? course,
      StudentModel? student});

  $CourseModelCopyWith<$Res>? get course;
  $StudentModelCopyWith<$Res>? get student;
}

/// @nodoc
class _$CourseEnrollmentModelCopyWithImpl<$Res>
    implements $CourseEnrollmentModelCopyWith<$Res> {
  _$CourseEnrollmentModelCopyWithImpl(this._self, this._then);

  final CourseEnrollmentModel _self;
  final $Res Function(CourseEnrollmentModel) _then;

  /// Create a copy of CourseEnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? studentId = null,
    Object? status = null,
    Object? enrolledAt = null,
    Object? droppedAt = freezed,
    Object? grade = freezed,
    Object? gradePoints = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? course = freezed,
    Object? student = freezed,
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
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as EnrollmentStatus,
      enrolledAt: null == enrolledAt
          ? _self.enrolledAt
          : enrolledAt // ignore: cast_nullable_to_non_nullable
              as String,
      droppedAt: freezed == droppedAt
          ? _self.droppedAt
          : droppedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: freezed == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
      gradePoints: freezed == gradePoints
          ? _self.gradePoints
          : gradePoints // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      course: freezed == course
          ? _self.course
          : course // ignore: cast_nullable_to_non_nullable
              as CourseModel?,
      student: freezed == student
          ? _self.student
          : student // ignore: cast_nullable_to_non_nullable
              as StudentModel?,
    ));
  }

  /// Create a copy of CourseEnrollmentModel
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

  /// Create a copy of CourseEnrollmentModel
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
class _CourseEnrollmentModel implements CourseEnrollmentModel {
  const _CourseEnrollmentModel(
      {required this.id,
      required this.courseId,
      required this.studentId,
      this.status = EnrollmentStatus.active,
      required this.enrolledAt,
      this.droppedAt,
      this.grade,
      this.gradePoints,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt,
      this.course,
      this.student});
  factory _CourseEnrollmentModel.fromJson(Map<String, dynamic> json) =>
      _$CourseEnrollmentModelFromJson(json);

  @override
  final String id;
  @override
  final String courseId;
  @override
  final String studentId;
  @override
  @JsonKey()
  final EnrollmentStatus status;
  @override
  final String enrolledAt;
  @override
  final String? droppedAt;
  @override
  final String? grade;
  @override
  final double? gradePoints;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final CourseModel? course;
  @override
  final StudentModel? student;

  /// Create a copy of CourseEnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CourseEnrollmentModelCopyWith<_CourseEnrollmentModel> get copyWith =>
      __$CourseEnrollmentModelCopyWithImpl<_CourseEnrollmentModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CourseEnrollmentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CourseEnrollmentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.enrolledAt, enrolledAt) ||
                other.enrolledAt == enrolledAt) &&
            (identical(other.droppedAt, droppedAt) ||
                other.droppedAt == droppedAt) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.gradePoints, gradePoints) ||
                other.gradePoints == gradePoints) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.student, student) || other.student == student));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      courseId,
      studentId,
      status,
      enrolledAt,
      droppedAt,
      grade,
      gradePoints,
      isActive,
      createdAt,
      updatedAt,
      course,
      student);

  @override
  String toString() {
    return 'CourseEnrollmentModel(id: $id, courseId: $courseId, studentId: $studentId, status: $status, enrolledAt: $enrolledAt, droppedAt: $droppedAt, grade: $grade, gradePoints: $gradePoints, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, course: $course, student: $student)';
  }
}

/// @nodoc
abstract mixin class _$CourseEnrollmentModelCopyWith<$Res>
    implements $CourseEnrollmentModelCopyWith<$Res> {
  factory _$CourseEnrollmentModelCopyWith(_CourseEnrollmentModel value,
          $Res Function(_CourseEnrollmentModel) _then) =
      __$CourseEnrollmentModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String courseId,
      String studentId,
      EnrollmentStatus status,
      String enrolledAt,
      String? droppedAt,
      String? grade,
      double? gradePoints,
      bool isActive,
      String createdAt,
      String updatedAt,
      CourseModel? course,
      StudentModel? student});

  @override
  $CourseModelCopyWith<$Res>? get course;
  @override
  $StudentModelCopyWith<$Res>? get student;
}

/// @nodoc
class __$CourseEnrollmentModelCopyWithImpl<$Res>
    implements _$CourseEnrollmentModelCopyWith<$Res> {
  __$CourseEnrollmentModelCopyWithImpl(this._self, this._then);

  final _CourseEnrollmentModel _self;
  final $Res Function(_CourseEnrollmentModel) _then;

  /// Create a copy of CourseEnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? studentId = null,
    Object? status = null,
    Object? enrolledAt = null,
    Object? droppedAt = freezed,
    Object? grade = freezed,
    Object? gradePoints = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? course = freezed,
    Object? student = freezed,
  }) {
    return _then(_CourseEnrollmentModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      courseId: null == courseId
          ? _self.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as EnrollmentStatus,
      enrolledAt: null == enrolledAt
          ? _self.enrolledAt
          : enrolledAt // ignore: cast_nullable_to_non_nullable
              as String,
      droppedAt: freezed == droppedAt
          ? _self.droppedAt
          : droppedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: freezed == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
      gradePoints: freezed == gradePoints
          ? _self.gradePoints
          : gradePoints // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      course: freezed == course
          ? _self.course
          : course // ignore: cast_nullable_to_non_nullable
              as CourseModel?,
      student: freezed == student
          ? _self.student
          : student // ignore: cast_nullable_to_non_nullable
              as StudentModel?,
    ));
  }

  /// Create a copy of CourseEnrollmentModel
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

  /// Create a copy of CourseEnrollmentModel
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
mixin _$EnrollmentHistoryModel {
  String get id;
  String get enrollmentId;
  String get studentId;
  String get courseId;
  String get action;
  String? get reason;
  String? get performedBy;
  String get performedAt;
  EnrollmentStatus? get oldStatus;
  EnrollmentStatus? get newStatus;

  /// Create a copy of EnrollmentHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EnrollmentHistoryModelCopyWith<EnrollmentHistoryModel> get copyWith =>
      _$EnrollmentHistoryModelCopyWithImpl<EnrollmentHistoryModel>(
          this as EnrollmentHistoryModel, _$identity);

  /// Serializes this EnrollmentHistoryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnrollmentHistoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.enrollmentId, enrollmentId) ||
                other.enrollmentId == enrollmentId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.performedBy, performedBy) ||
                other.performedBy == performedBy) &&
            (identical(other.performedAt, performedAt) ||
                other.performedAt == performedAt) &&
            (identical(other.oldStatus, oldStatus) ||
                other.oldStatus == oldStatus) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, enrollmentId, studentId,
      courseId, action, reason, performedBy, performedAt, oldStatus, newStatus);

  @override
  String toString() {
    return 'EnrollmentHistoryModel(id: $id, enrollmentId: $enrollmentId, studentId: $studentId, courseId: $courseId, action: $action, reason: $reason, performedBy: $performedBy, performedAt: $performedAt, oldStatus: $oldStatus, newStatus: $newStatus)';
  }
}

/// @nodoc
abstract mixin class $EnrollmentHistoryModelCopyWith<$Res> {
  factory $EnrollmentHistoryModelCopyWith(EnrollmentHistoryModel value,
          $Res Function(EnrollmentHistoryModel) _then) =
      _$EnrollmentHistoryModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String enrollmentId,
      String studentId,
      String courseId,
      String action,
      String? reason,
      String? performedBy,
      String performedAt,
      EnrollmentStatus? oldStatus,
      EnrollmentStatus? newStatus});
}

/// @nodoc
class _$EnrollmentHistoryModelCopyWithImpl<$Res>
    implements $EnrollmentHistoryModelCopyWith<$Res> {
  _$EnrollmentHistoryModelCopyWithImpl(this._self, this._then);

  final EnrollmentHistoryModel _self;
  final $Res Function(EnrollmentHistoryModel) _then;

  /// Create a copy of EnrollmentHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? enrollmentId = null,
    Object? studentId = null,
    Object? courseId = null,
    Object? action = null,
    Object? reason = freezed,
    Object? performedBy = freezed,
    Object? performedAt = null,
    Object? oldStatus = freezed,
    Object? newStatus = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      enrollmentId: null == enrollmentId
          ? _self.enrollmentId
          : enrollmentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      courseId: null == courseId
          ? _self.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      performedBy: freezed == performedBy
          ? _self.performedBy
          : performedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      performedAt: null == performedAt
          ? _self.performedAt
          : performedAt // ignore: cast_nullable_to_non_nullable
              as String,
      oldStatus: freezed == oldStatus
          ? _self.oldStatus
          : oldStatus // ignore: cast_nullable_to_non_nullable
              as EnrollmentStatus?,
      newStatus: freezed == newStatus
          ? _self.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as EnrollmentStatus?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _EnrollmentHistoryModel implements EnrollmentHistoryModel {
  const _EnrollmentHistoryModel(
      {required this.id,
      required this.enrollmentId,
      required this.studentId,
      required this.courseId,
      required this.action,
      this.reason,
      this.performedBy,
      required this.performedAt,
      this.oldStatus,
      this.newStatus});
  factory _EnrollmentHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentHistoryModelFromJson(json);

  @override
  final String id;
  @override
  final String enrollmentId;
  @override
  final String studentId;
  @override
  final String courseId;
  @override
  final String action;
  @override
  final String? reason;
  @override
  final String? performedBy;
  @override
  final String performedAt;
  @override
  final EnrollmentStatus? oldStatus;
  @override
  final EnrollmentStatus? newStatus;

  /// Create a copy of EnrollmentHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EnrollmentHistoryModelCopyWith<_EnrollmentHistoryModel> get copyWith =>
      __$EnrollmentHistoryModelCopyWithImpl<_EnrollmentHistoryModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EnrollmentHistoryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EnrollmentHistoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.enrollmentId, enrollmentId) ||
                other.enrollmentId == enrollmentId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.performedBy, performedBy) ||
                other.performedBy == performedBy) &&
            (identical(other.performedAt, performedAt) ||
                other.performedAt == performedAt) &&
            (identical(other.oldStatus, oldStatus) ||
                other.oldStatus == oldStatus) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, enrollmentId, studentId,
      courseId, action, reason, performedBy, performedAt, oldStatus, newStatus);

  @override
  String toString() {
    return 'EnrollmentHistoryModel(id: $id, enrollmentId: $enrollmentId, studentId: $studentId, courseId: $courseId, action: $action, reason: $reason, performedBy: $performedBy, performedAt: $performedAt, oldStatus: $oldStatus, newStatus: $newStatus)';
  }
}

/// @nodoc
abstract mixin class _$EnrollmentHistoryModelCopyWith<$Res>
    implements $EnrollmentHistoryModelCopyWith<$Res> {
  factory _$EnrollmentHistoryModelCopyWith(_EnrollmentHistoryModel value,
          $Res Function(_EnrollmentHistoryModel) _then) =
      __$EnrollmentHistoryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String enrollmentId,
      String studentId,
      String courseId,
      String action,
      String? reason,
      String? performedBy,
      String performedAt,
      EnrollmentStatus? oldStatus,
      EnrollmentStatus? newStatus});
}

/// @nodoc
class __$EnrollmentHistoryModelCopyWithImpl<$Res>
    implements _$EnrollmentHistoryModelCopyWith<$Res> {
  __$EnrollmentHistoryModelCopyWithImpl(this._self, this._then);

  final _EnrollmentHistoryModel _self;
  final $Res Function(_EnrollmentHistoryModel) _then;

  /// Create a copy of EnrollmentHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? enrollmentId = null,
    Object? studentId = null,
    Object? courseId = null,
    Object? action = null,
    Object? reason = freezed,
    Object? performedBy = freezed,
    Object? performedAt = null,
    Object? oldStatus = freezed,
    Object? newStatus = freezed,
  }) {
    return _then(_EnrollmentHistoryModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      enrollmentId: null == enrollmentId
          ? _self.enrollmentId
          : enrollmentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      courseId: null == courseId
          ? _self.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      performedBy: freezed == performedBy
          ? _self.performedBy
          : performedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      performedAt: null == performedAt
          ? _self.performedAt
          : performedAt // ignore: cast_nullable_to_non_nullable
              as String,
      oldStatus: freezed == oldStatus
          ? _self.oldStatus
          : oldStatus // ignore: cast_nullable_to_non_nullable
              as EnrollmentStatus?,
      newStatus: freezed == newStatus
          ? _self.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as EnrollmentStatus?,
    ));
  }
}

/// @nodoc
mixin _$AcademicCalendarModel {
  String get id;
  String get academicYear;
  int get semester;
  String get eventType;
  String get eventName;
  String get eventDate;
  String? get description;
  bool get isActive;
  String get createdAt;

  /// Create a copy of AcademicCalendarModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AcademicCalendarModelCopyWith<AcademicCalendarModel> get copyWith =>
      _$AcademicCalendarModelCopyWithImpl<AcademicCalendarModel>(
          this as AcademicCalendarModel, _$identity);

  /// Serializes this AcademicCalendarModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AcademicCalendarModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.academicYear, academicYear) ||
                other.academicYear == academicYear) &&
            (identical(other.semester, semester) ||
                other.semester == semester) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, academicYear, semester,
      eventType, eventName, eventDate, description, isActive, createdAt);

  @override
  String toString() {
    return 'AcademicCalendarModel(id: $id, academicYear: $academicYear, semester: $semester, eventType: $eventType, eventName: $eventName, eventDate: $eventDate, description: $description, isActive: $isActive, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $AcademicCalendarModelCopyWith<$Res> {
  factory $AcademicCalendarModelCopyWith(AcademicCalendarModel value,
          $Res Function(AcademicCalendarModel) _then) =
      _$AcademicCalendarModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String academicYear,
      int semester,
      String eventType,
      String eventName,
      String eventDate,
      String? description,
      bool isActive,
      String createdAt});
}

/// @nodoc
class _$AcademicCalendarModelCopyWithImpl<$Res>
    implements $AcademicCalendarModelCopyWith<$Res> {
  _$AcademicCalendarModelCopyWithImpl(this._self, this._then);

  final AcademicCalendarModel _self;
  final $Res Function(AcademicCalendarModel) _then;

  /// Create a copy of AcademicCalendarModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? academicYear = null,
    Object? semester = null,
    Object? eventType = null,
    Object? eventName = null,
    Object? eventDate = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      academicYear: null == academicYear
          ? _self.academicYear
          : academicYear // ignore: cast_nullable_to_non_nullable
              as String,
      semester: null == semester
          ? _self.semester
          : semester // ignore: cast_nullable_to_non_nullable
              as int,
      eventType: null == eventType
          ? _self.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _self.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _self.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AcademicCalendarModel implements AcademicCalendarModel {
  const _AcademicCalendarModel(
      {required this.id,
      required this.academicYear,
      required this.semester,
      required this.eventType,
      required this.eventName,
      required this.eventDate,
      this.description,
      this.isActive = true,
      required this.createdAt});
  factory _AcademicCalendarModel.fromJson(Map<String, dynamic> json) =>
      _$AcademicCalendarModelFromJson(json);

  @override
  final String id;
  @override
  final String academicYear;
  @override
  final int semester;
  @override
  final String eventType;
  @override
  final String eventName;
  @override
  final String eventDate;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String createdAt;

  /// Create a copy of AcademicCalendarModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AcademicCalendarModelCopyWith<_AcademicCalendarModel> get copyWith =>
      __$AcademicCalendarModelCopyWithImpl<_AcademicCalendarModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AcademicCalendarModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AcademicCalendarModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.academicYear, academicYear) ||
                other.academicYear == academicYear) &&
            (identical(other.semester, semester) ||
                other.semester == semester) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, academicYear, semester,
      eventType, eventName, eventDate, description, isActive, createdAt);

  @override
  String toString() {
    return 'AcademicCalendarModel(id: $id, academicYear: $academicYear, semester: $semester, eventType: $eventType, eventName: $eventName, eventDate: $eventDate, description: $description, isActive: $isActive, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$AcademicCalendarModelCopyWith<$Res>
    implements $AcademicCalendarModelCopyWith<$Res> {
  factory _$AcademicCalendarModelCopyWith(_AcademicCalendarModel value,
          $Res Function(_AcademicCalendarModel) _then) =
      __$AcademicCalendarModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String academicYear,
      int semester,
      String eventType,
      String eventName,
      String eventDate,
      String? description,
      bool isActive,
      String createdAt});
}

/// @nodoc
class __$AcademicCalendarModelCopyWithImpl<$Res>
    implements _$AcademicCalendarModelCopyWith<$Res> {
  __$AcademicCalendarModelCopyWithImpl(this._self, this._then);

  final _AcademicCalendarModel _self;
  final $Res Function(_AcademicCalendarModel) _then;

  /// Create a copy of AcademicCalendarModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? academicYear = null,
    Object? semester = null,
    Object? eventType = null,
    Object? eventName = null,
    Object? eventDate = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_AcademicCalendarModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      academicYear: null == academicYear
          ? _self.academicYear
          : academicYear // ignore: cast_nullable_to_non_nullable
              as String,
      semester: null == semester
          ? _self.semester
          : semester // ignore: cast_nullable_to_non_nullable
              as int,
      eventType: null == eventType
          ? _self.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _self.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _self.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
