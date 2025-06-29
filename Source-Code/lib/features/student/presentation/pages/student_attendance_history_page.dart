import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth_service.dart';
import '../../data/providers/student_providers.dart';
import '../widgets/attendance_history_card.dart';

class StudentAttendanceHistoryPage extends ConsumerWidget {
  const StudentAttendanceHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final attendanceHistoryAsync = ref.watch(studentAttendanceHistoryProvider(user?.id ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: attendanceHistoryAsync.when(
        data: (attendanceRecords) {
          if (attendanceRecords.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No attendance records found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(studentAttendanceHistoryProvider(user?.id ?? ''));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: attendanceRecords.length,
              itemBuilder: (context, index) {
                final record = attendanceRecords[index];
                return AttendanceHistoryCard(record: record);
              },
            ),
          );
        },
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
                onPressed: () => ref.invalidate(studentAttendanceHistoryProvider(user?.id ?? '')),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
