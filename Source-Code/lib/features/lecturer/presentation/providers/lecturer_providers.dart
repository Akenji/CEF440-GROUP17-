import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';


import '../../../../core/models/user_model.dart';
import '../../../../core/models/academic_model.dart';
import '../../../../core/models/attendance_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/supabase_service.dart';

// Current lecturer provider
final currentLecturerProvider = FutureProvider<LecturerModel>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.role != UserRole.lecturer) {
    throw Exception('User is not a lecturer');
  }

  try {
    final response = await SupabaseService.from('lecturers')
        .select('''
          *,
          users(*),
          departments(*, faculties(*))
        ''')
        .eq('id', user.id)
        .single();

    return LecturerModel.fromJson(response);
  } catch (e) {
    throw Exception('Failed to load lecturer data: $e');
  }
});

// Lecturer stats provider
final lecturerStatsProvider = FutureProvider<LecturerStats>((ref) async {
  final lecturer = await ref.watch(currentLecturerProvider.future);

  try {
    // Get total courses
    final coursesResponse = await SupabaseService.from('course_assignments')
        .select('course_id')
        .eq('lecturer_id', lecturer.id);
    final totalCourses = coursesResponse.length;

    // Get active sessions today
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final sessionsResponse = await SupabaseService.from('attendance_sessions')
        .select('id')
        .eq('lecturer_id', lecturer.id)
        .gte('scheduled_start', startOfDay.toIso8601String())
        .lt('scheduled_start', endOfDay.toIso8601String());
    final todaySessions = sessionsResponse.length;

    // Get total students across all courses
    final studentsResponse = await SupabaseService.from('course_enrollments')
        .select('student_id')
        .inFilter('course_id', coursesResponse.map((c) => c['course_id']).toList());
    final totalStudents = studentsResponse.map((s) => s['student_id']).toSet().length;

    // Get attendance rate for this week
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    final weekSessionsResponse = await SupabaseService.from('attendance_sessions')
        .select('id')
        .eq('lecturer_id', lecturer.id)
        .gte('scheduled_start', weekStart.toIso8601String())
        .lt('scheduled_start', weekEnd.toIso8601String());

    double attendanceRate = 0.0;
    if (weekSessionsResponse.isNotEmpty) {
      final sessionIds = weekSessionsResponse.map((s) => s['id']).toList();
      final attendanceResponse = await SupabaseService.from('attendance_records')
          .select('status')
          .inFilter('session_id', sessionIds);

      if (attendanceResponse.isNotEmpty) {
        final presentCount = attendanceResponse
            .where((r) => r['status'] == 'present' || r['status'] == 'late')
            .length;
        attendanceRate = (presentCount / attendanceResponse.length) * 100;
      }
    }

    return LecturerStats(
      totalCourses: totalCourses,
      todaySessions: todaySessions,
      totalStudents: totalStudents,
      attendanceRate: attendanceRate,
    );
  } catch (e) {
    throw Exception('Failed to load lecturer stats: $e');
  }
});

// Lecturer courses provider
final lecturerCoursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  final lecturer = await ref.watch(currentLecturerProvider.future);

  try {
    final response = await SupabaseService.from('course_assignments')
        .select('''
          courses(
            *,
            departments(*, faculties(*)),
            course_enrollments(count)
          )
        ''')
        .eq('lecturer_id', lecturer.id);

    return response
        .map((item) {
          final courseData = item['courses'];
          final enrollmentCount = courseData['course_enrollments']?.length ?? 0;
          
          return CourseModel.fromJson({
            ...courseData,
            'current_enrollment': enrollmentCount,
          });
        })
        .toList();
  } catch (e) {
    throw Exception('Failed to load lecturer courses: $e');
  }
});

