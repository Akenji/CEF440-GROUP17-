import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import '../../utils/app_colors.dart';

class CourseScheduleScreen extends StatefulWidget {
  const CourseScheduleScreen({Key? key}) : super(key: key);

  @override
  State<CourseScheduleScreen> createState() => _CourseScheduleScreenState();
}

class _CourseScheduleScreenState extends State<CourseScheduleScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _bounceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _bounceAnimation;

  // Mock data
  final List<Map<String, dynamic>> weeklySchedule = [
    {
      'date': DateTime(2025, 6, 2),
      'classes': [
        {
          'courseId': 'CS101',
          'courseName': 'Internet Programming',
          'time': '09:00 AM - 11:00 AM',
          'location': 'Room A101',
          'instructor': 'Dr. Smith',
          'status': 'Upcoming',
          'progress': 0.75,
        },
        {
          'courseId': 'CS102',
          'courseName': 'Mobile Programming',
          'time': '01:00 PM - 03:00 PM',
          'location': 'Room B204',
          'instructor': 'Prof. Jones',
          'status': 'Upcoming',
          'progress': 0.65,
        },
      ],
    },
    {
      'date': DateTime(2025, 6, 3),
      'classes': [
        {
          'courseId': 'CS103',
          'courseName': 'Data Structures',
          'time': '10:00 AM - 12:00 PM',
          'location': 'Room C301',
          'instructor': 'Dr. Brown',
          'status': 'Scheduled',
          'progress': 0.80,
        },
      ],
    },
    {
      'date': DateTime(2025, 6, 4),
      'classes': [
        {
          'courseId': 'CS104',
          'courseName': 'Algorithms',
          'time': '11:00 AM - 01:00 PM',
          'location': 'Room D402',
          'instructor': 'Prof. Wilson',
          'status': 'Scheduled',
          'progress': 0.70,
        },
      ],
    },
    {
      'date': DateTime(2025, 6, 5),
      'classes': [],
    },
    {
      'date': DateTime(2025, 6, 6),
      'classes': [
        {
          'courseId': 'CS105',
          'courseName': 'Database Systems',
          'time': '02:00 PM - 04:00 PM',
          'location': 'Room E505',
          'instructor': 'Dr. Taylor',
          'status': 'Scheduled',
          'progress': 0.85,
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> notifications = [
    {
      'message': 'Reminder: Internet Programming class at 9:00 AM',
      'time': '08:30 AM, Jun 2'
    },
    {
      'message': 'Data Structures assignment due tomorrow',
      'time': '2025-06-02'
    },
  ];

  DateTime _selectedDate = DateTime(2025, 6, 2);
  int _unreadNotifications = 2;
  bool _isOnline = true;
  String _upcomingClass = 'Internet Programming in 1h 30m';
  double _overallProgress = 0.75;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _startConnectivityMonitoring();
    _updateUpcomingClass();
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

  void _updateUpcomingClass() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(minutes: 1));
      setState(() {
        _upcomingClass = 'Internet Programming in 1h 29m'; // Mock update
      });
      return true;
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _bounceController.reset();
    _bounceController.forward();
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
              'Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
                letterSpacing: 0.5,
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
                Icons.schedule_rounded,
                size: 45,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Course Schedule',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
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

  Widget _buildCalendarView() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.formContainerBackground,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.formContainerBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowWithOpacity,
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weeklySchedule.map((day) {
            final isSelected = day['date'].day == _selectedDate.day &&
                day['date'].month == _selectedDate.month;
            return Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(day['date']),
                child: BounceTransition(
                  animation: _bounceAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryAccent.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('EEE').format(day['date']),
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? AppColors.primaryAccent
                                : AppColors.secondaryText,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.primaryAccent
                                : AppColors.divider,
                          ),
                          child: Center(
                            child: Text(
                              day['date'].day.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? AppColors.primaryText
                                    : AppColors.secondaryText,
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
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildScheduleList() {
    final selectedDay = weeklySchedule.firstWhere(
      (day) =>
          day['date'].day == _selectedDate.day &&
          day['date'].month == _selectedDate.month,
      orElse: () => {'date': _selectedDate, 'classes': []},
    );
    final classes = selectedDay['classes'] as List<Map<String, dynamic>>;

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
            Text(
              'Classes on ${DateFormat('MMM d').format(_selectedDate)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            classes.isEmpty
                ? const Center(
                    child: Text(
                      'No classes scheduled',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: classes.length,
                    itemBuilder: (context, index) {
                      final classData = classes[index];
                      return FadeInListItem(
                        child: ScheduleCard(
                          courseId: classData['courseId'],
                          courseName: classData['courseName'],
                          time: classData['time'],
                          location: classData['location'],
                          instructor: classData['instructor'],
                          status: classData['status'],
                          progress: classData['progress'],
                          onMarkAttendance: () => _navigateToScreen(
                            '/attendance_marking',
                            {
                              'courseId': classData['courseId'],
                              'courseName': classData['courseName'],
                              'classTime': classData['time'],
                              'requiredLatitude': 6.5244, // Mock coordinates
                              'requiredLongitude': 3.3792,
                              'allowedRadius': 100.0,
                            },
                          ),
                          onViewDetails: () => _navigateToScreen(
                            '/course_detail',
                            {'courseId': classData['courseId']},
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingClassWidget() {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Class',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _upcomingClass,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
            RotationTransition(
              turns: _rotateAnimation,
              child: const Icon(
                Icons.access_time,
                size: 40,
                color: AppColors.primaryAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressWidget() {
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
              'Overall Course Progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(_overallProgress * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This Semester',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  ],
                ),
                CircularProgressIndicator(
                  value: _overallProgress,
                  backgroundColor: AppColors.divider,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.primaryAccent),
                  strokeWidth: 8,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToScreen('/student_analytics'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: AppColors.primaryText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('View Analytics'),
            ),
          ],
        ),
      ),
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
                    _buildCalendarView(),
                    _buildUpcomingClassWidget(),
                    _buildProgressWidget(),
                    _buildScheduleList(),
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
                      _buildNavItem(Icons.schedule, 'Schedule', true, () {}),
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
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

class ScheduleCard extends StatelessWidget {
  final String courseId;
  final String courseName;
  final String time;
  final String location;
  final String instructor;
  final String status;
  final double progress;
  final VoidCallback onMarkAttendance;
  final VoidCallback onViewDetails;

  const ScheduleCard({
    Key? key,
    required this.courseId,
    required this.courseName,
    required this.time,
    required this.location,
    required this.instructor,
    required this.status,
    required this.progress,
    required this.onMarkAttendance,
    required this.onViewDetails,
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
                courseName,
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
                  color: status == 'Upcoming'
                      ? AppColors.passwordStrengthStrong
                      : AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time,
                  color: AppColors.primaryAccent, size: 16),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(color: AppColors.secondaryText),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on,
                  color: AppColors.primaryAccent, size: 16),
              const SizedBox(width: 8),
              Text(
                location,
                style: const TextStyle(color: AppColors.secondaryText),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person,
                  color: AppColors.primaryAccent, size: 16),
              const SizedBox(width: 8),
              Text(
                instructor,
                style: const TextStyle(color: AppColors.secondaryText),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryAccent),
            minHeight: 6,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: status == 'Upcoming' ? onMarkAttendance : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: AppColors.primaryText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Mark Attendance'),
              ),
              TextButton(
                onPressed: onViewDetails,
                child: const Text(
                  'Details',
                  style: TextStyle(color: AppColors.primaryAccent),
                ),
              ),
            ],
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
