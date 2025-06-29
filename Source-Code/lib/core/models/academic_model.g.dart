// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FacultyModel _$FacultyModelFromJson(Map<String, dynamic> json) =>
    _FacultyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$FacultyModelToJson(_FacultyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'description': instance.description,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) =>
    _DepartmentModel(
      id: json['id'] as String,
      facultyId: json['facultyId'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      faculty: json['faculty'] == null
          ? null
          : FacultyModel.fromJson(json['faculty'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DepartmentModelToJson(_DepartmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'facultyId': instance.facultyId,
      'name': instance.name,
      'code': instance.code,
      'description': instance.description,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'faculty': instance.faculty,
    };

_CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => _CourseModel(
      id: json['id'] as String,
      departmentId: json['departmentId'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      credits: (json['credits'] as num?)?.toInt() ?? 3,
      level: (json['level'] as num).toInt(),
      semester: (json['semester'] as num).toInt(),
      academicYear: json['academicYear'] as String,
      maxEnrollment: (json['maxEnrollment'] as num?)?.toInt() ?? 100,
      currentEnrollment: (json['currentEnrollment'] as num?)?.toInt() ?? 0,
      enrollmentStartDate: json['enrollmentStartDate'] as String?,
      enrollmentEndDate: json['enrollmentEndDate'] as String?,
      courseStartDate: json['courseStartDate'] as String?,
      courseEndDate: json['courseEndDate'] as String?,
      prerequisites: (json['prerequisites'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      department: json['department'] == null
          ? null
          : DepartmentModel.fromJson(
              json['department'] as Map<String, dynamic>),
      lecturers: (json['lecturers'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      students: (json['students'] as List<dynamic>?)
          ?.map((e) => StudentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      coursePrerequisites: (json['coursePrerequisites'] as List<dynamic>?)
              ?.map((e) =>
                  CoursePrerequisiteModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CourseModelToJson(_CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'departmentId': instance.departmentId,
      'code': instance.code,
      'title': instance.title,
      'description': instance.description,
      'credits': instance.credits,
      'level': instance.level,
      'semester': instance.semester,
      'academicYear': instance.academicYear,
      'maxEnrollment': instance.maxEnrollment,
      'currentEnrollment': instance.currentEnrollment,
      'enrollmentStartDate': instance.enrollmentStartDate,
      'enrollmentEndDate': instance.enrollmentEndDate,
      'courseStartDate': instance.courseStartDate,
      'courseEndDate': instance.courseEndDate,
      'prerequisites': instance.prerequisites,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'department': instance.department,
      'lecturers': instance.lecturers,
      'students': instance.students,
      'coursePrerequisites': instance.coursePrerequisites,
    };

_CoursePrerequisiteModel _$CoursePrerequisiteModelFromJson(
        Map<String, dynamic> json) =>
    _CoursePrerequisiteModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      prerequisiteCourseId: json['prerequisiteCourseId'] as String,
      isMandatory: json['isMandatory'] as bool? ?? true,
      minimumGrade: json['minimumGrade'] as String? ?? 'D',
      createdAt: json['createdAt'] as String,
      course: json['course'] == null
          ? null
          : CourseModel.fromJson(json['course'] as Map<String, dynamic>),
      prerequisiteCourse: json['prerequisiteCourse'] == null
          ? null
          : CourseModel.fromJson(
              json['prerequisiteCourse'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CoursePrerequisiteModelToJson(
        _CoursePrerequisiteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'prerequisiteCourseId': instance.prerequisiteCourseId,
      'isMandatory': instance.isMandatory,
      'minimumGrade': instance.minimumGrade,
      'createdAt': instance.createdAt,
      'course': instance.course,
      'prerequisiteCourse': instance.prerequisiteCourse,
    };

_CourseAssignmentModel _$CourseAssignmentModelFromJson(
        Map<String, dynamic> json) =>
    _CourseAssignmentModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      lecturerId: json['lecturerId'] as String,
      isPrimary: json['isPrimary'] as bool? ?? false,
      role: json['role'] as String? ?? 'instructor',
      assignedAt: json['assignedAt'] as String,
      course: json['course'] == null
          ? null
          : CourseModel.fromJson(json['course'] as Map<String, dynamic>),
      lecturer: json['lecturer'] == null
          ? null
          : LecturerModel.fromJson(json['lecturer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseAssignmentModelToJson(
        _CourseAssignmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'lecturerId': instance.lecturerId,
      'isPrimary': instance.isPrimary,
      'role': instance.role,
      'assignedAt': instance.assignedAt,
      'course': instance.course,
      'lecturer': instance.lecturer,
    };

_CourseEnrollmentModel _$CourseEnrollmentModelFromJson(
        Map<String, dynamic> json) =>
    _CourseEnrollmentModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      studentId: json['studentId'] as String,
      status: $enumDecodeNullable(_$EnrollmentStatusEnumMap, json['status']) ??
          EnrollmentStatus.active,
      enrolledAt: json['enrolledAt'] as String,
      droppedAt: json['droppedAt'] as String?,
      grade: json['grade'] as String?,
      gradePoints: (json['gradePoints'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      course: json['course'] == null
          ? null
          : CourseModel.fromJson(json['course'] as Map<String, dynamic>),
      student: json['student'] == null
          ? null
          : StudentModel.fromJson(json['student'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseEnrollmentModelToJson(
        _CourseEnrollmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'studentId': instance.studentId,
      'status': _$EnrollmentStatusEnumMap[instance.status]!,
      'enrolledAt': instance.enrolledAt,
      'droppedAt': instance.droppedAt,
      'grade': instance.grade,
      'gradePoints': instance.gradePoints,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'course': instance.course,
      'student': instance.student,
    };

const _$EnrollmentStatusEnumMap = {
  EnrollmentStatus.active: 'active',
  EnrollmentStatus.dropped: 'dropped',
  EnrollmentStatus.completed: 'completed',
  EnrollmentStatus.suspended: 'suspended',
};

_EnrollmentHistoryModel _$EnrollmentHistoryModelFromJson(
        Map<String, dynamic> json) =>
    _EnrollmentHistoryModel(
      id: json['id'] as String,
      enrollmentId: json['enrollmentId'] as String,
      studentId: json['studentId'] as String,
      courseId: json['courseId'] as String,
      action: json['action'] as String,
      reason: json['reason'] as String?,
      performedBy: json['performedBy'] as String?,
      performedAt: json['performedAt'] as String,
      oldStatus:
          $enumDecodeNullable(_$EnrollmentStatusEnumMap, json['oldStatus']),
      newStatus:
          $enumDecodeNullable(_$EnrollmentStatusEnumMap, json['newStatus']),
    );

Map<String, dynamic> _$EnrollmentHistoryModelToJson(
        _EnrollmentHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'enrollmentId': instance.enrollmentId,
      'studentId': instance.studentId,
      'courseId': instance.courseId,
      'action': instance.action,
      'reason': instance.reason,
      'performedBy': instance.performedBy,
      'performedAt': instance.performedAt,
      'oldStatus': _$EnrollmentStatusEnumMap[instance.oldStatus],
      'newStatus': _$EnrollmentStatusEnumMap[instance.newStatus],
    };

_AcademicCalendarModel _$AcademicCalendarModelFromJson(
        Map<String, dynamic> json) =>
    _AcademicCalendarModel(
      id: json['id'] as String,
      academicYear: json['academicYear'] as String,
      semester: (json['semester'] as num).toInt(),
      eventType: json['eventType'] as String,
      eventName: json['eventName'] as String,
      eventDate: json['eventDate'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$AcademicCalendarModelToJson(
        _AcademicCalendarModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'academicYear': instance.academicYear,
      'semester': instance.semester,
      'eventType': instance.eventType,
      'eventName': instance.eventName,
      'eventDate': instance.eventDate,
      'description': instance.description,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
    };
