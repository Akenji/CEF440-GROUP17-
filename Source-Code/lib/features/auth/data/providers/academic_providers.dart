import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/models/academic_model.dart';

// Helper function to safely parse DateTime
DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is DateTime) return value;
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (e) {
      return DateTime.now();
    }
  }
  return DateTime.now();
}

// Helper function to convert snake_case to camelCase for models
Map<String, dynamic> _convertToModelFormat(Map<String, dynamic> dbData) {
  return {
    'id': dbData['id']?.toString() ?? '',
    'name': dbData['name']?.toString() ?? '',
    'code': dbData['code']?.toString() ?? '',
    'description': dbData['description'],
    'isActive': dbData['is_active'] ?? true, // Convert snake_case to camelCase
    'createdAt': dbData['created_at'],
    'updatedAt': dbData['updated_at'],
  };
}

// Faculties Provider - Fixed
final facultiesProvider = FutureProvider<List<FacultyModel>>((ref) async {
  try {
    final response = await SupabaseService.from('faculties')
        .select()
        .eq('is_active', true)
        .order('name');

    if (response == null || response.isEmpty) {
      return <FacultyModel>[];
    }

    return response.map<FacultyModel>((item) {
      final jsonMap = item as Map<String, dynamic>;
      final modelData = _convertToModelFormat(jsonMap);

      return FacultyModel.fromJson(modelData);
    }).toList();
  } on PostgrestException catch (e) {
    print('Supabase Error loading faculties: ${e.message}, Code: ${e.code}');
    throw Exception('Failed to load faculties: ${e.message}');
  } catch (e, stackTrace) {
    print('Unexpected Error loading faculties: $e\nStackTrace: $stackTrace');
    throw Exception('Failed to load faculties: $e');
  }
});

// Departments by Faculty Provider - Fixed
final departmentsProvider =
    FutureProvider.family<List<DepartmentModel>, String?>(
        (ref, facultyId) async {
  try {
    var query = SupabaseService.from('departments')
        .select('*, faculties!departments_faculty_id_fkey(*)')
        .eq('is_active', true);

    if (facultyId != null && facultyId.isNotEmpty) {
      query = query.eq('faculty_id', facultyId);
    }

    final response = await query.order('name');

    if (response == null || response.isEmpty) {
      return <DepartmentModel>[];
    }

    return response.map<DepartmentModel>((item) {
      final jsonMap = item as Map<String, dynamic>;
      final facultyData = jsonMap['faculties'] as Map<String, dynamic>?;

      // Convert department data
      final departmentJson = {
        'id': jsonMap['id']?.toString() ?? '',
        'facultyId': jsonMap['faculty_id']?.toString() ?? '', // Note: camelCase
        'name': jsonMap['name']?.toString() ?? '',
        'code': jsonMap['code']?.toString() ?? '',
        'description': jsonMap['description']?.toString(),
        'isActive': jsonMap['is_active'] ?? true,
        'createdAt': _parseDateTime(jsonMap['created_at']).toIso8601String(),
        'updatedAt': _parseDateTime(jsonMap['updated_at']).toIso8601String(),
      };

      // Add faculty data if available
      if (facultyData != null) {
        departmentJson['faculty'] = _convertToModelFormat(facultyData);
      }

      return DepartmentModel.fromJson(departmentJson);
    }).toList();
  } on PostgrestException catch (e) {
    print('Supabase Error loading departments: ${e.message}, Code: ${e.code}');
    throw Exception('Failed to load departments: ${e.message}');
  } catch (e, stackTrace) {
    print('Unexpected Error loading departments: $e\nStackTrace: $stackTrace');
    throw Exception('Failed to load departments: $e');
  }
});

