import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/attendance_model.dart';
import '../providers/lecturer_providers.dart';

class ActiveSessionsCard extends ConsumerWidget {
  final String lecturerId;

  const ActiveSessionsCard({super.key, required this.lecturerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(lecturerActiveSessionsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Sessions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () => context.go('/lecturer/sessions'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            sessionsAsync.when(
              data: (sessions) {
                if (sessions.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.event_busy, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No active sessions'),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: sessions
                      .take(3)
                      .map(
                          (session) => _SessionItem(session: session, ref: ref))
                      .toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Center(
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(height: 8),
                    Text('Error: $error'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(lecturerActiveSessionsProvider),
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
}

class _SessionItem extends StatelessWidget {
  final AttendanceSessionModel session;
  final WidgetRef ref;

  const _SessionItem({required this.session, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.course?.title ?? 'Unknown Course',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(session.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  session.status.name.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(session.status),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${_formatTime(session.scheduledStart)} - ${_formatTime(session.scheduledEnd)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const Spacer(),
              if (session.status == SessionStatus.active)
                ElevatedButton(
                  onPressed: () => _endSession(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(80, 32),
                  ),
                  child: const Text('End', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(SessionStatus status) {
    switch (status) {
      case SessionStatus.active:
        return Colors.green;
      case SessionStatus.scheduled:
        return Colors.blue;
      case SessionStatus.ended:
        return Colors.grey;
      case SessionStatus.cancelled:
        return Colors.red;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _endSession(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session'),
        content: const Text('Are you sure you want to end this session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('End Session'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref
            .read(sessionManagementProvider.notifier)
            .endSession(session.id);
        ref.invalidate(lecturerActiveSessionsProvider);
        ref.invalidate(lecturerStatsProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session ended successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to end session: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
