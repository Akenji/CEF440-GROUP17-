// user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'academic_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole {
  student,
  lecturer,
  admin
}

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String fullName,
    required UserRole role,
    String? avatarUrl,
    String? phone,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
abstract class StudentModel with _$StudentModel {
  const factory StudentModel({
    String? id,
    String? matricule,
    String? departmentId,
    int? level,
    int? admissionYear,
    int? graduationYear,
    @Default(1) int currentSemester,
    @Default('2024-2025') String currentAcademicYear,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? user,
    DepartmentModel? department,
  }) = _StudentModel;

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);
}

@freezed
abstract class LecturerModel with _$LecturerModel {
  const factory LecturerModel({
    required String id,
    required String employeeId,
    required String departmentId,
    String? title,
    String? specialization,
    DateTime? hireDate,
    String? officeLocation,
    String? officeHours,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    UserModel? user,
    DepartmentModel? department,
  }) = _LecturerModel;

  factory LecturerModel.fromJson(Map<String, dynamic> json) =>
      _$LecturerModelFromJson(json);
}

@freezed
abstract class AdminModel with _$AdminModel {
  const factory AdminModel({
    required String id,
    String? departmentId,
    @Default('department') String adminLevel,
    @Default({}) Map<String, dynamic> permissions,
    required DateTime createdAt,
    required DateTime updatedAt,
    UserModel? user,
    DepartmentModel? department,
  }) = _AdminModel;

  factory AdminModel.fromJson(Map<String, dynamic> json) =>
      _$AdminModelFromJson(json);
}