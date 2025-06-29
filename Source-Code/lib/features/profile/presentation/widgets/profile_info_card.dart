import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_model.dart';
import '../../../student/data/providers/student_providers.dart';

class ProfileInfoCard extends ConsumerWidget {
  final UserModel user;

  const ProfileInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Basic Info
            _InfoRow(
              icon: Icons.person,
              label: 'Full Name',
              value: user.fullName,
            ),
            _InfoRow(
              icon: Icons.email,
              label: 'Email',
              value: user.email,
            ),
            if (user.phone != null)
              _InfoRow(
                icon: Icons.phone,
                label: 'Phone',
                value: user.phone!,
              ),
            _InfoRow(
              icon: Icons.calendar_today,
              label: 'Member Since',
              value: _formatDate(user.createdAt),
            ),
            
            // Role-specific information
            if (user.role == UserRole.student)
              _StudentInfo(userId: user.id),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentInfo extends ConsumerWidget {
  final String userId;

  const _StudentInfo({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentProfileAsync = ref.watch(studentProfileProvider(userId));

    return studentProfileAsync.when(
      data: (student) {
        if (student == null) return const SizedBox.shrink();
        
        return Column(
          children: [
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Academic Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.badge,
              label: 'Matricule',
              value: student.matricule as String? ?? 'Unknown',
            ),
            if (student.department != null) ...[
              _InfoRow(
                icon: Icons.business,
                label: 'Department',
                value: student.department!.name,
              ),
              if (student.department!.faculty != null)
                _InfoRow(
                  icon: Icons.account_balance,
                  label: 'Faculty',
                  value: student.department!.faculty!.name,
                ),
            ],
            _InfoRow(
              icon: Icons.stairs,
              label: 'Level',
              value: '${student.level} Level',
            ),
            _InfoRow(
              icon: Icons.calendar_today,
              label: 'Admission Year',
              value: student.admissionYear.toString(),
            ),
            _InfoRow(
              icon: Icons.school,
              label: 'Current Semester',
              value: 'Semester ${student.currentSemester}',
            ),
            _InfoRow(
              icon: Icons.date_range,
              label: 'Academic Year',
              value: student.currentAcademicYear,
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Error loading student info: $error'),
    );
  }
}
