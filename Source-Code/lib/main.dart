import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'core/services/location_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://dwzlolnqhdkvdichbyfp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3emxvbG5xaGRrdmRpY2hieWZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA3NTk0MDAsImV4cCI6MjA2NjMzNTQwMH0.gp5wXnBP74XG6wttxWbEEUhjehNuW2cmf6wPoTdFbTE',
  );

  // Initialize services
  await NotificationService.initialize();
  await LocationService.initialize();

  runApp(
    const ProviderScope(
      child: SchoolAttendanceApp(),
    ),
  );
}

class SchoolAttendanceApp extends ConsumerWidget {
  const SchoolAttendanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'School Attendance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
