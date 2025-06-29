import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/models/academic_model.dart';
import '../../../../core/models/attendance_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/supabase_service.dart';

// Current student provider
final currentStudentProvider = FutureProvider<StudentModel>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.role != UserRole.student) {
    throw Exception('User is not a student');
  }

  try {
    final response = await SupabaseService.from('students')
        .select('''
          *,
          users(*),
          departments(*, faculties(*))
        ''')
        .eq('id', user.id)
        .single();

    return StudentModel.fromJson(response);
  } catch (e) {
    throw Exception('Failed to load student data: $e');
  }
});

// Student stats provider
final studentStatsProvider = FutureProvider<StudentStats>((ref) async {
  final student = await ref.watch(currentStudentProvider.future);

  try {
    // Get enrolled courses count
    final enrollmentsResponse = await SupabaseService.from('course_enrollments')
        .select('course_id')
        .eq('student_id', student.id  as String)
        .eq('is_active', true);
    final enrolledCourses = enrollmentsResponse.length;

    // Get today's sessions
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final todaySessionsResponse = await SupabaseService.from('attendance_sessions')
        .select('id')
       .inFilter('course_id', enrollmentsResponse.map((e) => e['course_id']).toList())
        .gte('scheduled_start', startOfDay.toIso8601String())
        .lt('scheduled_start', endOfDay.toIso8601String());
    final todaySessions = todaySessionsResponse.length;

    // Get attendance records for this month
    final monthStart = DateTime(today.year, today.month, 1);
    final monthEnd = DateTime(today.year, today.month + 1, 1);

    final monthSessionsResponse = await SupabaseService.from('attendance_sessions')
        .select('id')
        .inFilter('course_id', enrollmentsResponse.map((e) => e['course_id']).toList())
        .gte('scheduled_start', monthStart.toIso8601String())
        .lt('scheduled_start', monthEnd.toIso8601String());

    double attendanceRate = 0.0;
    if (monthSessionsResponse.isNotEmpty) {
      final sessionIds = monthSessionsResponse.map((s) => s['id']).toList();
      final attendanceResponse = await SupabaseService.from('attendance_records')
          .select('status')
          .eq('student_id', student.id as String)
          .inFilter('session_id', sessionIds);

      if (attendanceResponse.isNotEmpty) {
        final presentCount = attendanceResponse
            .where((r) => r['status'] == 'present' || r['status'] == 'late')
            .length;
        attendanceRate = (presentCount / monthSessionsResponse.length) * 100;
      }
    }

    return StudentStats(
      enrolledCourses: enrolledCourses,
      todaySessions: todaySessions,
      attendanceRate: attendanceRate,
      totalSessions: monthSessionsResponse.length,
    );
  } catch (e) {
    throw Exception('Failed to load student stats: $e');
  }
});

// Enrolled courses provider - IMPLEMENTED
final enrolledCoursesProvider = FutureProvider.family<List<CourseEnrollmentModel>, String>((ref, studentId) async {
  try {
    final response = await SupabaseService.from('course_enrollments')
        .select('''
          *,
          courses(
            *,
            departments(*, faculties(*)),
            course_assignments(
              *,
              lecturers(*, users(*))
            )
          )
        ''')
        .eq('student_id', studentId)
        .eq('is_active', true)
        .order('enrolled_at', ascending: false);

    return response
        .map((item) => CourseEnrollmentModel.fromJson(item))
        .toList();
  } catch (e) {
    throw Exception('Failed to load enrolled courses: $e');
  }
});

// Recent attendance provider - IMPLEMENTED
final recentAttendanceProvider = FutureProvider.family<List<AttendanceRecordModel>, String>((ref, studentId) async {
  try {
    final response = await SupabaseService.from('attendance_records')
        .select('''
          *,
          attendance_sessions(
            *,
            courses(*, departments(*)),
            lecturers(*, users(*))
          )
        ''')
        .eq('student_id', studentId)
        .order('marked_at', ascending: false)
        .limit(20);

    return response
        .map((item) => AttendanceRecordModel.fromJson(item))
        .toList();
  } catch (e) {
    throw Exception('Failed to load recent attendance: $e');
  }
});

