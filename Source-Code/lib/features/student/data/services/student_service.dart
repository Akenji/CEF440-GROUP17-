import '../../../../core/services/supabase_service.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/models/academic_model.dart';
import '../../../../core/models/attendance_model.dart';
import '../providers/student_providers.dart';

class StudentService {
  // Get student statistics
  static Future<StudentStats> getStudentStats(String studentId) async {
    try {
      // Get enrolled courses count
      final enrolledCoursesResponse = await SupabaseService.from('course_enrollments')
          .select('id')
          .eq('student_id', studentId)
          .eq('status', 'active');
      
      final enrolledCoursesCount = enrolledCoursesResponse.length;

      // Get total credits
      final creditsResponse = await SupabaseService.from('course_enrollments')
          .select('courses(credits)')
          .eq('student_id', studentId)
          .eq('status', 'active');
      
      final totalCredits = creditsResponse.fold<int>(0, (sum, enrollment) {
        final course = enrollment['courses'] as Map<String, dynamic>?;
        return sum + (course?['credits'] as int? ?? 0);
      });

      // Get attendance statistics
      final attendanceResponse = await SupabaseService.from('attendance_records')
          .select('status')
          .eq('student_id', studentId);
      
      final totalSessions = attendanceResponse.length;
      final attendedSessions = attendanceResponse.where((record) => 
          record['status'] == 'present' || record['status'] == 'late').length;
      
      final attendanceRate = totalSessions > 0 ? (attendedSessions / totalSessions) * 100 : 0.0;

      // Get current GPA (if grades are available)
      final gradesResponse = await SupabaseService.from('course_enrollments')
          .select('grade, grade_points')
          .eq('student_id', studentId)
          .not('grade', 'is', null);
      
      double? currentGPA;
      if (gradesResponse.isNotEmpty) {
        final totalGradePoints = gradesResponse.fold<double>(0, (sum, enrollment) {
          return sum + (enrollment['grade_points'] as double? ?? 0);
        });
        currentGPA = totalGradePoints / gradesResponse.length;
      }

      // Calculate today's sessions
      final today = DateTime.now();
      final todaySessions = attendanceResponse.where((record) {
        final createdAt = DateTime.tryParse(record['created_at'] ?? '');
        return createdAt != null &&
            createdAt.year == today.year &&
            createdAt.month == today.month &&
            createdAt.day == today.day;
      }).length;

      return StudentStats(
        enrolledCourses: enrolledCoursesCount,
        attendanceRate: attendanceRate,
        
      
        totalSessions: totalSessions,
        
        todaySessions: todaySessions,
      );
    } catch (e) {
      throw Exception('Failed to get student stats: $e');
    }
  }

