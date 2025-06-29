import 'package:flutter/material.dart';

import '../providers/lecturer_providers.dart';

class StudentAttendanceCard extends StatelessWidget {
  final StudentAttendanceStats stats;

  const StudentAttendanceCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getAttendanceColor(stats.attendanceRate).withOpacity(0.1),
                  child: Text(
                    stats.student.user?.fullName?.substring(0, 1).toUpperCase() ?? '?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getAttendanceColor(stats.attendanceRate),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stats.student.user?.fullName ?? 'Unknown Student',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        stats.student.id as String? ?? 'Unknown ID',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getAttendanceColor(stats.attendanceRate).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${stats.attendanceRate.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getAttendanceColor(stats.attendanceRate),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatChip(
                    label: 'Present',
                    value: stats.presentCount.toString(),
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatChip(
                    label: 'Late',
                    value: stats.lateCount.toString(),
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatChip(
                    label: 'Absent',
                    value: stats.absentCount.toString(),
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatChip(
                    label: 'Total',
                    value: stats.totalSessions.toString(),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAttendanceColor(double rate) {
    if (rate >= 90) return Colors.green;
    if (rate >= 75) return Colors.orange;
    return Colors.red;
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
