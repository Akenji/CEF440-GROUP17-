import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/lecturer_providers.dart';
import '../widgets/attendance_record_card.dart';
import '../widgets/attendance_stats_card.dart';

class SessionAttendancePage extends ConsumerWidget {
  final String sessionId;

  const SessionAttendancePage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(sessionAttendanceProvider(sessionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(sessionAttendanceProvider(sessionId)),
          ),
        ],
      ),
      body: attendanceAsync.when(
        data: (data) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(sessionAttendanceProvider(sessionId));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Session Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.session.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.session.course?.title ?? 'Unknown Course',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${_formatDateTime(data.session.scheduledStart)} - ${_formatDateTime(data.session.scheduledEnd)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        if (data.session.description != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            data.session.description!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Attendance Stats
                AttendanceStatsCard(data: data),
                const SizedBox(height: 16),

                // Export Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _exportAttendance(context, ref, data),
                    icon: const Icon(Icons.download),
                    label: const Text('Export Attendance'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Attendance Records
                Text(
                  'Attendance Records',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Present Students
                if (data.attendanceRecords.where((r) => r.status.name == 'present').isNotEmpty) ...[
                  _buildSectionHeader(context, 'Present (${data.presentCount})', Colors.green),
                  ...data.attendanceRecords
                      .where((r) => r.status.name == 'present')
                      .map((record) => AttendanceRecordCard(record: record)),
                  const SizedBox(height: 16),
                ],

                // Late Students
                if (data.attendanceRecords.where((r) => r.status.name == 'late').isNotEmpty) ...[
                  _buildSectionHeader(context, 'Late (${data.lateCount})', Colors.orange),
                  ...data.attendanceRecords
                      .where((r) => r.status.name == 'late')
                      .map((record) => AttendanceRecordCard(record: record)),
                  const SizedBox(height: 16),
                ],

                // Absent Students
                if (data.absentCount > 0) ...[
                  _buildSectionHeader(context, 'Absent (${data.absentCount})', Colors.red),
                  ...data.enrolledStudents
                      .where((student) => !data.attendanceRecords.any((r) => r.studentId == student.id))
                      .map((student) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            child: const Icon(Icons.person_off, color: Colors.red),
                          ),
                          title: Text(student.user?.fullName ?? 'Unknown'),
                          subtitle: Text(student.matricule as String),
                          trailing: const Chip(
                            label: Text('ABSENT'),
                            backgroundColor: Colors.red,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                ],
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(sessionAttendanceProvider(sessionId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportAttendance(BuildContext context, WidgetRef ref, SessionAttendanceData data) async {
    try {
      await ref.read(attendanceExportProvider.notifier).exportSessionAttendance(data);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Attendance exported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export attendance: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