// Upcoming sessions provider - IMPLEMENTED
final upcomingSessionsProvider = FutureProvider.family<List<AttendanceSessionModel>, String>((ref, studentId) async {
  try {
    // First get enrolled course IDs
    final enrollmentsResponse = await SupabaseService.from('course_enrollments')
        .select('course_id')
        .eq('student_id', studentId)
        .eq('is_active', true);

    if (enrollmentsResponse.isEmpty) return [];

    final courseIds = enrollmentsResponse.map((e) => e['course_id']).toList();

    // Get upcoming sessions for enrolled courses
    final response = await SupabaseService.from('attendance_sessions')
        .select('''
          *,
          courses(*, departments(*)),
          lecturers(*, users(*))
        ''')
        .inFilter('course_id', courseIds)
        .inFilter('status', ['scheduled', 'active'])
        .gte('scheduled_start', DateTime.now().toIso8601String())
        .order('scheduled_start')
        .limit(10);

    return response
        .map((item) => AttendanceSessionModel.fromJson(item))
        .toList();
  } catch (e) {
    throw Exception('Failed to load upcoming sessions: $e');
  }
});

// Available courses for enrollment provider
final availableCoursesProvider = FutureProvider.family<List<CourseModel>, String>((ref, studentId) async {
  try {
    // Get student info to filter by department and level
    final studentResponse = await SupabaseService.from('students')
        .select('department_id, level')
        .eq('id', studentId)
        .single();

    // Get already enrolled course IDs
    final enrolledResponse = await SupabaseService.from('course_enrollments')
        .select('course_id')
        .eq('student_id', studentId)
        .eq('is_active', true);

    final enrolledCourseIds = enrolledResponse.map((e) => e['course_id']).toList();

    // Build query for available courses
    var query = SupabaseService.from('courses')
        .select('''
          *,
          departments(*, faculties(*))
        ''')
        .eq('department_id', studentResponse['department_id'])
        .eq('level', studentResponse['level'])
        .eq('is_active', true)
        .lte('enrollment_start_date', DateTime.now().toIso8601String())
        .gte('enrollment_end_date', DateTime.now().toIso8601String());

    // Exclude already enrolled courses
    if (enrolledCourseIds.isNotEmpty) {
      query = query.not('id', 'in', '(${enrolledCourseIds.join(',')})');
    }

    final response = await query;

    return response
        .map((item) => CourseModel.fromJson(item))
        .toList();
  } catch (e) {
    throw Exception('Failed to load available courses: $e');
  }
});

// Student course details provider
final studentCourseDetailsProvider = FutureProvider.family<CourseEnrollmentModel?, String>((ref, enrollmentId) async {
  try {
    final response = await SupabaseService.from('course_enrollments')
        .select('''
          *,
          courses(
            *,
            departments(*, faculties(*)),
            course_assignments(
              *,
              lecturers(*, users(*))
            )
          )
        ''')
        .eq('id', enrollmentId)
        .single();

    return CourseEnrollmentModel.fromJson(response);
  } catch (e) {
    throw Exception('Failed to load course details: $e');
  }
});