// All lecturer sessions provider
final lecturerSessionsProvider = FutureProvider<List<AttendanceSessionModel>>((ref) async {
  final lecturer = await ref.watch(currentLecturerProvider.future);

  try {
    final response = await SupabaseService.from('attendance_sessions')
        .select('''
          *,
          courses(*),
          lecturers(*, users(*))
        ''')
        .eq('lecturer_id', lecturer.id)
        .order('scheduled_start', ascending: false);

    return response
        .map((item) => AttendanceSessionModel.fromJson(item))
        .toList();
  } catch (e) {
    throw Exception('Failed to load sessions: $e');
  }
});

// Active sessions provider
final lecturerActiveSessionsProvider = FutureProvider<List<AttendanceSessionModel>>((ref) async {
  final lecturer = await ref.watch(currentLecturerProvider.future);

  try {
    final response = await SupabaseService.from('attendance_sessions')
        .select('''
          *,
          courses(*),
          lecturers(*, users(*))
        ''')
        .eq('lecturer_id', lecturer.id)
        .inFilter('status', ['scheduled', 'active'])
        .order('scheduled_start');

    return response
        .map((item) => AttendanceSessionModel.fromJson(item))
        .toList();
  } catch (e) {
    throw Exception('Failed to load active sessions: $e');
  }
});

// Session attendance provider
final sessionAttendanceProvider = FutureProvider.family<SessionAttendanceData, String>((ref, sessionId) async {
  try {
    // Get session details
    final sessionResponse = await SupabaseService.from('attendance_sessions')
        .select('''
          *,
          courses(*)
        ''')
        .eq('id', sessionId)
        .single();

    final session = AttendanceSessionModel.fromJson(sessionResponse);

    // Get attendance records
    final attendanceResponse = await SupabaseService.from('attendance_records')
        .select('''
          *,
          students(*, users(*))
        ''')
        .eq('session_id', sessionId)
        .order('marked_at');

    final attendanceRecords = attendanceResponse
        .map((item) => AttendanceRecordModel.fromJson(item))
        .toList();

    // Get enrolled students for this course
    final enrolledResponse = await SupabaseService.from('course_enrollments')
        .select('''
          students(*, users(*))
        ''')
        .eq('course_id', session.courseId)
        .eq('status', 'active');

    final enrolledStudents = enrolledResponse
        .map((item) => StudentModel.fromJson(item['students']))
        .toList();

    // Calculate statistics
    final totalStudents = enrolledStudents.length;
    final presentCount = attendanceRecords.where((r) => r.status == AttendanceStatus.present).length;
    final lateCount = attendanceRecords.where((r) => r.status == AttendanceStatus.late).length;
    final absentCount = totalStudents - attendanceRecords.length;

    return SessionAttendanceData(
      session: session,
      attendanceRecords: attendanceRecords,
      enrolledStudents: enrolledStudents,
      totalStudents: totalStudents,
      presentCount: presentCount,
      lateCount: lateCount,
      absentCount: absentCount,
      attendanceRate: totalStudents > 0 ? ((presentCount + lateCount) / totalStudents * 100) : 0.0,
    );
  } catch (e) {
    throw Exception('Failed to load session attendance: $e');
  }
});

