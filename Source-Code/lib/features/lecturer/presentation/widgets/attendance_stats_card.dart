import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/lecturer_providers.dart';

class AttendanceStatsCard extends StatelessWidget {
  final SessionAttendanceData data;

  const AttendanceStatsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Total Students',
                    value: data.totalStudents.toString(),
                    color: Colors.blue,
                    icon: Icons.people,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Present',
                    value: data.presentCount.toString(),
                    color: Colors.green,
                    icon: Icons.check_circle,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Late',
                    value: data.lateCount.toString(),
                    color: Colors.orange,
                    icon: Icons.schedule,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Absent',
                    value: data.absentCount.toString(),
                    color: Colors.red,
                    icon: Icons.cancel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Attendance Rate
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attendance Rate',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${data.attendanceRate.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getAttendanceRateColor(data.attendanceRate),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: data.presentCount.toDouble(),
                          color: Colors.green,
                          title: '${data.presentCount}',
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: data.lateCount.toDouble(),
                          color: Colors.orange,
                          title: '${data.lateCount}',
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: data.absentCount.toDouble(),
                          color: Colors.red,
                          title: '${data.absentCount}',
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAttendanceRateColor(double rate) {
    if (rate >= 90) return Colors.green;
    if (rate >= 75) return Colors.orange;
    return Colors.red;
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
