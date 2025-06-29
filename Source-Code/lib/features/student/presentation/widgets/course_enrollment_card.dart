import 'package:flutter/material.dart';
import '../../../../core/models/academic_model.dart';

class CourseEnrollmentCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onEnroll;
  final bool isLoading;

  const CourseEnrollmentCard({
    super.key,
    required this.course,
    required this.onEnroll,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final enrollmentProgress = course.currentEnrollment / course.maxEnrollment;
    final isNearlyFull = enrollmentProgress >= 0.8;
    final isFull = course.currentEnrollment >= course.maxEnrollment;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Header
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
                        '${course.code} • ${course.credits} Credits • Level ${course.level}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSemesterColor(course.semester).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Semester ${course.semester}',
                    style: TextStyle(
                      color: _getSemesterColor(course.semester),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Course Description
            if (course.description != null) ...[
              const SizedBox(height: 12),
              Text(
                course.description!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),

            // Department Info
            if (course.department != null) ...[
              Row(
                children: [
                  Icon(Icons.business, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    course.department!.name,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (course.department!.faculty != null) ...[
                    const Text(' • '),
                    Text(
                      course.department!.faculty!.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Enrollment Progress
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Enrollment',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${course.currentEnrollment}/${course.maxEnrollment}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isFull
                                          ? Colors.red
                                          : (isNearlyFull
                                              ? Colors.orange
                                              : Colors.green),
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: enrollmentProgress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isFull
                              ? Colors.red
                              : (isNearlyFull ? Colors.orange : Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: (isFull || isLoading) ? null : onEnroll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFull
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isFull ? 'Full' : 'Enroll'),
                ),
              ],
            ),

            // Prerequisites (if any)
            if (course.prerequisites.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber,
                        size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Prerequisites: ${course.prerequisites.join(', ')}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Course Dates (if available)
            if (course.courseStartDate != null &&
                course.courseEndDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${_formatDate(course.courseStartDate! as DateTime)} - ${_formatDate(course.courseEndDate! as DateTime)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSemesterColor(int semester) {
    switch (semester) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