// Course attendance analytics provider
final courseAttendanceAnalyticsProvider = FutureProvider.family<CourseAttendanceAnalytics, String>((ref, courseId) async {
  try {
    // Get all sessions for this course
    final sessionsResponse = await SupabaseService.from('attendance_sessions')
        .select('*')
        .eq('course_id', courseId)
        .order('scheduled_start');

    final sessions = sessionsResponse
        .map((item) => AttendanceSessionModel.fromJson(item))
        .toList();

    // Get all attendance records for these sessions
    final sessionIds = sessions.map((s) => s.id).toList();
    final attendanceResponse = await SupabaseService.from('attendance_records')
        .select('''
          *,
          students(*, users(*))
        ''')
        .inFilter('session_id', sessionIds);

    final attendanceRecords = attendanceResponse
        .map((item) => AttendanceRecordModel.fromJson(item))
        .toList();

    // Get enrolled students
    final enrolledResponse = await SupabaseService.from('course_enrollments')
        .select('''
          students(*, users(*))
        ''')
        .eq('course_id', courseId)
        .eq('status', 'active');

    final enrolledStudents = enrolledResponse
        .map((item) => StudentModel.fromJson(item['students']))
        .toList();

    // Calculate analytics
    final totalSessions = sessions.length;
    final totalStudents = enrolledStudents.length;
    final totalPossibleAttendance = totalSessions * totalStudents;
    final totalActualAttendance = attendanceRecords.where((r) => 
        r.status == AttendanceStatus.present || r.status == AttendanceStatus.late).length;

    final overallAttendanceRate = totalPossibleAttendance > 0 
        ? (totalActualAttendance / totalPossibleAttendance * 100) 
        : 0.0;

    // Student attendance breakdown
    final studentAttendance = <String, StudentAttendanceStats>{};
    for (final student in enrolledStudents) {
      final studentRecords = attendanceRecords.where((r) => r.studentId == student.id).toList();
      final presentCount = studentRecords.where((r) => r.status == AttendanceStatus.present).length;
      final lateCount = studentRecords.where((r) => r.status == AttendanceStatus.late).length;
      final absentCount = totalSessions - studentRecords.length;
      
      studentAttendance[student.id as String] = StudentAttendanceStats(
        student: student,
        totalSessions: totalSessions,
        presentCount: presentCount,
        lateCount: lateCount,
        absentCount: absentCount,
        attendanceRate: totalSessions > 0 ? ((presentCount + lateCount) / totalSessions * 100) : 0.0,
      );
    }

    return CourseAttendanceAnalytics(
      courseId: courseId,
      totalSessions: totalSessions,
      totalStudents: totalStudents,
      overallAttendanceRate: overallAttendanceRate,
      studentAttendance: studentAttendance,
      sessions: sessions,
    );
  } catch (e) {
    throw Exception('Failed to load course analytics: $e');
  }
});

// Session creation provider
final sessionCreationProvider = StateNotifierProvider<SessionCreationNotifier, AsyncValue<void>>((ref) {
  return SessionCreationNotifier(ref);
});

class SessionCreationNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  SessionCreationNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> createSession({
    required String courseId,
    required String title,
    String? description,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    required  latitude,
    required  longitude,
     locationCoordinates,
    int geofenceRadius = 100,
  }) async {
    state = const AsyncValue.loading();

    try {
      final lecturer = await ref.read(currentLecturerProvider.future);

      await SupabaseService.from('attendance_sessions').insert({
        'course_id': courseId,
        'lecturer_id': lecturer.id,
        'title': title,
        'description': description,
        'scheduled_start': scheduledStart.toIso8601String(),
        'scheduled_end': scheduledEnd.toIso8601String(),
        'actual_start': DateTime.now().toIso8601String(), // Start immediately
        'status': 'active',
        'location_coordinates': {
          'latitude': locationCoordinates.latitude,
          'longitude': locationCoordinates.longitude,
        },
        'geofence_radius': geofenceRadius,
        'require_geofence': true,
        'require_face_recognition': true,
      });

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

// Session management provider
final sessionManagementProvider = StateNotifierProvider<SessionManagementNotifier, AsyncValue<void>>((ref) {
  return SessionManagementNotifier();
});

class SessionManagementNotifier extends StateNotifier<AsyncValue<void>> {
  SessionManagementNotifier() : super(const AsyncValue.data(null));

  Future<void> endSession(String sessionId) async {
    state = const AsyncValue.loading();

    try {
      await SupabaseService.from('attendance_sessions')
          .update({
            'status': 'ended',
            'actual_end': DateTime.now().toIso8601String(),
          })
          .eq('id', sessionId);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> cancelSession(String sessionId, String reason) async {
    state = const AsyncValue.loading();

    try {
      await SupabaseService.from('attendance_sessions')
          .update({
            'status': 'cancelled',
            'description': reason,
          })
          .eq('id', sessionId);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

// Attendance export provider
final attendanceExportProvider = StateNotifierProvider<AttendanceExportNotifier, AsyncValue<void>>((ref) {
  return AttendanceExportNotifier();
});

class AttendanceExportNotifier extends StateNotifier<AsyncValue<void>> {
  AttendanceExportNotifier() : super(const AsyncValue.data(null));

  Future<void> exportSessionAttendance(SessionAttendanceData data) async {
    state = const AsyncValue.loading();

    try {
      final csvData = [
        ['Student ID', 'Student Name', 'Email', 'Status', 'Time Marked', 'Location'],
        ...data.attendanceRecords.map((record) => [
          record.student?.matricule?? 'N/A',
          record.student?.user?.fullName ?? 'N/A',
          record.student?.user?.email ?? 'N/A',
          record.status.name,
          record.markedAt.toString(),
          record != null 
              ? '${record.locationLatitude}, ${record.locationLongitude}'
              : 'N/A',
        ]),
        // Add absent students
        ...data.enrolledStudents
            .where((student) => !data.attendanceRecords.any((r) => r.studentId == student.id))
            .map((student) => [
              student.matricule,
              student.user?.fullName ?? 'N/A',
              student.user?.email ?? 'N/A',
              'absent',
              'N/A',
              'N/A',
            ]),
      ];

      final csv = const ListToCsvConverter().convert(csvData);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/attendance_${data.session.title}_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csv);

      await Share.shareXFiles([XFile(file.path)], text: 'Attendance Report for ${data.session.title}');

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> exportCourseAttendance(CourseAttendanceAnalytics analytics) async {
    state = const AsyncValue.loading();

    try {
      final csvData = [
        ['Student ID', 'Student Name', 'Email', 'Total Sessions', 'Present', 'Late', 'Absent', 'Attendance Rate (%)'],
        ...analytics.studentAttendance.values.map((stats) => [
          stats.student.matricule,
          stats.student.user?.fullName ?? 'N/A',
          stats.student.user?.email ?? 'N/A',
          stats.totalSessions.toString(),
          stats.presentCount.toString(),
          stats.lateCount.toString(),
          stats.absentCount.toString(),
          stats.attendanceRate.toStringAsFixed(2),
        ]),
      ];

      final csv = const ListToCsvConverter().convert(csvData);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/course_attendance_${analytics.courseId}_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csv);

      await Share.shareXFiles([XFile(file.path)], text: 'Course Attendance Report');

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

// Data models
class LecturerStats {
  final int totalCourses;
  final int todaySessions;
  final int totalStudents;
  final double attendanceRate;

  LecturerStats({
    required this.totalCourses,
    required this.todaySessions,
    required this.totalStudents,
    required this.attendanceRate,
  });
}

class SessionAttendanceData {
  final AttendanceSessionModel session;
  final List<AttendanceRecordModel> attendanceRecords;
  final List<StudentModel> enrolledStudents;
  final int totalStudents;
  final int presentCount;
  final int lateCount;
  final int absentCount;
  final double attendanceRate;

  SessionAttendanceData({
    required this.session,
    required this.attendanceRecords,
    required this.enrolledStudents,
    required this.totalStudents,
    required this.presentCount,
    required this.lateCount,
    required this.absentCount,
    required this.attendanceRate,
  });
}

class CourseAttendanceAnalytics {
  final String courseId;
  final int totalSessions;
  final int totalStudents;
  final double overallAttendanceRate;
  final Map<String, StudentAttendanceStats> studentAttendance;
  final List<AttendanceSessionModel> sessions;

  CourseAttendanceAnalytics({
    required this.courseId,
    required this.totalSessions,
    required this.totalStudents,
    required this.overallAttendanceRate,
    required this.studentAttendance,
    required this.sessions,
  });
}

class StudentAttendanceStats {
  final StudentModel student;
  final int totalSessions;
  final int presentCount;
  final int lateCount;
  final int absentCount;
  final double attendanceRate;

  StudentAttendanceStats({
    required this.student,
    required this.totalSessions,
    required this.presentCount,
    required this.lateCount,
    required this.absentCount,
    required this.attendanceRate,
  });
}
