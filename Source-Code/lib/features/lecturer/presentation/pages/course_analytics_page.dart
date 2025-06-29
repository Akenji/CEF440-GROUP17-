import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/lecturer_providers.dart';
import '../widgets/student_attendance_card.dart';

class CourseAnalyticsPage extends ConsumerWidget {
  final String courseId;

  const CourseAnalyticsPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(courseAttendanceAnalyticsProvider(courseId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportAnalytics(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(courseAttendanceAnalyticsProvider(courseId)),
          ),
        ],
      ),
      body: analyticsAsync.when(
        data: (analytics) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(courseAttendanceAnalyticsProvider(courseId));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall Stats Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Course Overview',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _OverviewItem(
                                label: 'Total Sessions',
                                value: analytics.totalSessions.toString(),
                                icon: Icons.event,
                                color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              child: _OverviewItem(
                                label: 'Total Students',
                                value: analytics.totalStudents.toString(),
                                icon: Icons.people,
                                color: Colors.green,
                              ),
                            ),
                            Expanded(
                              child: _OverviewItem(
                                label: 'Overall Rate',
                                value: '${analytics.overallAttendanceRate.toStringAsFixed(1)}%',
                                icon: Icons.trending_up,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Attendance Trend Chart
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendance Trend',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: true),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text('${value.toInt()}%');
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      if (value.toInt() < analytics.sessions.length) {
                                        return Text('S${value.toInt() + 1}');
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: true),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _generateAttendanceTrendData(analytics),
                                  isCurved: true,
                                  color: Colors.blue,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Student Performance
                Text(
                  'Student Performance',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Sort students by attendance rate
                ...(
                  analytics.studentAttendance.values
                      .toList()
                        ..sort((a, b) => b.attendanceRate.compareTo(a.attendanceRate))
                  ).map((stats) => StudentAttendanceCard(stats: stats)).toList(),
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
                onPressed: () => ref.invalidate(courseAttendanceAnalyticsProvider(courseId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> _generateAttendanceTrendData(CourseAttendanceAnalytics analytics) {
    // This is a simplified version - you might want to calculate actual session-by-session rates
    final spots = <FlSpot>[];
    for (int i = 0; i < analytics.sessions.length && i < 10; i++) {
      // Mock data for demonstration - replace with actual calculation
      final rate = 75 + (i * 2) + (i % 3 * 5);
      spots.add(FlSpot(i.toDouble(), rate.toDouble()));
    }
    return spots;
  }

  Future<void> _exportAnalytics(BuildContext context, WidgetRef ref) async {
    final analytics = await ref.read(courseAttendanceAnalyticsProvider(courseId).future);
    
    try {
      await ref.read(attendanceExportProvider.notifier).exportCourseAttendance(analytics);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Analytics exported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export analytics: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _OverviewItem({
    required this.label,
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
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
