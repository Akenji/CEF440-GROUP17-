import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/auth_service.dart';
import '../../data/providers/student_providers.dart';

class RecentAttendanceCard extends ConsumerWidget {
  final String? studentId;

  const RecentAttendanceCard({super.key, this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final effectiveStudentId = studentId ?? user?.id ?? '';
    final attendanceAsync = ref.watch(recentAttendanceProvider(effectiveStudentId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Recent Attendance',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to attendance history
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            attendanceAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.event_note, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('No attendance records yet'),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: records.take(5).map((record) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getStatusColor(record.status.name).withOpacity(0.2),
                        child: Icon(
                          _getStatusIcon(record.status.name),
                          color: _getStatusColor(record.status.name),
                        ),
                      ),
                      title: Text(record.session?.title ?? 'Unknown Session'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(record.session?.course?.title ?? 'Unknown Course'),
                          Text(
                            DateFormat('MMM dd, yyyy - HH:mm').format(record.markedAt),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Chip(
                            label: Text(
                              record.status.name.toUpperCase(),
                              style: const TextStyle(fontSize: 10),
                            ),
                            backgroundColor: _getStatusColor(record.status.name).withOpacity(0.2),
                            labelStyle: TextStyle(color: _getStatusColor(record.status.name)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(height: 8),
                    Text('Error: $error', style: const TextStyle(fontSize: 12)),
                    TextButton(
                      onPressed: () => ref.invalidate(recentAttendanceProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'absent':
        return Colors.red;
      case 'excused':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'present':
        return Icons.check_circle;
      case 'late':
        return Icons.access_time;
      case 'absent':
        return Icons.cancel;
      case 'excused':
        return Icons.info;
      default:
        return Icons.help;
    }
  }
}