// Student attendance summary provider
final studentAttendanceSummaryProvider = FutureProvider.family<AttendanceSummary, String>((ref, studentId) async {
  try {
    // Get all attendance records for the student
    final response = await SupabaseService.from('attendance_records')
        .select('''
          status,
          attendance_sessions(course_id, courses(title))
        ''')
        .eq('student_id', studentId);

    final Map<String, CourseAttendanceSummary> courseSummaries = {};
    int totalPresent = 0;
    int totalLate = 0;
    int totalAbsent = 0;
    int totalExcused = 0;

    for (final record in response) {
      final status = record['status'] as String;
      final courseId = record['attendance_sessions']['course_id'] as String;
      final courseTitle = record['attendance_sessions']['courses']['title'] as String;

      // Update course summary
      if (!courseSummaries.containsKey(courseId)) {
        courseSummaries[courseId] = CourseAttendanceSummary(
          courseId: courseId,
          courseTitle: courseTitle,
          present: 0,
          late: 0,
          absent: 0,
          excused: 0,
        );
      }

      final courseSummary = courseSummaries[courseId]!;
      switch (status) {
        case 'present':
          courseSummary.present++;
          totalPresent++;
          break;
        case 'late':
          courseSummary.late++;
          totalLate++;
          break;
        case 'absent':
          courseSummary.absent++;
          totalAbsent++;
          break;
        case 'excused':
          courseSummary.excused++;
          totalExcused++;
          break;
      }
    }

    return AttendanceSummary(
      totalPresent: totalPresent,
      totalLate: totalLate,
      totalAbsent: totalAbsent,
      totalExcused: totalExcused,
      courseSummaries: courseSummaries.values.toList(),
    );
  } catch (e) {
    throw Exception('Failed to load attendance summary: $e');
  }
});

// Course enrollment provider
final courseEnrollmentProvider = StateNotifierProvider<CourseEnrollmentNotifier, AsyncValue<void>>((ref) {
  return CourseEnrollmentNotifier(ref);
});

class CourseEnrollmentNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  CourseEnrollmentNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> enrollInCourse(String studentId, String courseId) async {
    state = const AsyncValue.loading();

