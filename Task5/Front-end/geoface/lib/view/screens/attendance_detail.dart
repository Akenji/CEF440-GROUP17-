import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'dart:math' as math;

import '../../utils/app_colors.dart';

class AttendanceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> attendanceRecord;

  const AttendanceDetailScreen({Key? key, required this.attendanceRecord})
      : super(key: key);

  @override
  State<AttendanceDetailScreen> createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen>
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

  // Mock attendance details (extended from passed record)
  late Map<String, dynamic> attendanceDetails;
  final List<Map<String, dynamic>> notifications = [
    {
      'message': 'Appeal submitted for CS101 on 2025-05-28',
      'time': '2025-06-02 09:00 AM'
    },
    {'message': 'Attendance verified for CS101', 'time': '2025-05-26 10:00 AM'},
  ];

  final TextEditingController _appealReasonController = TextEditingController();
  final GlobalKey<FormState> _appealFormKey = GlobalKey<FormState>();

  bool _isOnline = true;
  int _unreadNotifications = 2;
  bool _isAppealing = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeAttendanceDetails();
    _initializeAnimations();
    _startAnimations();
    _startConnectivityMonitoring();
  }

  void _initializeAttendanceDetails() {
    attendanceDetails = {
      ...widget.attendanceRecord,
      'timestamp': widget.attendanceRecord['timestamp'] ?? DateTime.now(),
      'location': {
        'latitude': 6.5244, // Mock Lagos coordinates
        'longitude': 3.3792,
        'address': 'University Campus, Lagos, Nigeria',
      },
      'verificationMethod': 'Facial Recognition',
      'confidenceScore': 0.95,
      'proofImage': null, // Placeholder for image URL
      'instructor': 'Dr. Jane Smith',
      'classRoom': 'Room A-101',
      'appealStatus': 'None',
    };
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
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
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

    _shakeAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
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

  void _toggleAppealMode() {
    setState(() {
      _isAppealing = !_isAppealing;
    });
    if (!_isAppealing && _appealFormKey.currentState!.validate()) {
      _submitAppeal();
    } else if (_isAppealing) {
      _shakeController.reset();
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
  }

  void _submitAppeal() {
    attendanceDetails['appealStatus'] = 'Pending';
    // Placeholder for Firebase appeal submission
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appeal submitted successfully'),
        backgroundColor: AppColors.passwordStrengthStrong,
      ),
    );
    setState(() {
      _unreadNotifications++;
      notifications.add({
        'message':
            'Appeal submitted for ${attendanceDetails['courseName']} on ${attendanceDetails['date']}',
        'time': DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
      });
      _appealReasonController.clear();
    });
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
              'Attendance Notifications',
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

  void _navigateToScreen(String route) {
    Navigator.pushNamed(context, route);
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
                Icons.event_note,
                size: 45,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            attendanceDetails['courseName'],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            attendanceDetails['date'],
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

  Widget _buildDetailsSection() {
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
              'Attendance Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Status', attendanceDetails['status'],
                color: attendanceDetails['status'] == 'Present'
                    ? AppColors.passwordStrengthStrong
                    : AppColors.errorAccent),
            _buildDetailRow('Time',
                DateFormat('hh:mm a').format(attendanceDetails['timestamp'])),
            _buildDetailRow('Instructor', attendanceDetails['instructor']),
            _buildDetailRow('Classroom', attendanceDetails['classRoom']),
            _buildDetailRow(
                'Verification Method', attendanceDetails['verificationMethod']),
            _buildDetailRow('Confidence Score',
                '${(attendanceDetails['confidenceScore'] * 100).round()}%'),
            _buildDetailRow('Appeal Status', attendanceDetails['appealStatus']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.secondaryText),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMap() {
    final lat = attendanceDetails['location']['latitude'];
    final lon = attendanceDetails['location']['longitude'];

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
              'Location',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              attendanceDetails['location']['address'],
              style: const TextStyle(color: AppColors.secondaryText),
            ),
            const SizedBox(height: 16),
            ZoomTransition(
              animation: _zoomAnimation,
              child: SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(lat, lon),
                    initialZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        // Marker(
                        //   point: LatLng(lat, lon),
                        //   builder: (ctx) => RotationTransition(
                        //     turns: _rotateAnimation,
                        //     child: const Icon(
                        //       Icons.location_pin,
                        //       color: AppColors.errorAccent,
                        //       size: 40,
                        //     ),
                        //   ),
                        // ),
                      ],
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

  Widget _buildProofSection() {
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
              'Proof of Attendance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            attendanceDetails['proofImage'] == null
                ? const Text(
                    'No image proof available. Verified via facial recognition.',
                    style: TextStyle(color: AppColors.secondaryText),
                  )
                : Image.network(
                    attendanceDetails['proofImage'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      'Failed to load proof image.',
                      style: TextStyle(color: AppColors.errorAccent),
                    ),
                  ),
            const SizedBox(height: 16),
            Text(
              'Confidence Score: ${(attendanceDetails['confidenceScore'] * 100).round()}%',
              style: const TextStyle(color: AppColors.primaryText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppealSection() {
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
              'Appeal Attendance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            if (attendanceDetails['appealStatus'] != 'None')
              Text(
                'Current Appeal Status: ${attendanceDetails['appealStatus']}',
                style: TextStyle(
                  color: attendanceDetails['appealStatus'] == 'Pending'
                      ? AppColors.primaryAccent
                      : AppColors.secondaryText,
                ),
              ),
            if (_isAppealing) ...[
              Form(
                key: _appealFormKey,
                child: TextFormField(
                  controller: _appealReasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Reason for Appeal',
                    labelStyle: const TextStyle(color: AppColors.secondaryText),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a reason for the appeal';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            BounceTransition(
              animation: _bounceAnimation,
              child: ElevatedButton(
                onPressed: attendanceDetails['appealStatus'] == 'None' ||
                        attendanceDetails['appealStatus'] == 'Rejected'
                    ? _toggleAppealMode
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: AppColors.primaryText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child:
                    Text(_isAppealing ? 'Submit Appeal' : 'Appeal Attendance'),
              ),
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
                    _buildDetailsSection(),
                    _buildLocationMap(),
                    _buildProofSection(),
                    _buildAppealSection(),
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
    _zoomController.dispose();
    _shakeController.dispose();
    _appealReasonController.dispose();
    _connectivitySubscription?.cancel();
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
