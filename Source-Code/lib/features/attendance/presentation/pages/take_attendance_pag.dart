import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
 // Ensure this now includes LocationCoordinates
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/location_service.dart';

import '../widgets/camera_preview_widget.dart';
import '../widgets/location_status_widget.dart';
import '../providers/attendance_providers.dart';

class TakeAttendancePage extends ConsumerStatefulWidget {
  final String sessionId;

  const TakeAttendancePage({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<TakeAttendancePage> createState() => _TakeAttendancePageState();
}

class _TakeAttendancePageState extends ConsumerState<TakeAttendancePage> {
  bool _isProcessing = false;
  String? _statusMessage;
  Position? _currentPosition;
  bool _locationVerified = false;
  bool _faceVerified = false;

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    try {
      setState(() {
        _statusMessage = 'Checking location...';
      });

      final position = await LocationService.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });

      // Get session details to check geofence
      final session =
          await ref.read(attendanceSessionProvider(widget.sessionId).future);

      // Changed from session.locationCoordinates to session.location
      if (session.requireGeofence && session.locationLatitude != null) {
        final isWithinGeofence = LocationService.isWithinGeofence(
          userLocation: LocationCoordinates(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          targetLocation: LocationCoordinates(
            latitude: session.locationLatitude!,
            longitude: session.locationLongitude!,
          ), // Use session.location
          radiusInMeters: session.geofenceRadius.toDouble(),
        );

        setState(() {
          _locationVerified = isWithinGeofence;
          _statusMessage = isWithinGeofence
              ? 'Location verified. Please verify your face.'
              : 'You are not within the required location for this session.';
        });
      } else {
        setState(() {
          _locationVerified = true;
          _statusMessage =
              'Location check not required. Please verify your face.';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Location error: $e';
      });
    }
  }

  Future<void> _submitAttendance() async {
    if (!_locationVerified || !_faceVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please complete location and face verification first.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Submitting attendance...';
    });

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('User not found');

      await ref.read(attendanceSubmissionProvider.notifier).submitAttendance(
            sessionId: widget.sessionId,
            studentId: user.id,
            location: _currentPosition != null
                ? LocationCoordinates(
                    latitude: _currentPosition!.latitude,
                    longitude: _currentPosition!.longitude,
                  )
                : null,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Attendance submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/student');
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to submit attendance: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit attendance: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(attendanceSessionProvider(widget.sessionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Attendance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/student'),
        ),
      ),
      body: sessionAsync.when(
        data: (session) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Session Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(session.course?.title ?? 'Unknown Course'),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatTime(session.scheduledStart)} - ${_formatTime(session.scheduledEnd)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Status Message
              if (_statusMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: _getStatusColor().withOpacity(0.3)),
                  ),
                  child: Text(
                    _statusMessage!,
                    style: TextStyle(color: _getStatusColor()),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 16),

              // Location Status
              if (session.requireGeofence)
                LocationStatusWidget(
                  isVerified: _locationVerified,
                  currentPosition: _currentPosition,
                  targetLocation:Position(
                      latitude: session.locationLatitude ?? 0.0,
                      longitude: session.locationLongitude ?? 0.0,
                      altitude: 0.0,
                      accuracy: 0.0,
                      altitudeAccuracy: 0.0,
                      speed: 0.0,
                      speedAccuracy: 0.0,
                      heading: 0.0,
                      timestamp: DateTime.now(), headingAccuracy: 0.0,
                    ),
                  radius: session.geofenceRadius.toDouble(),
                ),
              const SizedBox(height: 16),

              // Face Verification
              if (session.requireFaceRecognition)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _faceVerified ? Icons.check_circle : Icons.face,
                              color: _faceVerified ? Colors.green : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Face Verification',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CameraPreviewWidget(
                          onFaceVerified: (verified, embeddings) {
                            setState(() {
                              _faceVerified = verified;
                              if (verified) {
                                _statusMessage = 'Face verified successfully!';
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (_locationVerified && _faceVerified && !_isProcessing)
                          ? _submitAttendance
                          : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Attendance',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(attendanceSessionProvider(widget.sessionId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (_locationVerified && _faceVerified) {
      return Colors.green;
    } else if (_statusMessage?.contains('error') == true ||
        _statusMessage?.contains('Failed') == true) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class LocationCoordinates {
  final double latitude;
  final double longitude;

  const LocationCoordinates({
    required this.latitude,
    required this.longitude,
  });

  factory LocationCoordinates.fromJson(Map<String, dynamic> json) {
    return LocationCoordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
