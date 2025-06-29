import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lecturer_providers.dart';

class LecturerReportPage extends ConsumerWidget {
  final String lecturerId;

  const LecturerReportPage({super.key, required this.lecturerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(lecturerStatsProvider);
    final sessionsAsync = ref.watch(lecturerSessionsProvider);
    final coursesAsync = ref.watch(lecturerCoursesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecturer Analytics & Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export as PDF',
            onPressed: () {
              // TODO: Implement PDF export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF export coming soon!')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(lecturerStatsProvider);
          ref.invalidate(lecturerSessionsProvider);
          ref.invalidate(lecturerCoursesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Sophisticated Stats Overview
            statsAsync.when(
              data: (stats) => _StatsOverview(stats: stats),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error loading stats: $e'),
            ),
            const SizedBox(height: 24),

            // Attendance Trend Chart Placeholder
            Text('Attendance Trend', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _AttendanceTrendChartPlaceholder(),
            const SizedBox(height: 24),

            // Recent Sessions Table
            Text('Recent Sessions', style: Theme.of(context).textTheme.titleMedium),
            sessionsAsync.when(
              data: (sessions) => Card(
                elevation: 2,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Course')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Attendance')),
                  ],
                  rows: sessions.take(5).map((session) {
                    return DataRow(cells: [
                      DataCell(Text(session.createdAt as String)),
                      DataCell(Text(session.course?.title ?? '-')),
                      DataCell(Text(session.status as String)),
                      DataCell(Text('${session.attendanceRecords!.length}/${session.attendanceRecords!.length}')),
                    ]);
                  }).toList(),
                ),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Error loading sessions: $e'),
            ),
            const SizedBox(height: 24),

            // Courses List with Progress Bars
            Text('Courses & Enrollment', style: Theme.of(context).textTheme.titleMedium),
            coursesAsync.when(
              data: (courses) => Column(
                children: courses.map((course) {
                  final percent = course.maxEnrollment > 0
                      ? (course.currentEnrollment / course.maxEnrollment).clamp(0, 1.0)
                      : 0.0;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('${course.code} - ${course.title}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Enrolled: ${course.currentEnrollment}/${course.maxEnrollment}'),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: percent as double,
                            minHeight: 6,
                            backgroundColor: Colors.grey[200],
                            color: percent > 0.8
                                ? Colors.red
                                : percent > 0.5
                                    ? Colors.orange
                                    : Colors.green,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: 'View Course Details',
                        onPressed: () {
                          // TODO: Navigate to course details
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Error loading courses: $e'),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: () {
                    ref.invalidate(lecturerStatsProvider);
                    ref.invalidate(lecturerSessionsProvider);
                    ref.invalidate(lecturerCoursesProvider);
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.bar_chart),
                  label: const Text('Detailed Analytics'),
                  onPressed: () {
                    // TODO: Navigate to detailed analytics page
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsOverview extends StatelessWidget {
  final dynamic stats;
  const _StatsOverview({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatTile(
              icon: Icons.book,
              label: 'Courses',
              value: stats.totalCourses.toString(),
              color: Colors.blue,
            ),
            _StatTile(
              icon: Icons.event,
              label: 'Sessions',
              value: stats.todaySessions.toString(),
              color: Colors.green,
            ),
            _StatTile(
              icon: Icons.people,
              label: 'Students',
              value: stats.totalStudents.toString(),
              color: Colors.orange,
            ),
            _StatTile(
              icon: Icons.check_circle,
              label: 'Attendance',
              value: '${stats.attendanceRate.toStringAsFixed(1)}%',
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}

class _AttendanceTrendChartPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace with a real chart widget (e.g. charts_flutter, fl_chart) as needed
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey[100]!),
      ),
      child: const Center(
        child: Text('Attendance trend chart coming soon!', style: TextStyle(color: Colors.blueGrey)),
      ),
    );
  }
}