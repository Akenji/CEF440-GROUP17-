import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/attendance_model.dart';

class AttendanceRecordCard extends StatelessWidget {
  final AttendanceRecordModel record;

  const AttendanceRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(record.status).withOpacity(0.1),
          child: Icon(
            _getStatusIcon(record.status),
            color: _getStatusColor(record.status),
          ),
        ),
        title: Text(record.student?.user?.fullName ?? 'Unknown Student'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(record.student?.matricule ?? 'Unknown ID'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  DateFormat('HH:mm:ss').format(record.markedAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (record.locationLatitude != null) ...[
                  const SizedBox(width: 12),
                  Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Located',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                if (record.faceConfidence != null) ...[
                  const SizedBox(width: 12),
                  Icon(Icons.face, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${(record.faceConfidence! * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            record.status.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: _getStatusColor(record.status),
          labelStyle: const TextStyle(color: Colors.white),
        ),
        isThreeLine: true,
      ),
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.late:
        return Colors.orange;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.excused:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.late:
        return Icons.schedule;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.excused:
        return Icons.info;
    }
  }
}
