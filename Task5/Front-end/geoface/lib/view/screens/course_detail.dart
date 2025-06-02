import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import '../../utils/app_colors.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _bounceController;
  late AnimationController _flipController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _flipAnimation;

  // Mock course data
  final Map<String, dynamic> courseData = {
    'courseId': 'CS101',
    'courseName': 'Internet Programming',
    'credits': 3,
    'instructor': 'Dr. Smith',
    'instructorEmail': 'smith@university.edu',
    'room': 'A101',
    'time': 'Mon, Wed 09:00 AM - 11:00 AM',
    'progress': 0.75,
    'syllabus': [
      {
        'week': 1,
        'topic': 'Introduction to Web Technologies',
        'readings': 'Chapter 1'
      },
      {'week': 2, 'topic': 'HTML & CSS Basics', 'readings': 'Chapter 2'},
      {'week': 3, 'topic': 'JavaScript Fundamentals', 'readings': 'Chapter 3'},
    ],
    'attendance': [
      {'date': '2025-05-26', 'status': 'Present'},
      {'date': '2025-05-28', 'status': 'Present'},
      {'date': '2025-06-02', 'status': 'Pending'},
    ],
    'assignments': [
      {
        'id': 'A1',
        'title': 'HTML Portfolio',
        'dueDate': '2025-06-05',
        'status': 'Pending',
        'grade': null,
      },
      {
        'id': 'A2',
        'title': 'CSS Styling Project',
        'dueDate': '2025-06-12',
        'status': 'Submitted',
        'grade': 85,
      },
    ],
    'grades': {'midterm': 90, 'quizzes': 88, 'assignments': 85},
  };

  final List<Map<String, dynamic>> notifications = [
    {'message': 'Assignment A1 due in 3 days', 'time': '2025-06-02 08:00 AM'},
  ];

  int _selectedTab = 0;
  bool _isOnline = true;
  int _unreadNotifications = 1;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _startConnectivityMonitoring();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    _pulseController.repeat(reverse: true);
    _scaleController.forward();
    _rotateController.repeat();
    _bounceController.forward();
  }

  void _startConnectivityMonitoring() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      setState(() {
        _isOnline = !results.contains(ConnectivityResult.none);
      });
    });
  }

  void _selectTab(int index) {
    setState(() {
      _selectedTab = index;
    });
    _flipController.reset();
    _flipController.forward();
  }

  void _navigateToScreen(String route, [Map<String, dynamic>? args]) {
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _showNotifications() {
    setState(() {
      _unreadNotifications = 0;
    });
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.formContainerBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Course Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) => FadeInListItem(
                  child: ListTile(
                    leading: const Icon(Icons.notifications,
                        color: AppColors.primaryAccent),
                    title: Text(
                      notifications[index]['message'],
                      style: const TextStyle(color: AppColors.primaryText),
                    ),
                    subtitle: Text(
                      notifications[index]['time'],
                      style: const TextStyle(color: AppColors.secondaryText),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _contactInstructor() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email sent to ${courseData['instructorEmail']}'),
        backgroundColor: AppColors.passwordStrengthStrong,
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    AppColors.gradientAccentStart,
                    AppColors.gradientAccentEnd
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentShadow.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.book_rounded,
                size: 45,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            courseData['courseName'],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${courseData['credits']} Credits • ${courseData['instructor']}',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isOnline ? Icons.wifi : Icons.wifi_off,
                color: _isOnline
                    ? AppColors.passwordStrengthStrong
                    : AppColors.errorAccent,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _isOnline ? 'Online' : 'Offline',
                style: TextStyle(
                  fontSize: 14,
                  color: _isOnline
                      ? AppColors.passwordStrengthStrong
                      : AppColors.errorAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.formContainerBackground,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.formContainerBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Course Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.schedule,
                    color: AppColors.primaryAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  courseData['time'],
                  style: const TextStyle(color: AppColors.secondaryText),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on,
                    color: AppColors.primaryAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  courseData['room'],
                  style: const TextStyle(color: AppColors.secondaryText),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: courseData['progress'],
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryAccent),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '${(courseData['progress'] * 100).round()}% Complete',
              style: const TextStyle(color: AppColors.primaryAccent),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _navigateToScreen(
                    '/attendance_marking',
                    {
                      'courseId': courseData['courseId'],
                      'courseName': courseData['courseName'],
                      'classTime': courseData['time'].split(' ')[1],
                      'requiredLatitude': 6.5244, // Mock coordinates
                      'requiredLongitude': 3.3792,
                      'allowedRadius': 100.0,
                    },
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    foregroundColor: AppColors.primaryText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Mark Attendance'),
                ),
                OutlinedButton(
                  onPressed: _contactInstructor,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryAccent,
                    side: const BorderSide(color: AppColors.primaryAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Contact Instructor'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Syllabus', 'Attendance', 'Assignments', 'Grades'];
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.formContainerBackground,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.formContainerBorder),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = _selectedTab == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => _selectTab(index),
                child: BounceTransition(
                  animation: _bounceAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryAccent.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      tabs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected
                            ? AppColors.primaryAccent
                            : AppColors.secondaryText,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return FlipTransition(
      animation: _flipAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.formContainerBackground,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.formContainerBorder),
        ),
        child: _selectedTab == 0
            ? _buildSyllabusTab()
            : _selectedTab == 1
                ? _buildAttendanceTab()
                : _selectedTab == 2
                    ? _buildAssignmentsTab()
                    : _buildGradesTab(),
      ),
    );
  }

  Widget _buildSyllabusTab() {
    final syllabus = courseData['syllabus'] as List<Map<String, dynamic>>;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: syllabus.length,
      itemBuilder: (context, index) => FadeInListItem(
        child: ListTile(
          leading: const Icon(Icons.bookmark, color: AppColors.primaryAccent),
          title: Text(
            'Week ${syllabus[index]['week']}: ${syllabus[index]['topic']}',
            style: const TextStyle(color: AppColors.primaryText),
          ),
          subtitle: Text(
            'Readings: ${syllabus[index]['readings']}',
            style: const TextStyle(color: AppColors.secondaryText),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceTab() {
    final attendance = courseData['attendance'] as List<Map<String, dynamic>>;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attendance.length,
      itemBuilder: (context, index) => FadeInListItem(
        child: ListTile(
          leading: Icon(
            attendance[index]['status'] == 'Present'
                ? Icons.check_circle
                : Icons.pending,
            color: attendance[index]['status'] == 'Present'
                ? AppColors.passwordStrengthStrong
                : AppColors.secondaryText,
          ),
          title: Text(
            attendance[index]['date'],
            style: const TextStyle(color: AppColors.primaryText),
          ),
          subtitle: Text(
            attendance[index]['status'],
            style: TextStyle(
              color: attendance[index]['status'] == 'Present'
                  ? AppColors.passwordStrengthStrong
                  : AppColors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentsTab() {
    final assignments = courseData['assignments'] as List<Map<String, dynamic>>;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: assignments.length,
      itemBuilder: (context, index) => FadeInListItem(
        child: AssignmentCard(
          id: assignments[index]['id'],
          title: assignments[index]['title'],
          dueDate: assignments[index]['dueDate'],
          status: assignments[index]['status'],
          grade: assignments[index]['grade'],
          onSubmit: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Submitted ${assignments[index]['title']}'),
                backgroundColor: AppColors.passwordStrengthStrong,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGradesTab() {
    final grades = courseData['grades'] as Map<String, dynamic>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInListItem(
          child: ListTile(
            leading: const Icon(Icons.grade, color: AppColors.primaryAccent),
            title: const Text(
              'Midterm',
              style: TextStyle(color: AppColors.primaryText),
            ),
            trailing: Text(
              '${grades['midterm']}%',
              style: const TextStyle(
                color: AppColors.primaryAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        FadeInListItem(
          child: ListTile(
            leading: const Icon(Icons.quiz, color: AppColors.primaryAccent),
            title: const Text(
              'Quizzes',
              style: TextStyle(color: AppColors.primaryText),
            ),
            trailing: Text(
              '${grades['quizzes']}%',
              style: const TextStyle(
                color: AppColors.primaryAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        FadeInListItem(
          child: ListTile(
            leading:
                const Icon(Icons.assignment, color: AppColors.primaryAccent),
            title: const Text(
              'Assignments',
              style: TextStyle(color: AppColors.primaryText),
            ),
            trailing: Text(
              '${grades['assignments']}%',
              style: const TextStyle(
                color: AppColors.primaryAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundGradientStart,
              AppColors.backgroundGradientMid1,
              AppColors.backgroundGradientMid2,
              AppColors.backgroundGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 100),
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildCourseInfo(),
                    _buildTabBar(),
                    _buildTabContent(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.formContainerBackground,
                    border: Border(
                        top: BorderSide(color: AppColors.formContainerBorder)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.home, 'Home', false,
                          () => _navigateToScreen('/student_dashboard')),
                      _buildNavItem(Icons.schedule, 'Schedule', false,
                          () => _navigateToScreen('/course_schedule')),
                      _buildNavItem(Icons.analytics, 'Analytics', false,
                          () => _navigateToScreen('/student_analytics')),
                      _buildNavItem(Icons.person, 'Profile', false,
                          () => _navigateToScreen('/student_profile')),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: GestureDetector(
                    onTap: _showNotifications,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryAccent,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentShadow.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: AppColors.primaryText,
                            size: 24,
                          ),
                        ),
                        if (_unreadNotifications > 0)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.errorAccent,
                              ),
                              child: Text(
                                '$_unreadNotifications',
                                style: const TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primaryAccent : AppColors.secondaryText,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color:
                  isActive ? AppColors.primaryAccent : AppColors.secondaryText,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _bounceController.dispose();
    _flipController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

class AssignmentCard extends StatelessWidget {
  final String id;
  final String title;
  final String dueDate;
  final String status;
  final int? grade;
  final VoidCallback onSubmit;

  const AssignmentCard({
    Key? key,
    required this.id,
    required this.title,
    required this.dueDate,
    required this.status,
    required this.grade,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.formContainerBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.formContainerBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowWithOpacity,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 14,
                  color: status == 'Submitted'
                      ? AppColors.passwordStrengthStrong
                      : AppColors.errorAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Due: $dueDate',
            style: const TextStyle(color: AppColors.secondaryText),
          ),
          if (grade != null) ...[
            const SizedBox(height: 8),
            Text(
              'Grade: $grade%',
              style: const TextStyle(
                color: AppColors.primaryAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: status == 'Pending' ? onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: AppColors.primaryText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class FadeInListItem extends StatefulWidget {
  final Widget child;

  const FadeInListItem({Key? key, required this.child}) : super(key: key);

  @override
  _FadeInListItemState createState() => _FadeInListItemState();
}

class _FadeInListItemState extends State<FadeInListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FlipTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const FlipTransition({Key? key, required this.animation, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final angle = animation.value * 3.14159;
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}

class BounceTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const BounceTransition(
      {Key? key, required this.animation, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -10 * (1 - animation.value)),
          child: Transform.scale(
            scale: 1 + 0.1 * (1 - animation.value),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
