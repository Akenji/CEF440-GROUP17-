import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/app_colors.dart';

class MyAttendanceScreen extends StatefulWidget {
  const MyAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<MyAttendanceScreen> createState() => _MyAttendanceScreenState();
}

class _MyAttendanceScreenState extends State<MyAttendanceScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _bounceController;
  late AnimationController _zoomController;
  late AnimationController _shakeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _zoomAnimation;
  late Animation<double> _shakeAnimation;

  // Mock attendance data
  final List<Map<String, dynamic>> attendanceData = [
    {
      'courseId': 'CS201',
      'courseName': 'Database Systems',
      'date': '2025-05-20',
      'status': 'Present',
      'timestamp': DateTime(2025, 5, 20, 10, 0),
    },
    {
      'courseId': 'CS201',
      'courseName': 'Database Systems',
      'date': '2025-05-22',
      'status': 'Absent',
      'timestamp': DateTime(2025, 5, 22, 10, 0),
    },
    {
      'courseId': 'CS202',
      'courseName': 'Algorithms',
      'date': '2025-05-21',
      'status': 'Present',
      'timestamp': DateTime(2025, 5, 21, 12, 0),
    },
    {
      'courseId': 'CS203',
      'courseName': 'Operating Systems',
      'date': '2025-06-01',
      'status': 'Pending',
      'timestamp': DateTime(2025, 6, 1, 9, 0),
    },
  ];

  final List<Map<String, dynamic>> notifications = [
    {
      'message': 'Missed class for CS201 on 2025-05-22',
      'time': '2025-05-22 11:00 AM'
    },
    {'message': 'Attendance recorded for CS202', 'time': '2025-05-21 12:30 PM'},
  ];

  // Filter options
  String _selectedCourse = 'All';
  String _selectedStatus = 'All';
  DateTime _startDate = DateTime(2025, 5, 1);
  DateTime _endDate = DateTime(2025, 6, 30);
  bool _isCalendarView = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _isOnline = true;
  int _unreadNotifications = 2;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _startConnectivityMonitoring();
    _loadAttendanceData();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut),
    );

    _zoomAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOutQuad),
    );

    _shakeAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
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

  void _loadAttendanceData() {
    // Placeholder for Firebase or API call
    setState(() {});
  }

  void _toggleView() {
    setState(() {
      _isCalendarView = !_isCalendarView;
    });
    _zoomController.reset();
    _zoomController.forward();
  }

  void _applyFilters(
      String course, String status, DateTime start, DateTime end) {
    setState(() {
      _selectedCourse = course;
      _selectedStatus = status;
      _startDate = start;
      _endDate = end;
    });
    _shakeController.reset();
    _shakeController.forward().then((_) => _shakeController.reverse());
  }

  void _showFilterDialog() {
    final courses = ['All', 'CS201', 'CS202', 'CS203'];
    final statuses = ['All', 'Present', 'Absent', 'Pending'];
    String tempCourse = _selectedCourse;
    String tempStatus = _selectedStatus;
    DateTime tempStartDate = _startDate;
    DateTime tempEndDate = _endDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.formContainerBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Filter Attendance',
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: tempCourse,
                items: courses
                    .map((course) => DropdownMenuItem(
                          value: course,
                          child: Text(course),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    tempCourse = value!;
                  });
                },
                isExpanded: true,
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: tempStatus,
                items: statuses
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    tempStatus = value!;
                  });
                },
                isExpanded: true,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Start Date'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(tempStartDate)),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: tempStartDate,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2026),
                  );
                  if (date != null) {
                    setState(() {
                      tempStartDate = date;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('End Date'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(tempEndDate)),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: tempEndDate,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2026),
                  );
                  if (date != null) {
                    setState(() {
                      tempEndDate = date;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.errorAccent)),
          ),
          TextButton(
            onPressed: () {
              if (tempEndDate.isBefore(tempStartDate)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('End date cannot be before start date'),
                    backgroundColor: AppColors.errorAccent,
                  ),
                );
                return;
              }
              _applyFilters(tempCourse, tempStatus, tempStartDate, tempEndDate);
              Navigator.pop(context);
            },
            child: const Text('Apply',
                style: TextStyle(color: AppColors.primaryAccent)),
          ),
        ],
      ),
    );
  }

  Future<void> _exportAttendance() async {
    final filteredData = _getFilteredData();
    final csvHeader = 'Course,Date,Status,Timestamp\n';
    final csvRows = filteredData
        .map((record) =>
            '${record['courseName']},${record['date']},${record['status']},${DateFormat('yyyy-MM-dd HH:mm').format(record['timestamp'])}\n')
        .join();
    final csvContent = csvHeader + csvRows;

    final directory = await getTemporaryDirectory();
    final path =
        '${directory.path}/attendance_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);
    await file.writeAsString(csvContent);

    await Share.shareXFiles([XFile(path)], text: 'My Attendance Records');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attendance data exported successfully'),
        backgroundColor: AppColors.passwordStrengthStrong,
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredData() {
    return attendanceData.where((record) {
      final recordDate = DateTime.parse(record['date']);
      final matchesCourse =
          _selectedCourse == 'All' || record['courseId'] == _selectedCourse;
      final matchesStatus =
          _selectedStatus == 'All' || record['status'] == _selectedStatus;
      final matchesDate =
          recordDate.isAfter(_startDate.subtract(const Duration(days: 1))) &&
              recordDate.isBefore(_endDate.add(const Duration(days: 1)));
      return matchesCourse && matchesStatus && matchesDate;
    }).toList();
  }

  void _showNotifications() {
    setState(() {
      _unreadNotifications = 0;
    });
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.formContainerBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
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

  void _navigateToScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  void _navigateToAttendanceDetail(Map<String, dynamic> record) {
    Navigator.pushNamed(context, '/attendance_detail', arguments: {
      'attendanceRecord': record,
    });
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
                    color: AppColors.accentShadow.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 40,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'My Attendance',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isOnline ? Icons.wifi : Icons.wifi_off,
                color: _isOnline
                    ? AppColors.passwordStrengthStrong
                    : AppColors.errorAccent,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                _isOnline ? 'Online' : 'Offline',
                style: TextStyle(
                  fontSize: 12,
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

  Widget _buildSummaryCard() {
    final filteredData = _getFilteredData();
    final totalClasses = filteredData.length;
    final presentClasses =
        filteredData.where((r) => r['status'] == 'Present').length;
    final attendanceRate =
        totalClasses > 0 ? presentClasses / totalClasses : 0.0;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.formContainerBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.formContainerBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentShadow.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ZoomTransition(
                  animation: _zoomAnimation,
                  child: Column(
                    children: [
                      Text(
                        '${(attendanceRate * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.passwordStrengthStrong,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Attendance Rate',
                        style: TextStyle(
                            color: AppColors.secondaryText, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ZoomTransition(
                  animation: _zoomAnimation,
                  child: Column(
                    children: [
                      Text(
                        '${totalClasses - presentClasses}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.errorAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Missed Classes',
                        style: TextStyle(
                            color: AppColors.secondaryText, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterControls() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.formContainerBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.formContainerBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BounceTransition(
              animation: _bounceAnimation,
              child: ElevatedButton.icon(
                onPressed: _showFilterDialog,
                icon: const Icon(Icons.filter_alt, size: 18),
                label: const Text('Filter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: AppColors.primaryText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            BounceTransition(
              animation: _bounceAnimation,
              child: ElevatedButton.icon(
                onPressed: _exportAttendance,
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Export'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: AppColors.primaryText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            BounceTransition(
              animation: _bounceAnimation,
              child: IconButton(
                icon: RotationTransition(
                  turns: _rotateAnimation,
                  child: Icon(
                    _isCalendarView ? Icons.list : Icons.calendar_month,
                    color: AppColors.primaryAccent,
                  ),
                ),
                onPressed: _toggleView,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    final filteredData = _getFilteredData();
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: filteredData.isEmpty
            ? const Center(
                child: Text(
                  'No attendance records found',
                  style:
                      TextStyle(color: AppColors.secondaryText, fontSize: 16),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredData.length,
                itemBuilder: (context, index) => FadeInListItem(
                  child: GestureDetector(
                    onTap: () =>
                        _navigateToAttendanceDetail(filteredData[index]),
                    child: AttendanceCard(
                      courseName: filteredData[index]['courseName'],
                      date: filteredData[index]['date'],
                      status: filteredData[index]['status'],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildCalendarView() {
    final filteredData = _getFilteredData();

    // Build events map properly - declare it first, then populate
    final Map<DateTime, List<Map<String, dynamic>>> events = {};

    for (var record in filteredData) {
      final date = DateTime.parse(record['date']);
      final dateKey =
          DateTime(date.year, date.month, date.day); // Normalize to date only

      if (events[dateKey] == null) {
        events[dateKey] = [];
      }
      events[dateKey]!.add(record);
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.formContainerBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.formContainerBorder),
        ),
        child: AnimatedBuilder(
          animation: _zoomAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _zoomAnimation.value,
              child: TableCalendar<Map<String, dynamic>>(
                firstDay: DateTime(2025, 1, 1),
                lastDay: DateTime(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) {
                  final dateKey = DateTime(day.year, day.month, day.day);
                  return events[dateKey] ?? [];
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.primaryAccent.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: AppColors.errorAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            );
          },
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
                    const SizedBox(height: 90),
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildSummaryCard(),
                    _buildFilterControls(),
                    // _isCalendarView ? _buildCalendarView() : _buildListView(),
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
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                top: 12,
                right: 12,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: GestureDetector(
                    onTap: _showNotifications,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryAccent,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentShadow.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: AppColors.primaryText,
                            size: 22,
                          ),
                        ),
                        if (_unreadNotifications > 0)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.errorAccent,
                              ),
                              child: Text(
                                '$_unreadNotifications',
                                style: const TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 10,
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
            size: 26,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color:
                  isActive ? AppColors.primaryAccent : AppColors.secondaryText,
              fontSize: 11,
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
    _shakeController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

class AttendanceCard extends StatelessWidget {
  final String courseName;
  final String date;
  final String status;

  const AttendanceCard({
    Key? key,
    required this.courseName,
    required this.date,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.formContainerBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.formContainerBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentShadow.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                courseName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: status == 'Present'
                  ? AppColors.passwordStrengthStrong
                  : status == 'Absent'
                      ? AppColors.errorAccent
                      : AppColors.secondaryText,
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
      duration: const Duration(milliseconds: 500),
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
          offset: Offset(0, -8 * (1 - animation.value)),
          child: Transform.scale(
            scale: 1 + 0.08 * (1 - animation.value),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
