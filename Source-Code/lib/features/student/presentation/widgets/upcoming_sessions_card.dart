import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/auth_service.dart';
import '../../data/providers/student_providers.dart';

class UpcomingSessionsCard extends ConsumerWidget {
  final String? studentId;

  const UpcomingSessionsCard({super.key, this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final effectiveStudentId = studentId ?? user?.id ?? '';
    final sessionsAsync = ref.watch(upcomingSessionsProvider(effectiveStudentId));

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
                      Icons.schedule,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Upcoming Sessions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.go('/student/sessions'),
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
                          SizedBox(height: 8),
                          Text('No upcoming sessions'),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: sessions.take(3).map((session) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(session.status.name).withOpacity(0.2),
                          child: Icon(
                            _getStatusIcon(session.status.name),
                            color: _getStatusColor(session.status.name),
                          ),
                        ),
                        title: Text(session.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(session.course?.title ?? 'Unknown Course'),
                            Text(
                              '${DateFormat('MMM dd, HH:mm').format(session.scheduledStart)} - ${DateFormat('HH:mm').format(session.scheduledEnd)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (session.locationName != null)
                              Text(
                                'Location: ${session.locationName}',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                          ],
                        ),
                        trailing: session.status.name == 'active'
                            ? ElevatedButton(
                                onPressed: () => context.go('/student/attendance/${session.id}'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Join'),
                              )
                            : Chip(
                                label: Text(
                                  session.status.name.toUpperCase(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                                backgroundColor: _getStatusColor(session.status.name).withOpacity(0.2),
                                labelStyle: TextStyle(color: _getStatusColor(session.status.name)),
                              ),
                        isThreeLine: true,
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
                      onPressed: () => ref.invalidate(upcomingSessionsProvider),
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
      case 'active':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'ended':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'active':
        return Icons.play_circle_filled;
      case 'scheduled':
        return Icons.schedule;
      case 'ended':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
