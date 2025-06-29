import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/auth_service.dart';
import '../widgets/student_stats_card.dart';
import '../widgets/upcoming_sessions_card.dart';
import '../widgets/recent_attendance_card.dart';
import '../widgets/enrolled_courses_card.dart';
import '../widgets/quick_actions_card.dart';
import '../../data/providers/student_providers.dart';

class StudentDashboardPage extends ConsumerWidget {
  const StudentDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final studentAsync = ref.watch(currentStudentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user?.fullName ?? 'Student'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.go('/student/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/student/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider.notifier).signOut(),
          ),
        ],
      ),
      body: studentAsync.when(
        data: (student) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentStudentProvider);
            // Invalidate studentStatsProvider with its argument (student.id)
            ref.invalidate(studentStatsProvider);
            ref.invalidate(upcomingSessionsProvider);
            ref.invalidate(recentAttendanceProvider);
            ref.invalidate(enrolledCoursesProvider);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Info Card
                Card(
                  elevation: 2, // Added elevation for consistent design
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Added rounded corners
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          child: Text(
                            student.user?.fullName.substring(0, 1).toUpperCase() ?? 'S',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // Ensure 'matricule' is not null, or provide a fallback string.
                                // It's often required, but a '??' can prevent runtime errors if it somehow is.
                                student.matricule ?? 'Unknown Matricule',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${student.department?.name ?? 'Unknown Department'} - Level ${student.level}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Academic Year: ${student.currentAcademicYear}',
                                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Stats Card
                // Ensure student.id is a non-nullable String before passing
                StudentStatsCard(studentId: student.id as String ),
                const SizedBox(height: 16),

                // Quick Actions
                QuickActionsCard(studentId: student.id as String),
                const SizedBox(height: 16),

                // Upcoming Sessions
                UpcomingSessionsCard(studentId: student.id),
                const SizedBox(height: 16),

                // Enrolled Courses
                EnrolledCoursesCard(studentId: student.id),
                const SizedBox(height: 16),

                // Recent Attendance
                RecentAttendanceCard(studentId: student.id),
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
                onPressed: () => ref.invalidate(currentStudentProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}