// All Departments Provider - Fixed
final allDepartmentsProvider =
    FutureProvider<List<DepartmentModel>>((ref) async {
  try {
    final response = await SupabaseService.from('departments')
        .select('*, faculties!departments_faculty_id_fkey(*)')
        .eq('is_active', true)
        .order('name');

    if (response == null || response.isEmpty) {
      return <DepartmentModel>[];
    }

    return response.map<DepartmentModel>((item) {
      final jsonMap = item as Map<String, dynamic>;
      final facultyData = jsonMap['faculties'] as Map<String, dynamic>?;

      // Convert department data
      final departmentJson = {
        'id': jsonMap['id']?.toString() ?? '',
        'facultyId': jsonMap['faculty_id']?.toString() ?? '',
        'name': jsonMap['name']?.toString() ?? '',
        'code': jsonMap['code']?.toString() ?? '',
        'description': jsonMap['description']?.toString(),
        'isActive': jsonMap['is_active'] ?? true,
        'createdAt': _parseDateTime(jsonMap['created_at']).toIso8601String(),
        'updatedAt': _parseDateTime(jsonMap['updated_at']).toIso8601String(),
      };

      // Add faculty data if available
      if (facultyData != null) {
        departmentJson['faculty'] = _convertToModelFormat(facultyData);
      }

      return DepartmentModel.fromJson(departmentJson);
    }).toList();
  } on PostgrestException catch (e) {
    print(
        'Supabase Error loading all departments: ${e.message}, Code: ${e.code}');
    throw Exception('Failed to load departments: ${e.message}');
  } catch (e, stackTrace) {
    print(
        'Unexpected Error loading all departments: $e\nStackTrace: $stackTrace');
    throw Exception('Failed to load departments: $e');
  }
});

// Courses by Department Provider - Fixed
final coursesProvider =
    FutureProvider.family<List<CourseModel>, String>((ref, departmentId) async {
  try {
    if (departmentId.isEmpty) {
      throw ArgumentError('Department ID cannot be empty');
    }

    final response = await SupabaseService.from('courses')
        .select(
            '*, departments!courses_department_id_fkey(*, faculties!departments_faculty_id_fkey(*))')
        .eq('department_id', departmentId)
        .eq('is_active', true)
        .order('code');

    if (response == null || response.isEmpty) {
      return <CourseModel>[];
    }

    return response.map<CourseModel>((item) {
      final jsonMap = item as Map<String, dynamic>;
      final departmentData = jsonMap['departments'] as Map<String, dynamic>?;
      final facultyData = departmentData?['faculties'] as Map<String, dynamic>?;

      // Convert course data to model format
      final courseJson = {
        'id': jsonMap['id']?.toString() ?? '',
        'departmentId': jsonMap['department_id']?.toString() ?? '',
        'code': jsonMap['code']?.toString() ?? '',
        'title': jsonMap['title']?.toString() ?? '',
        'description': jsonMap['description']?.toString(),
        'credits': jsonMap['credits'] ?? 3,
        'level': jsonMap['level'] ?? 200,
        'semester': jsonMap['semester'] ?? 1,
        'academicYear': jsonMap['academic_year']?.toString() ?? '',
        'maxEnrollment': jsonMap['max_enrollment'] ?? 100,
        'currentEnrollment': jsonMap['current_enrollment'] ?? 0,
        'enrollmentStartDate': jsonMap['enrollment_start_date'] != null
            ? _parseDateTime(jsonMap['enrollment_start_date']).toIso8601String()
            : null,
        'enrollmentEndDate': jsonMap['enrollment_end_date'] != null
            ? _parseDateTime(jsonMap['enrollment_end_date']).toIso8601String()
            : null,
        'courseStartDate': jsonMap['course_start_date'] != null
            ? _parseDateTime(jsonMap['course_start_date']).toIso8601String()
            : null,
        'courseEndDate': jsonMap['course_end_date'] != null
            ? _parseDateTime(jsonMap['course_end_date']).toIso8601String()
            : null,
        'prerequisites':
            (jsonMap['prerequisites'] as List<dynamic>?)?.cast<String>() ??
                <String>[],
        'isActive': jsonMap['is_active'] ?? true,
        'createdAt': _parseDateTime(jsonMap['created_at']).toIso8601String(),
        'updatedAt': _parseDateTime(jsonMap['updated_at']).toIso8601String(),
        'coursePrerequisites': <Map<String, dynamic>>[], // Empty for now
      };

      // Add department data if available
      if (departmentData != null) {
        final departmentJson = {
          'id': departmentData['id']?.toString() ?? '',
          'facultyId': departmentData['faculty_id']?.toString() ?? '',
          'name': departmentData['name']?.toString() ?? '',
          'code': departmentData['code']?.toString() ?? '',
          'description': departmentData['description']?.toString(),
          'isActive': departmentData['is_active'] ?? true,
          'createdAt':
              _parseDateTime(departmentData['created_at']).toIso8601String(),
          'updatedAt':
              _parseDateTime(departmentData['updated_at']).toIso8601String(),
        };

        if (facultyData != null) {
          departmentJson['faculty'] = _convertToModelFormat(facultyData);
        }

        courseJson['department'] = departmentJson;
      }

      return CourseModel.fromJson(courseJson);
    }).toList();
  } on PostgrestException catch (e) {
    print('Supabase Error loading courses: ${e.message}, Code: ${e.code}');
    throw Exception('Failed to load courses: ${e.message}');
  } catch (e, stackTrace) {
    print('Unexpected Error loading courses: $e\nStackTrace: $stackTrace');
    throw Exception('Failed to load courses: $e');
  }
});

