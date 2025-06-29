import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/auth_service.dart';
import '../widgets/course_enrollment_card.dart';
import '../widgets/enrolled_courses_card.dart';
import '../../data/providers/student_providers.dart';

class CourseEnrollmentPage extends ConsumerStatefulWidget {
  const CourseEnrollmentPage({super.key});

  @override
  ConsumerState<CourseEnrollmentPage> createState() => _CourseEnrollmentPageState();
}

class _CourseEnrollmentPageState extends ConsumerState<CourseEnrollmentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/student'),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Available Courses', icon: Icon(Icons.add_circle_outline)),
            Tab(text: 'My Courses', icon: Icon(Icons.book)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Available Courses Tab
          _AvailableCoursesTab(studentId: user?.id ?? ''),
          // Enrolled Courses Tab
          _EnrolledCoursesTab(studentId: user?.id ?? ''),
        ],
      ),
    );
  }
}

class _AvailableCoursesTab extends ConsumerWidget {
  final String studentId;

  const _AvailableCoursesTab({required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableCoursesAsync = ref.watch(availableCoursesForEnrollmentProvider(studentId));
    final enrollmentState = ref.watch(courseEnrollmentProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(availableCoursesForEnrollmentProvider(studentId));
      },
      child: availableCoursesAsync.when(
        data: (courses) {
          if (courses.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No courses available for enrollment',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'All courses for your level may already be enrolled',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseEnrollmentCard(
                course: course,
                onEnroll: () async {
                  await ref.read(courseEnrollmentProvider.notifier)
                      .enrollInCourse(studentId, course.id);
                  
                  if (context.mounted) {
                    enrollmentState.whenOrNull(
                      data: (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Successfully enrolled in ${course.title}'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        ref.invalidate(availableCoursesForEnrollmentProvider(studentId));
                        ref.invalidate(enrolledCoursesProvider(studentId));
                      },
                      error: (error, _) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to enroll: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    );
                  }
                },
                isLoading: enrollmentState.isLoading,
              );
            },
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
                onPressed: () => ref.invalidate(availableCoursesForEnrollmentProvider(studentId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnrolledCoursesTab extends ConsumerWidget {
  final String studentId;

  const _EnrolledCoursesTab({required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrolledCoursesAsync = ref.watch(enrolledCoursesProvider(studentId));
    final enrollmentState = ref.watch(courseEnrollmentProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(enrolledCoursesProvider(studentId));
      },
      child: enrolledCoursesAsync.when(
        data: (enrollments) {
          if (enrollments.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No courses enrolled yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Go to Available Courses to enroll',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: enrollments.length,
            itemBuilder: (context, index) {
              final enrollment = enrollments[index];
              final course = enrollment.course;
              
              if (course == null) return const SizedBox.shrink();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${course.code} • ${course.credits} Credits',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text(
                              enrollment.status.name.toUpperCase(),
                              style: const TextStyle(fontSize: 10),
                            ),
                            backgroundColor: _getStatusColor(enrollment.status.name).withOpacity(0.2),
                            labelStyle: TextStyle(color: _getStatusColor(enrollment.status.name)),
                          ),
                        ],
                      ),
                      if (course.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          course.description!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Enrolled: ${_formatDate(enrollment.enrolledAt as DateTime)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Spacer(),
                          if (enrollment.status.name == 'active')
                            TextButton.icon(
                              onPressed: enrollmentState.isLoading ? null : () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Drop Course'),
                                    content: Text('Are you sure you want to drop ${course.title}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Drop'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed == true) {
                                  await ref.read(courseEnrollmentProvider.notifier)
                                      .dropCourse(studentId, course.id);
                                  
                                  if (context.mounted) {
                                    enrollmentState.whenOrNull(
                                      data: (_) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Successfully dropped ${course.title}'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        ref.invalidate(enrolledCoursesProvider(studentId));
                                        ref.invalidate(availableCoursesForEnrollmentProvider(studentId));
                                      },
                                      error: (error, _) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Failed to drop course: $error'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.remove_circle_outline, size: 16),
                              label: const Text('Drop'),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
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
                onPressed: () => ref.invalidate(enrolledCoursesProvider(studentId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'dropped':
        return Colors.red;
      case 'suspended':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