    try {
      // Check if course is available for enrollment
      final course = await SupabaseService.from('courses')
          .select('max_enrollment, current_enrollment, enrollment_end_date')
          .eq('id', courseId)
          .single();

      // Check enrollment deadline
      final enrollmentEndDate = DateTime.parse(course['enrollment_end_date']);
      if (DateTime.now().isAfter(enrollmentEndDate)) {
        throw Exception('Enrollment period has ended');
      }

      // Check capacity
      if (course['current_enrollment'] >= course['max_enrollment']) {
        throw Exception('Course is full');
      }

      // Check if already enrolled
      final existingEnrollment = await SupabaseService.from('course_enrollments')
          .select('id')
          .eq('student_id', studentId)
          .eq('course_id', courseId)
          .eq('is_active', true)
          .maybeSingle();

      if (existingEnrollment != null) {
        throw Exception('Already enrolled in this course');
      }

      // Enroll student
      await SupabaseService.from('course_enrollments').insert({
        'course_id': courseId,
        'student_id': studentId,
        'status': 'active',
        'is_active': true,
        'enrolled_at': DateTime.now().toIso8601String(),
      });

      // Update course enrollment count
      await SupabaseService.from('courses')
          .update({
            'current_enrollment': course['current_enrollment'] + 1,
          })
          .eq('id', courseId);

      // Refresh related providers
      ref.invalidate(enrolledCoursesProvider);
      ref.invalidate(availableCoursesProvider);
      ref.invalidate(studentStatsProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> dropCourse(String studentId, String courseId) async {
    state = const AsyncValue.loading();

    try {
      // Update enrollment status
      await SupabaseService.from('course_enrollments')
          .update({
            'status': 'dropped',
            'is_active': false,
            'dropped_at': DateTime.now().toIso8601String(),
          })
          .eq('course_id', courseId)
          .eq('student_id', studentId);

      // Update course enrollment count
      final course = await SupabaseService.from('courses')
          .select('current_enrollment')
          .eq('id', courseId)
          .single();

      await SupabaseService.from('courses')
          .update({
            'current_enrollment': (course['current_enrollment'] as int) - 1,
          })
          .eq('id', courseId);

      // Refresh related providers
      ref.invalidate(enrolledCoursesProvider);
      ref.invalidate(availableCoursesProvider);
      ref.invalidate(studentStatsProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

// Data models
class StudentStats {
  final int enrolledCourses;
  final int todaySessions;
  final double attendanceRate;
  final int totalSessions;

  StudentStats({
    required this.enrolledCourses,
    required this.todaySessions,
    required this.attendanceRate,
    required this.totalSessions,
  });
}

class AttendanceSummary {
  final int totalPresent;
  final int totalLate;
  final int totalAbsent;
  final int totalExcused;
  final List<CourseAttendanceSummary> courseSummaries;

  AttendanceSummary({
    required this.totalPresent,
    required this.totalLate,
    required this.totalAbsent,
    required this.totalExcused,
    required this.courseSummaries,
  });

  int get totalSessions => totalPresent + totalLate + totalAbsent + totalExcused;
  double get attendanceRate => totalSessions > 0 ? ((totalPresent + totalLate) / totalSessions) * 100 : 0.0;
}

class CourseAttendanceSummary {
  final String courseId;
  final String courseTitle;
  int present;
  int late;
  int absent;
  int excused;

  CourseAttendanceSummary({
    required this.courseId,
    required this.courseTitle,
    required this.present,
    required this.late,
    required this.absent,
    required this.excused,
  });

  int get totalSessions => present + late + absent + excused;
  double get attendanceRate => totalSessions > 0 ? ((present + late) / totalSessions) * 100 : 0.0;
}

// Available courses for enrollment provider - IMPLEMENTED
final availableCoursesForEnrollmentProvider = FutureProvider.family<List<CourseModel>, String>((ref, studentId) async {
  try {
    // Get student info to filter by department and level
    final studentResponse = await SupabaseService.from('students')
        .select('department_id, level')
        .eq('id', studentId)
        .single();

    // Get already enrolled course IDs
    final enrolledResponse = await SupabaseService.from('course_enrollments')
        .select('course_id')
        .eq('student_id', studentId)
        .eq('is_active', true);

    final enrolledCourseIds = enrolledResponse.map((e) => e['course_id']).toList();

    // Build query for available courses
    var query = SupabaseService.from('courses')
        .select('''
          *,
          departments(*, faculties(*)),
          course_assignments(
            *,
            lecturers(*, users(*))
          )
        ''')
        .eq('department_id', studentResponse['department_id'])
        .eq('level', studentResponse['level'])
        .eq('is_active', true)
        .lte('enrollment_start_date', DateTime.now().toIso8601String())
        .gte('enrollment_end_date', DateTime.now().toIso8601String());
        // Note: Removed .lt('current_enrollment', SupabaseService.raw('max_enrollment'))
        // because Supabase client does not support column-to-column comparison directly.
        // You may need to filter this in Dart after fetching the data if required.

    // Exclude already enrolled courses
    if (enrolledCourseIds.isNotEmpty) {
      query = query.not('id', 'in', '(${enrolledCourseIds.join(',')})');
    }

    final response = await query.order('title');

    return response
        .map((item) => CourseModel.fromJson(item))
        .toList();
  } catch (e) {
    throw Exception('Failed to load available courses for enrollment: $e');
  }
});

// Student attendance history provider - IMPLEMENTED
final studentAttendanceHistoryProvider = FutureProvider.family<List<AttendanceRecordModel>, String>((ref, studentId) async {
  try {
    final response = await SupabaseService.from('attendance_records')
        .select('''
          *,
          attendance_sessions(
            *,
            courses(
              *,
              departments(*, faculties(*))
            ),
            lecturers(*, users(*))
          )
        ''')
        .eq('student_id', studentId)
        .order('marked_at', ascending: false)
        .limit(100);

    return response
        .map((item) => AttendanceRecordModel.fromJson(item))
        .toList();
  } catch (e) {
    throw Exception('Failed to load attendance history: $e');
  }
});

// Student attendance history with filters provider
final studentAttendanceHistoryFilteredProvider = FutureProvider.family<List<AttendanceRecordModel>, AttendanceHistoryFilter>((ref, filter) async {
  try {
    var query = SupabaseService.from('attendance_records')
        .select('''
          *,
          attendance_sessions(
            *,
            courses(
              *,
              departments(*, faculties(*))
            ),
            lecturers(*, users(*))
          )
        ''')
        .eq('student_id', filter.studentId);

    // Apply date filters
    if (filter.startDate != null) {
      query = query.gte('marked_at', filter.startDate!.toIso8601String());
    }
    if (filter.endDate != null) {
      query = query.lte('marked_at', filter.endDate!.toIso8601String());
    }

    // Apply status filter
    if (filter.status != null) {
      query = query.eq('status', filter.status!);
    }

    // Apply course filter
    if (filter.courseId != null) {
      query = query.eq('attendance_sessions.course_id', filter.courseId!);
    }

    final response = await query
        .order('marked_at', ascending: false)
        .limit(filter.limit ?? 100);

    return response
        .map((item) => AttendanceRecordModel.fromJson(item))
        .toList();
  } catch (e) {
    throw Exception('Failed to load filtered attendance history: $e');
  }
});

// Student course attendance summary provider
final studentCourseAttendanceProvider = FutureProvider.family<Map<String, CourseAttendanceStats>, String>((ref, studentId) async {
  try {
    final response = await SupabaseService.from('attendance_records')
        .select('''
          status,
          attendance_sessions(
            course_id,
            courses(id, title, code)
          )
        ''')
        .eq('student_id', studentId);

    final Map<String, CourseAttendanceStats> courseStats = {};

    for (final record in response) {
      final status = record['status'] as String;
      final session = record['attendance_sessions'];
      final course = session['courses'];
      final courseId = course['id'] as String;

      if (!courseStats.containsKey(courseId)) {
        courseStats[courseId] = CourseAttendanceStats(
          courseId: courseId,
          courseTitle: course['title'] as String,
          courseCode: course['code'] as String,
          present: 0,
          late: 0,
          absent: 0,
          excused: 0,
        );
      }

      final stats = courseStats[courseId]!;
      switch (status) {
        case 'present':
          stats.present++;
          break;
        case 'late':
          stats.late++;
          break;
        case 'absent':
          stats.absent++;
          break;
        case 'excused':
          stats.excused++;
          break;
      }
    }

    return courseStats;
  } catch (e) {
    throw Exception('Failed to load course attendance stats: $e');
  }
});

// Additional data models
class AttendanceHistoryFilter {
  final String studentId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final String? courseId;
  final int? limit;

  AttendanceHistoryFilter({
    required this.studentId,
    this.startDate,
    this.endDate,
    this.status,
    this.courseId,
    this.limit,
  });
}

class CourseAttendanceStats {
  final String courseId;
  final String courseTitle;
  final String courseCode;
  int present;
  int late;
  int absent;
  int excused;

  CourseAttendanceStats({
    required this.courseId,
    required this.courseTitle,
    required this.courseCode,
    required this.present,
    required this.late,
    required this.absent,
    required this.excused,
  });

  int get totalSessions => present + late + absent + excused;
  double get attendanceRate => totalSessions > 0 ? ((present + late) / totalSessions) * 100 : 0.0;
  String get attendanceRateString => '${attendanceRate.toStringAsFixed(1)}%';
}

// Student profile provider - IMPLEMENTED
final studentProfileProvider = FutureProvider.family<StudentModel?, String?>((ref, userId) async {
  if (userId == null) return null;

  try {
    final response = await SupabaseService.from('students')
        .select('''
          *,
          users(*),
          departments(
            *,
            faculties(*)
          )
        ''')
        .eq('id', userId)
        .single();

    return StudentModel.fromJson(response);
  } catch (e) {
    throw Exception('Failed to load student profile: $e');
  }
});

// Enhanced student stats provider with more comprehensive data
final simplestudentStatsProvider = FutureProvider.family<EnhancedStudentStats, String>((ref, studentId) async {
  try {
    // Get enrolled courses count and total credits
    final enrollmentsResponse = await SupabaseService.from('course_enrollments')
        .select('''
          course_id,
          courses(credits)
        ''')
        .eq('student_id', studentId)
        .eq('is_active', true);
    
    final enrolledCourses = enrollmentsResponse.length;
    final totalCredits = enrollmentsResponse.fold<int>(
      0, 
      (sum, enrollment) => sum + (enrollment['courses']['credits'] as int? ?? 0)
    );

    // Get today's sessions
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final courseIds = enrollmentsResponse.map((e) => e['course_id']).toList();
    
    final todaySessionsResponse = courseIds.isNotEmpty 
        ? await SupabaseService.from('attendance_sessions')
            .select('id, status')
            .inFilter('course_id', courseIds)
            .gte('scheduled_start', startOfDay.toIso8601String())
            .lt('scheduled_start', endOfDay.toIso8601String())
        : <Map<String, dynamic>>[];
    
    final todaySessions = todaySessionsResponse.length;
    final activeSessions = todaySessionsResponse
        .where((session) => session['status'] == 'active')
        .length;

    // Get attendance records for current semester/month
    final monthStart = DateTime(today.year, today.month, 1);
    final monthEnd = DateTime(today.year, today.month + 1, 1);

    final monthSessionsResponse = courseIds.isNotEmpty
        ? await SupabaseService.from('attendance_sessions')
            .select('id')
            .inFilter('course_id', courseIds)
            .gte('scheduled_start', monthStart.toIso8601String())
            .lt('scheduled_start', monthEnd.toIso8601String())
        : <Map<String, dynamic>>[];

    double attendanceRate = 0.0;
    int presentCount = 0;
    int lateCount = 0;
    int absentCount = 0;
    int excusedCount = 0;

    if (monthSessionsResponse.isNotEmpty) {
      final sessionIds = monthSessionsResponse.map((s) => s['id']).toList();
      final attendanceResponse = await SupabaseService.from('attendance_records')
          .select('status')
          .eq('student_id', studentId)
          .inFilter('session_id', sessionIds);

      for (final record in attendanceResponse) {
        switch (record['status'] as String) {
          case 'present':
            presentCount++;
            break;
          case 'late':
            lateCount++;
            break;
          case 'absent':
            absentCount++;
            break;
          case 'excused':
            excusedCount++;
            break;
        }
      }

      if (monthSessionsResponse.isNotEmpty) {
        attendanceRate = ((presentCount + lateCount) / monthSessionsResponse.length) * 100;
      }
    }

    // Get current GPA (if grades are available)
    double? currentGPA;
    try {
      final gradesResponse = await SupabaseService.from('course_enrollments')
          .select('final_grade')
          .eq('student_id', studentId)
          .eq('is_active', true)
          .not('final_grade', 'is', null);

      if (gradesResponse.isNotEmpty) {
        final totalGradePoints = gradesResponse.fold<double>(
          0.0,
          (sum, enrollment) => sum + (enrollment['final_grade'] as double? ?? 0.0)
        );
        currentGPA = totalGradePoints / gradesResponse.length;
      }
    } catch (e) {
      // GPA calculation failed, continue without it
      currentGPA = null;
    }

    // Get upcoming sessions count
    final upcomingSessionsResponse = courseIds.isNotEmpty
        ? await SupabaseService.from('attendance_sessions')
            .select('id')
            .inFilter('course_id', courseIds)
            .inFilter('status', ['scheduled'])
            .gte('scheduled_start', DateTime.now().toIso8601String())
            .order('scheduled_start')
            .limit(5)
        : <Map<String, dynamic>>[];

    return EnhancedStudentStats(
      enrolledCourses: enrolledCourses,
      totalCredits: totalCredits,
      todaySessions: todaySessions,
      activeSessions: activeSessions,
      upcomingSessions: upcomingSessionsResponse.length,
      attendanceRate: attendanceRate,
      totalSessions: monthSessionsResponse.length,
      presentCount: presentCount,
      lateCount: lateCount,
      absentCount: absentCount,
      excusedCount: excusedCount,
      currentGPA: currentGPA,
    );
  } catch (e) {
    throw Exception('Failed to load student stats: $e');
  }
});

// Student performance analytics provider
final studentPerformanceProvider = FutureProvider.family<StudentPerformance, String>((ref, studentId) async {
  try {
    // Get attendance trend for last 6 months
    final sixMonthsAgo = DateTime.now().subtract(const Duration(days: 180));
    
    final attendanceRecords = await SupabaseService.from('attendance_records')
        .select('''
          status,
          marked_at,
          attendance_sessions(
            scheduled_start,
            course_id,
            courses(title)
          )
        ''')
        .eq('student_id', studentId)
        .gte('marked_at', sixMonthsAgo.toIso8601String())
        .order('marked_at');

    // Calculate monthly attendance rates
    final Map<String, MonthlyAttendance> monthlyStats = {};
    
    for (final record in attendanceRecords) {
      final date = DateTime.parse(record['marked_at']);
      final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      
      if (!monthlyStats.containsKey(monthKey)) {
        monthlyStats[monthKey] = MonthlyAttendance(
          month: monthKey,
          present: 0,
          late: 0,
          absent: 0,
          total: 0,
        );
      }
      
      final monthStat = monthlyStats[monthKey]!;
      monthStat.total++;
      
      switch (record['status'] as String) {
        case 'present':
          monthStat.present++;
          break;
        case 'late':
          monthStat.late++;
          break;
        case 'absent':
          monthStat.absent++;
          break;
      }
    }

    // Get course-wise performance
    final coursePerformance = <String, CoursePerformance>{};
    
    for (final record in attendanceRecords) {
      final courseId = record['attendance_sessions']['course_id'] as String;
      final courseTitle = record['attendance_sessions']['courses']['title'] as String;
      
      if (!coursePerformance.containsKey(courseId)) {
        coursePerformance[courseId] = CoursePerformance(
          courseName: courseTitle,
          score: 0.0,
          maxScore: 0.0,
        );
      }

      // If you want to calculate score/maxScore, update here as needed.
      // Example: increment score/maxScore based on attendance or grades.

    }

    return StudentPerformance(
      monthlyAttendance: monthlyStats.values.toList()
        ..sort((a, b) => a.month.compareTo(b.month)),
      coursePerformance: coursePerformance.values.toList()
        ..sort((a, b) => b.attendanceRate.compareTo(a.attendanceRate)),
    );
  } catch (e) {
    throw Exception('Failed to load student performance: $e');
  }
});

// Enhanced student stats model
class EnhancedStudentStats {
  final int enrolledCourses;
  final int totalCredits;
  final int todaySessions;
  final int activeSessions;
  final int upcomingSessions;
  final double attendanceRate;
  final int totalSessions;
  final int presentCount;
  final int lateCount;
  final int absentCount;
  final int excusedCount;
  final double? currentGPA;

  EnhancedStudentStats({
    required this.enrolledCourses,
    required this.totalCredits,
    required this.todaySessions,
    required this.activeSessions,
    required this.upcomingSessions,
    required this.attendanceRate,
    required this.totalSessions,
    required this.presentCount,
    required this.lateCount,
    required this.absentCount,
    required this.excusedCount,
    this.currentGPA,
  });

  String get attendanceRateString => '${attendanceRate.toStringAsFixed(1)}%';
  String get gpaString => currentGPA?.toStringAsFixed(2) ?? 'N/A';
}

// Student performance models
class StudentPerformance {
  final List<MonthlyAttendance> monthlyAttendance;
  final List<CoursePerformance> coursePerformance;

  StudentPerformance({
    required this.monthlyAttendance,
    required this.coursePerformance,
  });
}

class MonthlyAttendance {
  final String month;
  int present;
  int late;
  int absent;
  int total;

  MonthlyAttendance({
    required this.month,
    required this.present,
    required this.late,
    required this.absent,
    required this.total,
  });

  double get attendanceRate =>
      total > 0 ? ((present + late) / total) * 100 : 0.0;
}

class CoursePerformance {
  final String courseName;
  final double score;
  final double maxScore;

  CoursePerformance({
    required this.courseName,
    required this.score,
    required this.maxScore,
  });

  double get percentage =>
      maxScore > 0 ? (score / maxScore) * 100 : 0.0;

  double get attendanceRate => percentage;
}
