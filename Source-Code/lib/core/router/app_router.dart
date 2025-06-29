import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/student/presentation/pages/student_dashboard_page.dart';
import '../../features/lecturer/presentation/pages/lecturer_dashboard_page.dart';
import '../../features/lecturer/presentation/pages/session_management_page.dart';
import '../../features/lecturer/presentation/pages/session_attendance_page.dart';
// import '../../features/lecturer/presentation/pages/course_analytics_page.dart';
// import '../../features/lecturer/presentation/pages/lecturer_courses_page.dart';
// import '../../features/lecturer/presentation/pages/lecturer_export_page.dart';
// import '../../features/lecturer/presentation/pages/attendance_reports_page.dart';
// import '../../features/lecturer/presentation/pages/lecturer_notifications_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/admin_reports_page.dart';
import '../../features/admin/presentation/pages/admin_users_page.dart';
// import '../../features/admin/presentation/pages/admin_notifications_page.dart';
import '../../features/attendance/presentation/pages/take_attendance_pag.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/student/presentation/pages/course_enrollment_page.dart';
import '../../features/student/presentation/pages/student_attendance_history_page.dart';
// import '../../features/student/presentation/pages/student_notifications_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authServiceProvider);
  
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );
      
      final isLoading = authState.maybeWhen(
        loading: () => true,
        orElse: () => false,
      );
      
      if (isLoading) return null;
      
      final isLoginRoute = state.uri.toString() == '/login' || state.uri.toString() == '/register';
      
      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }
      
      if (isLoggedIn && isLoginRoute) {
        final user = authState.maybeWhen(
          data: (user) => user,
          orElse: () => null,
        );
        
        if (user != null) {
          switch (user.role) {
            case UserRole.student:
              return '/student';
            case UserRole.lecturer:
              return '/lecturer';
            case UserRole.admin:
              return '/admin';
          }
        }
      }
      
      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Student Routes
      GoRoute(
        path: '/student',
        builder: (context, state) => const StudentDashboardPage(),
        routes: [
          GoRoute(
            path: 'attendance/:sessionId',
            builder: (context, state) => TakeAttendancePage(
              sessionId: state.pathParameters['sessionId']!,
            ),
          ),
          GoRoute(
            path: 'courses',
            builder: (context, state) => const CourseEnrollmentPage(),
          ),
          GoRoute(
            path: 'attendance-history',
            builder: (context, state) => const StudentAttendanceHistoryPage(),
          ),
          // GoRoute(
          //   path: 'notifications',
          //   builder: (context, state) => const StudentNotificationsPage(),
          // ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      
      // Lecturer Routes - Enhanced
      GoRoute(
        path: '/lecturer',
        builder: (context, state) => const LecturerDashboardPage(),
        routes: [
          // Session Management
          GoRoute(
            path: 'sessions',
            builder: (context, state) => const SessionManagementPage(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateSessionPage(),
              ),
              GoRoute(
                path: ':sessionId',
                builder: (context, state) => SessionDetailPage(
                  sessionId: state.pathParameters['sessionId']!,
                ),
              ),
              GoRoute(
                path: ':sessionId/attendance',
                builder: (context, state) => SessionAttendancePage(
                  sessionId: state.pathParameters['sessionId']!,
                ),
              ),
            ],
          ),
          
          // Attendance Management
          GoRoute(
            path: 'attendance',
            builder: (context, state) => const LecturerAttendanceOverviewPage(),
          ),
          
          // Course Management
          // GoRoute(
          //   path: 'courses',
          //   builder: (context, state) => const LecturerCoursesPage(),
          //   routes: [
          //     GoRoute(
          //       path: ':courseId/analytics',
          //       builder: (context, state) => CourseAnalyticsPage(
          //         courseId: state.pathParameters['courseId']!,
          //       ),
          //     ),
          //     GoRoute(
          //       path: ':courseId/students',
          //       builder: (context, state) => CourseStudentsPage(
          //         courseId: state.pathParameters['courseId']!,
          //       ),
          //     ),
          //   ],
          // ),
          
          // Analytics
          GoRoute(
            path: 'analytics',
            builder: (context, state) => const LecturerAnalyticsPage(),
          ),
          
          // Reports
          // GoRoute(
          //   path: 'reports',
          //   builder: (context, state) => const AttendanceReportsPage(),
          //   routes: [
          //     GoRoute(
          //       path: 'course/:courseId',
          //       builder: (context, state) => CourseAttendanceReportPage(
          //         courseId: state.pathParameters['courseId']!,
          //       ),
          //     ),
          //     GoRoute(
          //       path: 'session/:sessionId',
          //       builder: (context, state) => SessionAttendanceReportPage(
          //         sessionId: state.pathParameters['sessionId']!,
          //       ),
          //     ),
          //   ],
          // ),
          
          // Export
          // GoRoute(
          //   path: 'export',
          //   builder: (context, state) => const LecturerExportPage(),
          // ),
          
          // Notifications
          // GoRoute(
          //   path: 'notifications',
          //   builder: (context, state) => const LecturerNotificationsPage(),
          // ),
          
          // Profile & Settings
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      
      // Admin Routes
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardPage(),
        routes: [
          GoRoute(
            path: 'users',
            builder: (context, state) => const AdminUsersPage(),
          ),
          GoRoute(
            path: 'reports',
            builder: (context, state) => const AdminReportsPage(),
          ),
          // GoRoute(
          //   path: 'notifications',
          //   builder: (context, state) => const AdminNotificationsPage(),
          // ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      
      // Shared Routes
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfilePage(),
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => ErrorPage(
      error: 'Page not found: ${state.uri.toString()}',
    ),
  );
});

// Additional page classes
class CreateSessionPage extends StatelessWidget {
  const CreateSessionPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Session')),
      body: const Center(child: Text('Create Session Page')),
    );
  }
}

class LecturerAttendanceOverviewPage extends StatelessWidget {
  const LecturerAttendanceOverviewPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Overview')),
      body: const Center(child: Text('Attendance Overview')),
    );
  }
}

class LecturerAnalyticsPage extends StatelessWidget {
  const LecturerAnalyticsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: const Center(child: Text('Analytics Page')),
    );
  }
}

class CourseStudentsPage extends StatelessWidget {
  final String courseId;
  
  const CourseStudentsPage({super.key, required this.courseId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Students')),
      body: Center(child: Text('Course Students: $courseId')),
    );
  }
}

class SessionAttendanceReportPage extends StatelessWidget {
  final String sessionId;
  
  const SessionAttendanceReportPage({super.key, required this.sessionId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session Report')),
      body: Center(child: Text('Session Report: $sessionId')),
    );
  }
}

class SessionDetailPage extends StatelessWidget {
  final String sessionId;
  
  const SessionDetailPage({super.key, required this.sessionId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session Details')),
      body: Center(child: Text('Session: $sessionId')),
    );
  }
}

class CourseAttendanceReportPage extends StatelessWidget {
  final String courseId;
  
  const CourseAttendanceReportPage({super.key, required this.courseId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Report')),
      body: Center(child: Text('Course Report: $courseId')),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile')),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String error;
  
  const ErrorPage({super.key, required this.error});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(error)),
    );
  }
}