// Available Courses for Enrollment Provider - Fixed
final availableCoursesProvider =
    FutureProvider.family<List<CourseModel>, Map<String, dynamic>>(
        (ref, params) async {
  try {
    final studentId = params['studentId'] as String?;
    final departmentId = params['departmentId'] as String?;
    final level = params['level'] as int?;
    final semester = params['semester'] as int?;

    // Validate required parameters
    if (studentId == null || studentId.isEmpty) {
      throw ArgumentError('Student ID is required');
    }
    if (departmentId == null || departmentId.isEmpty) {
      throw ArgumentError('Department ID is required');
    }
    if (level == null || ![200, 300, 400, 500].contains(level)) {
      throw ArgumentError('Valid level (200, 300, 400, 500) is required');
    }
    if (semester == null || ![1, 2].contains(semester)) {
      throw ArgumentError('Valid semester (1 or 2) is required');
    }

    // Get enrolled course IDs for the student
    final enrolledCoursesResponse =
        await SupabaseService.from('course_enrollments')
            .select('course_id')
            .eq('student_id', studentId)
            .eq('is_active', true);

    final enrolledCourseIds = <String>[];
    if (enrolledCoursesResponse != null && enrolledCoursesResponse.isNotEmpty) {
      for (final enrollment in enrolledCoursesResponse) {
        final courseId =
            (enrollment as Map<String, dynamic>)['course_id'] as String?;
        if (courseId != null) {
          enrolledCourseIds.add(courseId);
        }
      }
    }

    // Build the main query
    var query = SupabaseService.from('courses')
        .select(
            '*, departments!courses_department_id_fkey(*, faculties!departments_faculty_id_fkey(*))')
        .eq('department_id', departmentId)
        .eq('level', level)
        .eq('semester', semester)
        .eq('is_active', true);

    // Exclude already enrolled courses if any exist
    if (enrolledCourseIds.isNotEmpty) {
      query = query.not('id', 'in', '(${enrolledCourseIds.join(',')})');
    }

    final response = await query.order('code');

    if (response == null || response.isEmpty) {
      return <CourseModel>[];
    }

    return response.map<CourseModel>((item) {
      final jsonMap = item as Map<String, dynamic>;
      final departmentData = jsonMap['departments'] as Map<String, dynamic>?;
      final facultyData = departmentData?['faculties'] as Map<String, dynamic>?;

      // Convert course data to model format
      final courseJson = {
        'id': jsonMap['id']?.toString() ?? '',
        'departmentId': jsonMap['department_id']?.toString() ?? '',
        'code': jsonMap['code']?.toString() ?? '',
        'title': jsonMap['title']?.toString() ?? '',
        'description': jsonMap['description']?.toString(),
        'credits': jsonMap['credits'] ?? 3,
        'level': jsonMap['level'] ?? 200,
        'semester': jsonMap['semester'] ?? 1,
        'academicYear': jsonMap['academic_year']?.toString() ?? '',
        'maxEnrollment': jsonMap['max_enrollment'] ?? 100,
        'currentEnrollment': jsonMap['current_enrollment'] ?? 0,
        'enrollmentStartDate': jsonMap['enrollment_start_date'] != null
            ? _parseDateTime(jsonMap['enrollment_start_date']).toIso8601String()
            : null,
        'enrollmentEndDate': jsonMap['enrollment_end_date'] != null
            ? _parseDateTime(jsonMap['enrollment_end_date']).toIso8601String()
            : null,
        'courseStartDate': jsonMap['course_start_date'] != null
            ? _parseDateTime(jsonMap['course_start_date']).toIso8601String()
            : null,
        'courseEndDate': jsonMap['course_end_date'] != null
            ? _parseDateTime(jsonMap['course_end_date']).toIso8601String()
            : null,
        'prerequisites':
            (jsonMap['prerequisites'] as List<dynamic>?)?.cast<String>() ??
                <String>[],
        'isActive': jsonMap['is_active'] ?? true,
        'createdAt': _parseDateTime(jsonMap['created_at']).toIso8601String(),
        'updatedAt': _parseDateTime(jsonMap['updated_at']).toIso8601String(),
        'coursePrerequisites': <Map<String, dynamic>>[], // Empty for now
      };

      // Add department data if available
      if (departmentData != null) {
        final departmentJson = {
          'id': departmentData['id']?.toString() ?? '',
          'facultyId': departmentData['faculty_id']?.toString() ?? '',
          'name': departmentData['name']?.toString() ?? '',
          'code': departmentData['code']?.toString() ?? '',
          'description': departmentData['description']?.toString(),
          'isActive': departmentData['is_active'] ?? true,
          'createdAt':
              _parseDateTime(departmentData['created_at']).toIso8601String(),
          'updatedAt':
              _parseDateTime(departmentData['updated_at']).toIso8601String(),
        };

        if (facultyData != null) {
          departmentJson['faculty'] = _convertToModelFormat(facultyData);
        }

        courseJson['department'] = departmentJson;
      }

      return CourseModel.fromJson(courseJson);
    }).toList();
  } on PostgrestException catch (e) {
    print(
        'Supabase Error loading available courses: ${e.message}, Code: ${e.code}');
    throw Exception('Failed to load available courses: ${e.message}');
  } catch (e, stackTrace) {
    print(
        'Unexpected Error loading available courses: $e\nStackTrace: $stackTrace');
    throw Exception('Failed to load available courses: $e');
  }
});

