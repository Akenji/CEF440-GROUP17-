import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Assuming student_providers.dart contains the definition for studentStatsProvider
import '../../data/providers/student_providers.dart';

class StudentStatsCard extends ConsumerWidget {
  final String studentId;

  const StudentStatsCard({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Correctly watch the provider by passing the studentId as an argument
    // This will return an AsyncValue<StudentStats>
    final statsAsync = ref.watch(studentStatsProvider);

    return Card(
      elevation: 2, // Added elevation for better visual
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)), // Added rounded corners
      margin: const EdgeInsets.symmetric(vertical: 8), // Added margin
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            statsAsync.when(
              data: (stats) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          icon: Icons.book,
                          label: 'Enrolled Courses',
                          value: stats.enrolledCourses.toString(),
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatItem(
                          icon: Icons.today,
                          label: 'Today\'s Sessions',
                          value: stats.todaySessions.toString(),
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          icon: Icons.trending_up,
                          label: 'Attendance Rate',
                          value: '${stats.attendanceRate.toStringAsFixed(1)}%',
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatItem(
                          icon: Icons.event,
                          label: 'Total Sessions',
                          value: stats.totalSessions.toString(),
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center content vertically
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 40), // Increased size
                    const SizedBox(height: 8),
                    Text(
                      'Error loading stats: ${error.toString()}', // More descriptive message
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(
                          studentStatsProvider), // Invalidate with argument
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

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}
