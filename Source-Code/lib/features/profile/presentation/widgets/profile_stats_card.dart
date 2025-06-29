import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../student/data/providers/student_providers.dart';

class ProfileStatsCard extends ConsumerWidget {
  final String userId;

  const ProfileStatsCard({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(simplestudentStatsProvider(userId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Academic Statistics',
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
                        child: _StatCard(
                          title: 'Enrolled Courses',
                          value: stats.enrolledCourses.toString(),
                          icon: Icons.book,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Total Credits',
                          value: stats.totalCredits.toString(),
                          icon: Icons.school,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Attendance Rate',
                          value: '${stats.attendanceRate.toStringAsFixed(1)}%',
                          icon: Icons.check_circle,
                          color: stats.attendanceRate >= 75 ? Colors.green : Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Current GPA',
                          value: stats.currentGPA?.toStringAsFixed(2) ?? 'N/A',
                          icon: Icons.grade,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Error loading stats: $error'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