// Course Details Provider - Fixed
final courseDetailsProvider =
    FutureProvider.family<CourseModel, String>((ref, courseId) async {
  try {
    if (courseId.isEmpty) {
      throw ArgumentError('Course ID cannot be empty');
    }

    final response = await SupabaseService.from('courses').select('''
          *,
          departments!courses_department_id_fkey(*, faculties!departments_faculty_id_fkey(*)),
          course_assignments!course_assignments_course_id_fkey(*, lecturers!course_assignments_lecturer_id_fkey(*, users!lecturers_id_fkey(*)))
        ''').eq('id', courseId).single();

    if (response == null) {
      throw Exception('Course not found');
    }

    final jsonMap = response as Map<String, dynamic>;
    final departmentData = jsonMap['departments'] as Map<String, dynamic>?;
    final facultyData = departmentData?['faculties'] as Map<String, dynamic>?;
    final assignmentsData = jsonMap['course_assignments'] as List<dynamic>?;

    // Get current enrollment count
    final enrollmentResponse = await SupabaseService.from('course_enrollments')
        .select('id')
        .eq('course_id', courseId)
        .eq('is_active', true);

    int currentEnrollment = 0;
    if (enrollmentResponse != null) {
      currentEnrollment = enrollmentResponse.length;
    }

    // Convert course data to model format
    final courseJson = {
      'id': jsonMap['id']?.toString() ?? '',
      'departmentId': jsonMap['department_id']?.toString() ?? '',
      'code': jsonMap['code']?.toString() ?? '',
      'title': jsonMap['title']?.toString() ?? '',
      'description': jsonMap['description']?.toString(),
      'credits': jsonMap['credits'] ?? 3,
      'level': jsonMap['level'] ?? 200,
      'semester': jsonMap['semester'] ?? 1,
      'academicYear': jsonMap['academic_year']?.toString() ?? '',
      'maxEnrollment': jsonMap['max_enrollment'] ?? 100,
      'currentEnrollment': currentEnrollment,
      'enrollmentStartDate': jsonMap['enrollment_start_date'] != null
          ? _parseDateTime(jsonMap['enrollment_start_date']).toIso8601String()
          : null,
      'enrollmentEndDate': jsonMap['enrollment_end_date'] != null
          ? _parseDateTime(jsonMap['enrollment_end_date']).toIso8601String()
          : null,
      'courseStartDate': jsonMap['course_start_date'] != null
          ? _parseDateTime(jsonMap['course_start_date']).toIso8601String()
          : null,
      'courseEndDate': jsonMap['course_end_date'] != null
          ? _parseDateTime(jsonMap['course_end_date']).toIso8601String()
          : null,
      'prerequisites':
          (jsonMap['prerequisites'] as List<dynamic>?)?.cast<String>() ??
              <String>[],
      'isActive': jsonMap['is_active'] ?? true,
      'createdAt': _parseDateTime(jsonMap['created_at']).toIso8601String(),
      'updatedAt': _parseDateTime(jsonMap['updated_at']).toIso8601String(),
      'coursePrerequisites': <Map<String, dynamic>>[], // Empty for now
    };

    // Add department data if available
    if (departmentData != null) {
      final departmentJson = {
        'id': departmentData['id']?.toString() ?? '',
        'facultyId': departmentData['faculty_id']?.toString() ?? '',
        'name': departmentData['name']?.toString() ?? '',
        'code': departmentData['code']?.toString() ?? '',
        'description': departmentData['description']?.toString(),
        'isActive': departmentData['is_active'] ?? true,
        'createdAt':
            _parseDateTime(departmentData['created_at']).toIso8601String(),
        'updatedAt':
            _parseDateTime(departmentData['updated_at']).toIso8601String(),
      };

      if (facultyData != null) {
        departmentJson['faculty'] = _convertToModelFormat(facultyData);
      }

      courseJson['department'] = departmentJson;
    }

    // Add assignments data if available (simplified for now)
    if (assignmentsData != null) {
      courseJson['lecturers'] = assignmentsData.map((assignment) {
        final assignmentMap = assignment as Map<String, dynamic>;
        final lecturerData =
            assignmentMap['lecturers'] as Map<String, dynamic>?;
        return lecturerData ?? {};
      }).toList();
    }

    return CourseModel.fromJson(courseJson);
  } on PostgrestException catch (e) {
    print(
        'Supabase Error loading course details: ${e.message}, Code: ${e.code}');
    throw Exception('Failed to load course details: ${e.message}');
  } catch (e, stackTrace) {
    print(
        'Unexpected Error loading course details: $e\nStackTrace: $stackTrace');
    throw Exception('Failed to load course details: $e');
  }
});

