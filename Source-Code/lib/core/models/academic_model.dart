import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'academic_model.freezed.dart';
part 'academic_model.g.dart';

@freezed
abstract class FacultyModel with _$FacultyModel {
  const factory FacultyModel({
    required String id,
    required String name,
    required String code,
    String? description,
    @Default(true) bool isActive,
    required String createdAt,
    required String updatedAt,
  }) = _FacultyModel;

  factory FacultyModel.fromJson(Map<String, dynamic> json) =>
      _$FacultyModelFromJson(json);
}

@freezed
abstract class DepartmentModel with _$DepartmentModel {
  const factory DepartmentModel({
    required String id,
    required String facultyId,
    required String name,
    required String code,
    String? description,
    @Default(true) bool isActive,
    required String createdAt,
    required String updatedAt,
    FacultyModel? faculty,
  }) = _DepartmentModel;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);
}

@freezed
abstract class CourseModel with _$CourseModel {
  const factory CourseModel({
    required String id,
    required String departmentId,
    required String code,
    required String title,
    String? description,
    @Default(3) int credits,
    required int level,
    required int semester,
    required String academicYear,
    @Default(100) int maxEnrollment,
    @Default(0) int currentEnrollment,
    String? enrollmentStartDate,
    String? enrollmentEndDate,
    String? courseStartDate,
    String? courseEndDate,
    @Default([]) List<String> prerequisites,
    @Default(true) bool isActive,
    required String createdAt,
    required String updatedAt,
    DepartmentModel? department,
    @Default([]) List<Map<String, dynamic>> lecturers,
    List<StudentModel>? students,
    @Default([]) List<CoursePrerequisiteModel> coursePrerequisites,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}

@freezed
abstract class CoursePrerequisiteModel with _$CoursePrerequisiteModel {
  const factory CoursePrerequisiteModel({
    required String id,
    required String courseId,
    required String prerequisiteCourseId,
    @Default(true) bool isMandatory,
    @Default('D') String minimumGrade,
    required String createdAt,
    CourseModel? course,
    CourseModel? prerequisiteCourse,
  }) = _CoursePrerequisiteModel;

  factory CoursePrerequisiteModel.fromJson(Map<String, dynamic> json) =>
      _$CoursePrerequisiteModelFromJson(json);
}

@freezed
abstract class CourseAssignmentModel with _$CourseAssignmentModel {
  const factory CourseAssignmentModel({
    required String id,
    required String courseId,
    required String lecturerId,
    @Default(false) bool isPrimary,
    @Default('instructor') String role,
    required String assignedAt,
    CourseModel? course,
    LecturerModel? lecturer,
  }) = _CourseAssignmentModel;

  factory CourseAssignmentModel.fromJson(Map<String, dynamic> json) =>
      _$CourseAssignmentModelFromJson(json);
}

enum EnrollmentStatus { active, dropped, completed, suspended }

@freezed
abstract class CourseEnrollmentModel with _$CourseEnrollmentModel {
  const factory CourseEnrollmentModel({
    required String id,
    required String courseId,
    required String studentId,
    @Default(EnrollmentStatus.active) EnrollmentStatus status,
    required String enrolledAt,
    String? droppedAt,
    String? grade,
    double? gradePoints,
    @Default(true) bool isActive,
    required String createdAt,
    required String updatedAt,
    CourseModel? course,
    StudentModel? student,
  }) = _CourseEnrollmentModel;

  factory CourseEnrollmentModel.fromJson(Map<String, dynamic> json) =>
      _$CourseEnrollmentModelFromJson(json);
}

@freezed
abstract class EnrollmentHistoryModel with _$EnrollmentHistoryModel {
  const factory EnrollmentHistoryModel({
    required String id,
    required String enrollmentId,
    required String studentId,
    required String courseId,
    required String action,
    String? reason,
    String? performedBy,
    required String performedAt,
    EnrollmentStatus? oldStatus,
    EnrollmentStatus? newStatus,
  }) = _EnrollmentHistoryModel;

  factory EnrollmentHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentHistoryModelFromJson(json);
}

@freezed
abstract class AcademicCalendarModel with _$AcademicCalendarModel {
  const factory AcademicCalendarModel({
    required String id,
    required String academicYear,
    required int semester,
    required String eventType,
    required String eventName,
    required String eventDate,
    String? description,
    @Default(true) bool isActive,
    required String createdAt,
  }) = _AcademicCalendarModel;

  factory AcademicCalendarModel.fromJson(Map<String, dynamic> json) =>
      _$AcademicCalendarModelFromJson(json);
}