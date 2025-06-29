class AppConfig {
  // Supabase Configuration
  static const String supabaseUrl = 'https://dwzlolnqhdkvdichbyfp.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3emxvbG5xaGRrdmRpY2hieWZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA3NTk0MDAsImV4cCI6MjA2NjMzNTQwMH0.gp5wXnBP74XG6wttxWbEEUhjehNuW2cmf6wPoTdFbTE';

  // App Configuration
  static const String appName = 'School Attendance';
  static const String appVersion = '1.0.0';

  // Geofencing Configuration
  static const double defaultGeofenceRadius = 100.0; // meters
  static const double locationAccuracyThreshold = 50.0; // meters

  // Face Recognition Configuration
  static const double faceConfidenceThreshold = 0.8;
  static const int maxFaceDetectionAttempts = 3;

  // Session Configuration
  static const int sessionTimeoutMinutes = 30;
  static const int attendanceGracePeriodMinutes = 15;

  // Notification Configuration
  static const String notificationChannelId = 'attendance_notifications';
  static const String notificationChannelName = 'Attendance Notifications';

  // Storage Configuration
  static const String faceDataBucket = 'face-data';
  static const String reportsBucket = 'reports';
}
