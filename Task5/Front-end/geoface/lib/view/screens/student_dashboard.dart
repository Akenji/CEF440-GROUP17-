import 'package:attendee/view/screens/attendance_detail.dart';
import 'package:attendee/view/screens/attendance_marking%20_screen.dart';
import 'package:attendee/view/screens/course_detail.dart';
import 'package:attendee/view/screens/my_attendance_screen.dart';
import 'package:attendee/view/screens/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/app_colors.dart';
import 'student_analytics.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  // Mock data
  final String studentName = 'Faith Sirri';
  final List<Map<String, dynamic>> todaySchedule = [
    {
      'course': 'Internet Programming',
      'time': '09:00 AM - 11:00 AM',
      'location': 'Room A101',
      'status': 'Upcoming',
    },
    {
      'course': 'Mobile Programming',
      'time': '01:00 PM - 03:00 PM',
      'location': 'Room B204',
      'status': 'Upcoming',
    },
  ];
  final List<Map<String, dynamic>> recentAttendance = [
    {
      'course': 'Data Structures',
      'date': '2025-06-01',
      'status': 'Present',
      'time': '10:00 AM',
    },
    {
      'course': 'Algorithms',
      'date': '2025-05-31',
      'status': 'Absent',
      'time': '02:00 PM',
    },
    {
      'course': 'Database Systems',
      'date': '2025-05-30',
      'status': 'Late',
      'time': '11:00 AM',
    },
  ];
  final List<Map<String, dynamic>> notifications = [
    {
      'message': 'Class reminder: Internet Programming at 9:00 AM',
      'time': '08:30 AM'
    },
    {
      'message': 'Attendance confirmed for Data Structures',
      'time': '2025-06-01'
    },
  ];

  final Map<String, dynamic> attendanceRecord = {'name': "ndi"};

  int _unreadNotifications = 2;
  bool _isOnline = true;
  double _weeklyAttendance = 85.5;
  String _nextClassCountdown = '1h 45m';
  String _currentClassStatus = 'No ongoing class';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _simulateNetworkStatus();
    _updateCountdown();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      _slideController.forward();
    });
    _pulseController.repeat(reverse: true);
    _scaleController.forward();
    _rotateController.repeat();
  }

  void _simulateNetworkStatus() {
    // Simulate network changes
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isOnline = !_isOnline;
        });
        _simulateNetworkStatus();
      }
    });
  }

  void _updateCountdown() {
    // Simulate countdown to next class
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 60));
      setState(() {
        _nextClassCountdown = '1h 44m'; // Mock update
      });
      return true;
    });
  }

  void _navigateToScreen(Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
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
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) => ListTile(
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
              width: 80,
              height: 80,
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
                    color: AppColors.accentShadow,
                    blurRadius: 25,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 40,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome, $studentName!',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
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

  Widget _buildQuickAttendanceCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.formContainerBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowWithOpacity,
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Attendance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentClassStatus,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 5, 4, 4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _navigateToScreen(
                            AttendanceMarkingScreen(
                                courseId: 'courseId',
                                courseName: 'courseName',
                                classTime: 'classTime',
                                requiredLatitude: 55,
                                requiredLongitude: 777)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Mark Attendance'),
                      ),
                    ],
                  ),
                  RotationTransition(
                    turns: _rotateAnimation,
                    child: Icon(
                      Icons.face_retouching_natural,
                      size: 50,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleWidget() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.formContainerBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(19, 3, 46, 1),
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todaySchedule.length,
              itemBuilder: (context, index) {
                final schedule = todaySchedule[index];
                return FadeInListItem(
                  child: ListTile(
                    leading:
                        const Icon(Icons.event, color: AppColors.primaryAccent),
                    title: Text(
                      schedule['course'],
                      style: const TextStyle(color: AppColors.primaryText),
                    ),
                    subtitle: Text(
                      '${schedule['time']} • ${schedule['location']}',
                      style: const TextStyle(color: AppColors.secondaryText),
                    ),
                    trailing: Text(
                      schedule['status'],
                      style: TextStyle(
                        color: schedule['status'] == 'Upcoming'
                            ? AppColors.cardColor
                            : AppColors.errorAccent,
                      ),
                    ),
                    onTap: () => _navigateToScreen(
                        CourseDetailScreen(courseId: 'courseId')),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceSummaryWidget() {
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
              'Weekly Attendance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_weeklyAttendance%',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This Week',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  ],
                ),
                CircularProgressIndicator(
                  value: _weeklyAttendance / 100,
                  backgroundColor: AppColors.divider,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.primaryAccent),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToScreen(MyAttendanceScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: AppColors.primaryText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAttendanceWidget() {
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
              'Recent Attendance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentAttendance.length,
              itemBuilder: (context, index) {
                final record = recentAttendance[index];
                return FadeInListItem(
                    child: ListTile(
                  leading: Icon(
                    record['status'] == 'Present'
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: record['status'] == 'Present'
                        ? AppColors.passwordStrengthStrong
                        : AppColors.errorAccent,
                  ),
                  title: Text(
                    record['course'],
                    style: const TextStyle(color: AppColors.primaryText),
                  ),
                  subtitle: Text(
                    '${record['date']} • ${record['time']}',
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                  trailing: Text(
                    record['status'],
                    style: TextStyle(
                      color: record['status'] == 'Present'
                          ? AppColors.passwordStrengthStrong
                          : AppColors.errorAccent,
                    ),
                  ),
                  onTap: () => _navigateToScreen(
                    AttendanceDetailScreen(
                      attendanceRecord: attendanceRecord,
                    ),
                  ),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextClassWidget() {
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
              'Next Class',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todaySchedule.isNotEmpty
                          ? todaySchedule[0]['course']
                          : 'No upcoming class',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'In $_nextClassCountdown',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.access_time,
                  size: 40,
                  color: AppColors.primaryAccent,
                ),
              ],
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
              Color.fromARGB(255, 65, 96, 182),
              Color.fromARGB(255, 84, 196, 211),
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
                    _buildQuickAttendanceCard(),
                    _buildScheduleWidget(),
                    _buildAttendanceSummaryWidget(),
                    _buildNextClassWidget(),
                    _buildRecentAttendanceWidget(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              // Navigation Bar
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
                      _buildNavItem(Icons.home, 'Home', true, () {}),
                      _buildNavItem(
                          Icons.schedule,
                          'Schedule',
                          false,
                          () => _navigateToScreen(
                              CourseDetailScreen(courseId: "courseId"))),
                      _buildNavItem(Icons.analytics, 'Analytics', false,
                          () => _navigateToScreen(StudentAnalyticsScreen())),
                      _buildNavItem(Icons.person, 'Profile', false,
                          () => _navigateToScreen(StudentProfileScreen())),
                    ],
                  ),
                ),
              ),
              // Notification Bell
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
                                color: AppColors.accentShadow,
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
    super.dispose();
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
