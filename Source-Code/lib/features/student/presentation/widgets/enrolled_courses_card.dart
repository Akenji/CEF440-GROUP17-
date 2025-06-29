import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/auth_service.dart';
import '../../data/providers/student_providers.dart';

class EnrolledCoursesCard extends ConsumerWidget {
  final String? studentId;

  const EnrolledCoursesCard({super.key, this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final effectiveStudentId = studentId ?? user?.id ?? '';
    final coursesAsync = ref.watch(enrolledCoursesProvider(effectiveStudentId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.book,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Enrolled Courses',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.go('/student/courses'),
                  child: const Text('Manage'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            coursesAsync.when(
              data: (enrollments) {
                if (enrollments.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Icon(Icons.book_outlined, size: 48, color: Colors.grey),
                          const SizedBox(height: 8),
                          const Text('No courses enrolled yet'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => context.go('/student/courses'),
                            child: const Text('Enroll Now'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: enrollments.take(4).map((enrollment) {
                    final course = enrollment.course;
                    if (course == null) return const SizedBox.shrink();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          child: Text(
                            course.code.substring(0, 2).toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Text(course.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${course.code} • ${course.credits} Credits'),
                            Text('Level ${course.level} • Semester ${course.semester}'),
                            if (enrollment.grade != null)
                              Text('Grade: ${enrollment.grade}'),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'drop') {
                              _showDropCourseDialog(context, ref, effectiveStudentId, course.id, course.title);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'drop',
                              child: Row(
                                children: [
                                  Icon(Icons.remove_circle, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Drop Course'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(height: 8),
                    Text('Error: $error', style: const TextStyle(fontSize: 12)),
                    TextButton(
                      onPressed: () => ref.invalidate(enrolledCoursesProvider),
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

  void _showDropCourseDialog(BuildContext context, WidgetRef ref, String studentId, String courseId, String courseTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Drop Course'),
        content: Text('Are you sure you want to drop "$courseTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(courseEnrollmentProvider.notifier).dropCourse(studentId, courseId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dropped from $courseTitle'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to drop course: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Drop Course'),
          ),
        ],
      ),
    );
  }
}
