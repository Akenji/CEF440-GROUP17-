import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/attendance_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/location_service.dart';
import '../widgets/lecturer_stats_card.dart';
import '../widgets/active_sessions_card.dart';
import '../widgets/course_list_card.dart';

import '../providers/lecturer_providers.dart';
import 'Lecturer_report_page.dart';

class LecturerDashboardPage extends ConsumerWidget {
  const LecturerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final lecturerAsync = ref.watch(currentLecturerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user?.fullName ?? 'Lecturer'}'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          // Notifications
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => context.go('/lecturer/notifications'),
          ),

          // Profile Menu
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user?.fullName?.substring(0, 1).toUpperCase() ?? 'L',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  context.go('/lecturer/profile');
                  break;
                case 'settings':
                  context.go('/lecturer/settings');
                  break;
                case 'logout':
                  _showLogoutDialog(context, ref);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Profile'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('Settings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Logout', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),

      body: lecturerAsync.when(
        data: (lecturer) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentLecturerProvider);
            ref.invalidate(lecturerStatsProvider);
            ref.invalidate(lecturerActiveSessionsProvider);
            ref.invalidate(lecturerCoursesProvider);
            // ref.invalidate(lecturerRecentActivityProvider);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good ${_getGreeting()}, ${user?.fullName?.split(' ').first ?? 'Lecturer'}!',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ready to manage your classes today?',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Actions
                const LecturerQuickActionsCard(),
                const SizedBox(height: 20),

                // Stats Cards
                LecturerStatsCard(lecturerId: lecturer.id),
                const SizedBox(height: 20),

                // Active Sessions
                ActiveSessionsCard(lecturerId: lecturer.id),
                const SizedBox(height: 20),

                // Course List
                CourseListCard(lecturerId: lecturer.id),
                const SizedBox(height: 20),

                // Recent Activity
                // RecentActivityCard(lecturerId: lecturer.id),
              ],
            ),
          ),
        ),
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading dashboard...'),
            ],
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading dashboard',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(currentLecturerProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button for Quick Session Creation
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateSessionDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Session'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      // Bottom Navigation for Quick Access
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(
              context,
              Icons.dashboard_outlined,
              'Dashboard',
              true,
              () {},
            ),
            _buildBottomNavItem(
              context,
              Icons.schedule_outlined,
              'Sessions',
              false,
              () => context.go('/lecturer/sessions'),
            ),
            _buildBottomNavItem(
              context,
              Icons.analytics_outlined,
              'Reports',
              false,
              () {
                final lecturer = ref.read(currentLecturerProvider).maybeWhen(
                  data: (lecturer) => lecturer,
                  orElse: () => null,
                );
                if (lecturer != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LecturerReportPage(lecturerId: lecturer.id),
                    ),
                  );
                }
              },
            ),
            _buildBottomNavItem(
              context,
              Icons.school_outlined,
              'Courses',
              false,
              () => context.go('/lecturer/courses'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[600],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  void _showCreateSessionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => CreateSessionDialog(ref: ref),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authServiceProvider.notifier).signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

// Quick Actions Card for Lecturer
class LecturerQuickActionsCard extends StatelessWidget {
  const LecturerQuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _QuickActionButton(
                  title: 'Start Session',
                  icon: Icons.play_circle_outline,
                  color: Colors.green,
                  onTap: () => context.go('/lecturer/sessions/create'),
                ),
                _QuickActionButton(
                  title: 'View Attendance',
                  icon: Icons.people_outline,
                  color: Colors.blue,
                  onTap: () => context.go('/lecturer/attendance'),
                ),
                _QuickActionButton(
                  title: 'Course Analytics',
                  icon: Icons.analytics_outlined,
                  color: Colors.orange,
                  onTap: () => context.go('/lecturer/analytics'),
                ),
                _QuickActionButton(
                  title: 'Export Data',
                  icon: Icons.download_outlined,
                  color: Colors.purple,
                  onTap: () => context.go('/lecturer/export'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Create Session Dialog (Enhanced)
class CreateSessionDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;

  const CreateSessionDialog({super.key, required this.ref});

  @override
  ConsumerState<CreateSessionDialog> createState() =>
      _CreateSessionDialogState();
}

class _CreateSessionDialogState extends ConsumerState<CreateSessionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCourseId;
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 2));
  bool _isCreating = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lecturerCoursesAsync = ref.watch(lecturerCoursesProvider);

    return AlertDialog(
      title: const Text('Create Attendance Session'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Course Selection
                lecturerCoursesAsync.when(
                  data: (courses) => DropdownButtonFormField<String>(
                    value: _selectedCourseId,
                    decoration: const InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    items: courses
                        .map((course) => DropdownMenuItem(
                              value: course.id,
                              child: Text('${course.code} - ${course.title}'),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCourseId = value),
                    validator: (value) =>
                        value == null ? 'Please select a course' : null,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (error, _) => Text('Error loading courses: $error'),
                ),
                const SizedBox(height: 16),

                // Session Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Session Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Time Selection
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Start Time'),
                        subtitle: Text(_formatDateTime(_startTime)),
                        leading: const Icon(Icons.access_time),
                        onTap: () => _selectDateTime(true),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ListTile(
                        title: const Text('End Time'),
                        subtitle: Text(_formatDateTime(_endTime)),
                        leading: const Icon(Icons.access_time_filled),
                        onTap: () => _selectDateTime(false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _isCreating ? null : _createSession,
          icon: _isCreating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add),
          label: Text(_isCreating ? 'Creating...' : 'Create & Start'),
        ),
      ],
    );
  }

  Future<void> _selectDateTime(bool isStartTime) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStartTime ? _startTime : _endTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(isStartTime ? _startTime : _endTime),
      );

      if (time != null) {
        final dateTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        setState(() {
          if (isStartTime) {
            _startTime = dateTime;
            if (_endTime.isBefore(_startTime)) {
              _endTime = _startTime.add(const Duration(hours: 2));
            }
          } else {
            _endTime = dateTime;
          }
        });
      }
    }
  }

  Future<void> _createSession() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreating = true);

    try {
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        throw Exception('Could not get current location. Please enable location services and grant permission.');
      }

      await ref.read(sessionCreationProvider.notifier).createSession(
        courseId: _selectedCourseId!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        scheduledStart: _startTime,
        scheduledEnd: _endTime,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session created and started successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to session management
        context.go('/lecturer/sessions');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create session: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