// Student's enrolled courses provider - Fixed
final studentEnrolledCoursesProvider =
    FutureProvider.family<List<CourseModel>, String>((ref, studentId) async {
  try {
    if (studentId.isEmpty) {
      throw ArgumentError('Student ID cannot be empty');
    }

    final response = await SupabaseService.from('course_enrollments')
        .select('''
          *,
          courses!course_enrollments_course_id_fkey(
            *,
            departments!courses_department_id_fkey(*, faculties!departments_faculty_id_fkey(*))
          )
        ''')
        .eq('student_id', studentId)
        .eq('is_active', true)
        .order('created_at', ascending: false);

    if (response == null || response.isEmpty) {
      return <CourseModel>[];
    }

    return response.map<CourseModel>((item) {
      final jsonMap = item as Map<String, dynamic>;
      final courseData = jsonMap['courses'] as Map<String, dynamic>?;

      if (courseData == null) {
        throw Exception('Invalid enrollment data: missing course information');
      }

      final departmentData = courseData['departments'] as Map<String, dynamic>?;
      final facultyData = departmentData?['faculties'] as Map<String, dynamic>?;

      // Convert course data to model format
      final courseJson = {
        'id': courseData['id']?.toString() ?? '',
        'departmentId': courseData['department_id']?.toString() ?? '',
        'code': courseData['code']?.toString() ?? '',
        'title': courseData['title']?.toString() ?? '',
        'description': courseData['description']?.toString(),
        'credits': courseData['credits'] ?? 3,
        'level': courseData['level'] ?? 200,
        'semester': courseData['semester'] ?? 1,
        'academicYear': courseData['academic_year']?.toString() ?? '',
        'maxEnrollment': courseData['max_enrollment'] ?? 100,
        'currentEnrollment': courseData['current_enrollment'] ?? 0,
        'enrollmentStartDate': courseData['enrollment_start_date'] != null
            ? _parseDateTime(courseData['enrollment_start_date'])
                .toIso8601String()
            : null,
        'enrollmentEndDate': courseData['enrollment_end_date'] != null
            ? _parseDateTime(courseData['enrollment_end_date'])
                .toIso8601String()
            : null,
        'courseStartDate': courseData['course_start_date'] != null
            ? _parseDateTime(courseData['course_start_date']).toIso8601String()
            : null,
        'courseEndDate': courseData['course_end_date'] != null
            ? _parseDateTime(courseData['course_end_date']).toIso8601String()
            : null,
        'prerequisites':
            (courseData['prerequisites'] as List<dynamic>?)?.cast<String>() ??
                <String>[],
        'isActive': courseData['is_active'] ?? true,
        'createdAt': _parseDateTime(courseData['created_at']).toIso8601String(),
        'updatedAt': _parseDateTime(courseData['updated_at']).toIso8601String(),
        'coursePrerequisites': <Map<String, dynamic>>[], // Empty for now
      };

      // Add department data if available
      if (departmentData != null) {
        final departmentJson = {
          'id': departmentData['id']?.toString() ?? '',
          'facultyId': departmentData['faculty_id']?.toString() ?? '',
          'name': departmentData['name']?.toString() ?? '',
          'code': departmentData['code']?.toString() ?? '',
          'description': departmentData['description']?.toString(),
          'isActive': departmentData['is_active'] ?? true,
          'createdAt':
              _parseDateTime(departmentData['created_at']).toIso8601String(),
          'updatedAt':
              _parseDateTime(departmentData['updated_at']).toIso8601String(),
        };

        if (facultyData != null) {
          departmentJson['faculty'] = _convertToModelFormat(facultyData);
        }

        courseJson['department'] = departmentJson;
      }

      return CourseModel.fromJson(courseJson);
    }).toList();
  } on PostgrestException catch (e) {
    print(
        'Supabase Error loading enrolled courses: ${e.message}, Code: ${e.code}');
    throw Exception('Failed to load enrolled courses: ${e.message}');
  } catch (e, stackTrace) {
    print(
        'Unexpected Error loading enrolled courses: $e\nStackTrace: $stackTrace');
    throw Exception('Failed to load enrolled courses: $e');
  }
});