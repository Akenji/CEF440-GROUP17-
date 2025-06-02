import 'package:attendee/view/screens/course_detail.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:math' as math;

import '../../utils/app_colors.dart';

class StudentAnalyticsScreen extends StatefulWidget {
  const StudentAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<StudentAnalyticsScreen> createState() => _StudentAnalyticsScreenState();
}

class _StudentAnalyticsScreenState extends State<StudentAnalyticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _bounceController;
  late AnimationController _zoomController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _zoomAnimation;

  // Mock analytics data
  final Map<String, dynamic> analyticsData = {
    'overallGPA': 3.8,
    'attendanceRate': 0.92,
    'assignmentCompletion': 0.85,
    'courses': [
      {
        'courseId': 'CS101',
        'courseName': 'Internet Programming',
        'attendance': 0.90,
        'grade': 88,
        'progress': 0.75,
        'assignmentsCompleted': 8,
        'assignmentsTotal': 10,
      },
      {
        'courseId': 'CS102',
        'courseName': 'Mobile Programming',
        'attendance': 0.95,
        'grade': 85,
        'progress': 0.65,
        'assignmentsCompleted': 7,
        'assignmentsTotal': 9,
      },
      {
        'courseId': 'CS103',
        'courseName': 'Data Structures',
        'attendance': 0.88,
        'grade': 90,
        'progress': 0.80,
        'assignmentsCompleted': 6,
        'assignmentsTotal': 8,
      },
    ],
    'attendanceTrend': [
      {'week': 'Week 1', 'rate': 0.85},
      {'week': 'Week 2', 'rate': 0.90},
      {'week': 'Week 3', 'rate': 0.88},
      {'week': 'Week 4', 'rate': 0.92},
      {'week': 'Week 5', 'rate': 0.95},
    ],
    'gradeDistribution': [
      {'grade': 'A', 'count': 2},
      {'grade': 'B', 'count': 1},
      {'grade': 'C', 'count': 0},
    ],
  };

  final List<Map<String, dynamic>> notifications = [
    {
      'message': 'New grade posted for CS101: 88%',
      'time': '2025-06-02 09:00 AM'
    },
    {
      'message': 'Assignment due for CS102 tomorrow',
      'time': '2025-06-02 08:00 AM'
    },
  ];

  bool _isOnline = true;
  int _unreadNotifications = 2;
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
    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut),
    );

    _zoomAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOutQuad),
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
    _zoomController.forward();
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
              'Analytics Notifications',
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
                Icons.analytics_rounded,
                size: 45,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Academic Analytics',
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

  Widget _buildSummaryWidget() {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Summary',
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
                _buildSummaryItem(
                  'GPA',
                  analyticsData['overallGPA'].toString(),
                  Icons.star,
                ),
                _buildSummaryItem(
                  'Attendance',
                  '${(analyticsData['attendanceRate'] * 100).round()}%',
                  Icons.event_available,
                ),
                _buildSummaryItem(
                  'Assignments',
                  '${(analyticsData['assignmentCompletion'] * 100).round()}%',
                  Icons.assignment_turned_in,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return ZoomTransition(
      animation: _zoomAnimation,
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryAccent, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryAccent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTrendChart() {
    final trend =
        analyticsData['attendanceTrend'] as List<Map<String, dynamic>>;
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
              'Attendance Trend',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomAttendanceTrendWidget(
                data: trend,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeDistributionChart() {
    final distribution =
        analyticsData['gradeDistribution'] as List<Map<String, dynamic>>;
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
              'Grade Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomGradeDistributionWidget(
                data: distribution,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseAnalytics() {
    final courses = analyticsData['courses'] as List<Map<String, dynamic>>;
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
              'Course Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return FadeInListItem(
                  child: CourseAnalyticsCard(
                      courseName: course['courseName'],
                      attendance: course['attendance'],
                      grade: course['grade'],
                      progress: course['progress'],
                      assignmentsCompleted: course['assignmentsCompleted'],
                      assignmentsTotal: course['assignmentsTotal'],
                      onViewDetails: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CourseDetailScreen(courseId: "courseId")));
                      }),
                );
              },
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
                    _buildSummaryWidget(),
                    _buildAttendanceTrendChart(),
                    _buildGradeDistributionChart(),
                    _buildCourseAnalytics(),
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
                      _buildNavItem(Icons.analytics, 'Analytics', true, () {}),
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
    _zoomController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

// Custom widget for Attendance Trend (replacing LineChart)
class CustomAttendanceTrendWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CustomAttendanceTrendWidget({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double maxHeight = 150;
    const double barWidth = 40;
    final double spacing =
        (MediaQuery.of(context).size.width - 32 - (data.length * barWidth)) /
            (data.length + 1);

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(data.length, (index) {
              final rate = data[index]['rate'] as double;
              final height =
                  rate * maxHeight; // Scale height based on rate (0.0 to 1.0)
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: barWidth,
                    height: height,
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${(rate * 100).round()}%',
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data[index]['week'],
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Attendance Rate (%)',
          style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
        ),
      ],
    );
  }
}

// Custom widget for Grade Distribution (replacing PieChart)
class CustomGradeDistributionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CustomGradeDistributionWidget({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalCount =
        data.fold<double>(0, (sum, item) => sum + (item['count'] as int));
    if (totalCount == 0) {
      return const Center(
        child: Text(
          'No grades available',
          style: TextStyle(color: AppColors.secondaryText),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular segments for grades
              ...data
                  .asMap()
                  .entries
                  .where((entry) => entry.value['count'] > 0)
                  .map((entry) {
                final index = entry.key;
                final count = entry.value['count'] as int;
                final grade = entry.value['grade'] as String;
                final fraction = count / totalCount;
                return FractionallySizedBox(
                  widthFactor: 0.8,
                  heightFactor: 0.8,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: [
                        AppColors.primaryAccent,
                        AppColors.gradientAccentStart,
                        AppColors.gradientAccentEnd,
                      ][index % 3],
                    ),
                    child: Center(
                      child: Text(
                        '$grade\n${(fraction * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: data.map((item) {
            final count = item['count'] as int;
            if (count == 0) return const SizedBox.shrink();
            return Chip(
              label: Text(
                '${item['grade']}: $count',
                style: const TextStyle(color: AppColors.primaryText),
              ),
              backgroundColor: AppColors.formContainerBackground,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CourseAnalyticsCard extends StatelessWidget {
  final String courseName;
  final double attendance;
  final int grade;
  final double progress;
  final int assignmentsCompleted;
  final int assignmentsTotal;
  final VoidCallback onViewDetails;

  const CourseAnalyticsCard({
    Key? key,
    required this.courseName,
    required this.attendance,
    required this.grade,
    required this.progress,
    required this.assignmentsCompleted,
    required this.assignmentsTotal,
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
          Text(
            courseName,
            style: const TextStyle(
              fontSize: 18,
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
                    'Attendance: ${(attendance * 100).round()}%',
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Grade: $grade%',
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress: ${(progress * 100).round()}%',
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Assignments: $assignmentsCompleted/$assignmentsTotal',
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                ],
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onViewDetails,
              child: const Text(
                'View Details',
                style: TextStyle(color: AppColors.primaryAccent),
              ),
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

class ZoomTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const ZoomTransition({Key? key, required this.animation, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
      child: child,
    );
  }
}
