// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      avatarUrl: json['avatarUrl'] as String?,
      phone: json['phone'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'role': _$UserRoleEnumMap[instance.role]!,
      'avatarUrl': instance.avatarUrl,
      'phone': instance.phone,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.student: 'student',
  UserRole.lecturer: 'lecturer',
  UserRole.admin: 'admin',
};

_StudentModel _$StudentModelFromJson(Map<String, dynamic> json) =>
    _StudentModel(
      id: json['id'] as String?,
      matricule: json['matricule'] as String?,
      departmentId: json['departmentId'] as String?,
      level: (json['level'] as num?)?.toInt(),
      admissionYear: (json['admissionYear'] as num?)?.toInt(),
      graduationYear: (json['graduationYear'] as num?)?.toInt(),
      currentSemester: (json['currentSemester'] as num?)?.toInt() ?? 1,
      currentAcademicYear:
          json['currentAcademicYear'] as String? ?? '2024-2025',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      department: json['department'] == null
          ? null
          : DepartmentModel.fromJson(
              json['department'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StudentModelToJson(_StudentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matricule': instance.matricule,
      'departmentId': instance.departmentId,
      'level': instance.level,
      'admissionYear': instance.admissionYear,
      'graduationYear': instance.graduationYear,
      'currentSemester': instance.currentSemester,
      'currentAcademicYear': instance.currentAcademicYear,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'user': instance.user,
      'department': instance.department,
    };

_LecturerModel _$LecturerModelFromJson(Map<String, dynamic> json) =>
    _LecturerModel(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      departmentId: json['departmentId'] as String,
      title: json['title'] as String?,
      specialization: json['specialization'] as String?,
      hireDate: json['hireDate'] == null
          ? null
          : DateTime.parse(json['hireDate'] as String),
      officeLocation: json['officeLocation'] as String?,
      officeHours: json['officeHours'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      department: json['department'] == null
          ? null
          : DepartmentModel.fromJson(
              json['department'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LecturerModelToJson(_LecturerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'departmentId': instance.departmentId,
      'title': instance.title,
      'specialization': instance.specialization,
      'hireDate': instance.hireDate?.toIso8601String(),
      'officeLocation': instance.officeLocation,
      'officeHours': instance.officeHours,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'user': instance.user,
      'department': instance.department,
    };

_AdminModel _$AdminModelFromJson(Map<String, dynamic> json) => _AdminModel(
      id: json['id'] as String,
      departmentId: json['departmentId'] as String?,
      adminLevel: json['adminLevel'] as String? ?? 'department',
      permissions: json['permissions'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      department: json['department'] == null
          ? null
          : DepartmentModel.fromJson(
              json['department'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdminModelToJson(_AdminModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'departmentId': instance.departmentId,
      'adminLevel': instance.adminLevel,
      'permissions': instance.permissions,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'user': instance.user,
      'department': instance.department,
    };