  // Get upcoming sessions
  static Future<List<AttendanceSessionModel>> getUpcomingSessions(String studentId) async {
    try {
      final now = DateTime.now();
      final response = await SupabaseService.from('attendance_sessions')
          .select('''
            *,
            courses(*),
            lecturers(*, users(*))
          ''')
          .gte('scheduled_start', now.toIso8601String())
          .inFilter('course_id', await _getEnrolledCourseIds(studentId))
          .order('scheduled_start')
          .limit(10);

      return response.map<AttendanceSessionModel>((json) => 
          AttendanceSessionModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get upcoming sessions: $e');
    }
  }

  // Get recent attendance records
  static Future<List<AttendanceRecordModel>> getRecentAttendance(String studentId) async {
    try {
      final response = await SupabaseService.from('attendance_records')
          .select('''
            *,
            attendance_sessions(*,
              courses(*)
            )
          ''')
          .eq('student_id', studentId)
          .order('created_at', ascending: false)
          .limit(10);

      return response.map<AttendanceRecordModel>((json) => 
          AttendanceRecordModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get recent attendance: $e');
    }
  }

  // Get enrolled courses
  static Future<List<CourseEnrollmentModel>> getEnrolledCourses(String studentId) async {
    try {
      final response = await SupabaseService.from('course_enrollments')
          .select('''
            *,
            courses(*,
              departments(*,
                faculties(*)
              )
            )
          ''')
          .eq('student_id', studentId)
          .order('enrolled_at', ascending: false);

      return response.map<CourseEnrollmentModel>((json) => 
          CourseEnrollmentModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get enrolled courses: $e');
    }
  }

  // Get available courses for enrollment
  static Future<List<CourseModel>> getAvailableCoursesForEnrollment(String studentId) async {
    try {
      // Get student info first
      final studentResponse = await SupabaseService.from('students')
          .select('department_id, level')
          .eq('id', studentId)
          .single();
      
      final departmentId = studentResponse['department_id'];
      final level = studentResponse['level'];

      // Get enrolled course IDs
      final enrolledCourseIds = await _getEnrolledCourseIds(studentId);

      // Get available courses
      final response = await SupabaseService.from('courses')
          .select('''
            *,
            departments(*,
              faculties(*)
            )
          ''')
          .eq('department_id', departmentId)
          .eq('level', level)
          .eq('is_active', true)
          .not('id', 'in', '(${enrolledCourseIds.join(',')})')
          .order('code');

      return response.map<CourseModel>((json) => CourseModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get available courses: $e');
    }
  }

  // Get student profile
  static Future<StudentModel?> getStudentProfile(String studentId) async {
    try {
      final response = await SupabaseService.from('students')
          .select('''
            *,
            users(*),
            departments(*,
              faculties(*)
            )
          ''')
          .eq('id', studentId)
          .maybeSingle();

      if (response == null) return null;
      return StudentModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get student profile: $e');
    }
  }

  // Enroll in course
  static Future<void> enrollInCourse(String studentId, String courseId) async {
    try {
      // Check if already enrolled
      final existing = await SupabaseService.from('course_enrollments')
          .select('id')
          .eq('student_id', studentId)
          .eq('course_id', courseId)
          .eq('status', 'active')
          .maybeSingle();

      if (existing != null) {
        throw Exception('Already enrolled in this course');
      }

      // Check course capacity
      final courseResponse = await SupabaseService.from('courses')
          .select('max_enrollment, current_enrollment')
          .eq('id', courseId)
          .single();

      final maxEnrollment = courseResponse['max_enrollment'] as int;
      final currentEnrollment = courseResponse['current_enrollment'] as int;

      if (currentEnrollment >= maxEnrollment) {
        throw Exception('Course is full');
      }

      // Enroll student
      await SupabaseService.from('course_enrollments').insert({
        'student_id': studentId,
        'course_id': courseId,
        'status': 'active',
        'enrolled_at': DateTime.now().toIso8601String(),
      });

      // Update course enrollment count
      await SupabaseService.from('courses')
          .update({'current_enrollment': currentEnrollment + 1})
          .eq('id', courseId);

    } catch (e) {
      throw Exception('Failed to enroll in course: $e');
    }
  }

  // Drop course
  static Future<void> dropCourse(String studentId, String courseId) async {
    try {
      // Update enrollment status
      await SupabaseService.from('course_enrollments')
          .update({
            'status': 'dropped',
            'dropped_at': DateTime.now().toIso8601String(),
          })
          .eq('student_id', studentId)
          .eq('course_id', courseId)
          .eq('status', 'active');

      // Update course enrollment count
      final courseResponse = await SupabaseService.from('courses')
          .select('current_enrollment')
          .eq('id', courseId)
          .single();

      final currentEnrollment = courseResponse['current_enrollment'] as int;
      
      await SupabaseService.from('courses')
          .update({'current_enrollment': (currentEnrollment - 1).clamp(0, double.infinity).toInt()})
          .eq('id', courseId);

    } catch (e) {
      throw Exception('Failed to drop course: $e');
    }
  }

  // Helper method to get enrolled course IDs
  static Future<List<String>> _getEnrolledCourseIds(String studentId) async {
    try {
      final response = await SupabaseService.from('course_enrollments')
          .select('course_id')
          .eq('student_id', studentId)
          .eq('status', 'active');

      return response.map<String>((enrollment) => enrollment['course_id'] as String).toList();
    } catch (e) {
      return [];
    }
  }
}
