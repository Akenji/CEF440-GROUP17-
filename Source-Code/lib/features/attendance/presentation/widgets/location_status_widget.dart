import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/models/attendance_model.dart';
import '../../../../core/services/location_service.dart';

class LocationStatusWidget extends StatelessWidget {
  final bool isVerified;
  final Position? currentPosition;
  final Position? targetLocation;
  final double radius;

  const LocationStatusWidget({
    super.key,
    required this.isVerified,
    this.currentPosition,
    this.targetLocation,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isVerified ? Icons.check_circle : Icons.location_on,
                  color: isVerified ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  'Location Verification',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (currentPosition != null && targetLocation != null) ...[
              _LocationInfo(
                label: 'Your Location',
                latitude: currentPosition!.latitude,
                longitude: currentPosition!.longitude,
              ),
              const SizedBox(height: 8),
              _LocationInfo(
                label: 'Session Location',
                latitude: targetLocation!.latitude,
                longitude: targetLocation!.longitude,
              ),
              const SizedBox(height: 8),
              _DistanceInfo(
                currentPosition: currentPosition!,
                targetLocation: targetLocation!,
                radius: radius,
                isWithinRange: isVerified,
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_searching, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Getting location...'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LocationInfo extends StatelessWidget {
  final String label;
  final double latitude;
  final double longitude;

  const _LocationInfo({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.place, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
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
                '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DistanceInfo extends StatelessWidget {
  final Position currentPosition;
  final Position targetLocation;
  final double radius;
  final bool isWithinRange;

  const _DistanceInfo({
    required this.currentPosition,
    required this.targetLocation,
    required this.radius,
    required this.isWithinRange,
  });

  @override
  Widget build(BuildContext context) {
    final distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      targetLocation.latitude,
      targetLocation.longitude,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWithinRange 
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWithinRange 
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isWithinRange ? Icons.check_circle : Icons.error,
            color: isWithinRange ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isWithinRange 
                      ? 'Within required location'
                      : 'Outside required location',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isWithinRange ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  'Distance: ${distance.toStringAsFixed(1)}m (Required: ${radius.toStringAsFixed(1)}m)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
