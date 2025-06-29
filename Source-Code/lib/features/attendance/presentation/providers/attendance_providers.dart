import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/attendance_model.dart';
import '../../../../core/services/supabase_service.dart';

// Attendance session provider
final attendanceSessionProvider = FutureProvider.family<AttendanceSessionModel, String>((ref, sessionId) async {
  try {
    final response = await SupabaseService.from('attendance_sessions')
        .select('''
          *,
          courses(*),
          lecturers(*, users(*))
        ''')
        .eq('id', sessionId)
        .single();

    return AttendanceSessionModel.fromJson(response);
  } catch (e) {
    throw Exception('Failed to load session: $e');
  }
});

// Attendance submission provider
final attendanceSubmissionProvider = StateNotifierProvider<AttendanceSubmissionNotifier, AsyncValue<void>>((ref) {
  return AttendanceSubmissionNotifier();
});

class AttendanceSubmissionNotifier extends StateNotifier<AsyncValue<void>> {
  AttendanceSubmissionNotifier() : super(const AsyncValue.data(null));

  Future<void> submitAttendance({
    required String sessionId,
    required String studentId,
     location,
    double? faceConfidence,
    String? faceImageUrl,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      // Check if already submitted
      final existing = await SupabaseService.from('attendance_records')
          .select('id')
          .eq('session_id', sessionId)
          .eq('student_id', studentId)
          .maybeSingle();

      if (existing != null) {
        throw Exception('Attendance already submitted for this session');
      }

      // Determine attendance status based on time
      final session = await SupabaseService.from('attendance_sessions')
          .select('scheduled_start, late_threshold_minutes')
          .eq('id', sessionId)
          .single();

      final scheduledStart = DateTime.parse(session['scheduled_start']);
      final lateThreshold = session['late_threshold_minutes'] as int;
      final now = DateTime.now();
      
      AttendanceStatus status;
      if (now.isBefore(scheduledStart.add(Duration(minutes: lateThreshold)))) {
        status = AttendanceStatus.present;
      } else {
        status = AttendanceStatus.late;
      }

      // Submit attendance record
      await SupabaseService.from('attendance_records').insert({
        'session_id': sessionId,
        'student_id': studentId,
        'status': status.name,
        'marked_at': now.toIso8601String(),
        'location_coordinates': location != null ? {
          'latitude': location.latitude,
          'longitude': location.longitude,
        } : null,
        'face_confidence': faceConfidence,
        'face_image_url': faceImageUrl,
        'verification_method': 'face_location',
      });

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}
