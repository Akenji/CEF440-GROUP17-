import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/academic_model.dart';
import '../models/attendance_model.dart';
import '../models/notification_model.dart';
import '../models/system_model.dart';

// Helper function to safely parse DateTime
DateTime _parseDateTime(dynamic value) {
  if (value == null || (value is String && value.isEmpty)) {
    return DateTime.now();
  }
  if (value is DateTime) return value;
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (e) {
      print('Warning: Failed to parse date string "$value". Error: $e');
      return DateTime.now();
    }
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  print('Warning: Unexpected date type ${value.runtimeType}. Value: $value');
  return DateTime.now();
}

// Fixed enum parsing function
UserRole _parseUserRole(dynamic roleValue) {
  if (roleValue == null) return UserRole.student;

  String roleString;
  if (roleValue is UserRole) {
    return roleValue;
  } else if (roleValue is String) {
    roleString = roleValue.toLowerCase().trim();
  } else {
    print(
        'Warning: Unexpected role type ${roleValue.runtimeType}. Value: $roleValue');
    return UserRole.student;
  }

  // Handle different possible string formats
  switch (roleString) {
    case 'student':
      return UserRole.student;
    case 'lecturer':
      return UserRole.lecturer;
    case 'admin':
      return UserRole.admin;
    // Handle enum toString format: "UserRole.admin" -> "admin"
    case 'userrole.student':
      return UserRole.student;
    case 'userrole.lecturer':
      return UserRole.lecturer;
    case 'userrole.admin':
      return UserRole.admin;
    default:
      print(
          'Warning: Unknown role string "$roleString". Defaulting to student.');
      return UserRole.student;
  }
}

// Extension to ensure consistent string conversion
extension UserRoleExtension on UserRole {
  String get dbValue {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.lecturer:
        return 'lecturer';
      case UserRole.admin:
        return 'admin';
    }
  }
}

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  static SupabaseClient get client => _client;

  // Auth methods
  static User? get currentUser => _client.auth.currentUser;
  static String? get currentUserId => _client.auth.currentUser?.id;

  static Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed. Please check your credentials.');
      }

      return response;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      // Use the dbValue extension to ensure consistent string format
      final response = await _client.auth.signUp(
        email: email.toLowerCase().trim(),
        password: password,
        data: {
          'full_name': fullName,
          'role':
              role.dbValue, // Use the extension method for consistent format
        },
      );

      if (response.user != null) {
        // Create user profile in public.users table
        await _client.from('users').insert({
          'id': response.user!.id,
          'email': email.toLowerCase().trim(),
          'full_name': fullName,
          'role': role.dbValue, // Use the extension method here too
          'is_active': true,
        });
      }

      return response;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  static Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email.toLowerCase().trim(),
        redirectTo: 'io.supabase.schoolattendance://reset-password',
      );
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  static String _handleAuthException(AuthException e) {
    switch (e.message) {
      case 'Invalid login credentials':
        return 'Invalid email or password. Please try again.';
      case 'Email not confirmed':
        return 'Please check your email and click the confirmation link.';
      case 'User already registered':
        return 'An account with this email already exists.';
      case 'Password should be at least 6 characters':
        return 'Password must be at least 6 characters long.';
      case 'Signup requires a valid password':
        return 'Please enter a valid password.';
      case 'Unable to validate email address: invalid format':
        return 'Please enter a valid email address.';
      case 'Email rate limit exceeded':
        return 'Too many requests. Please wait before trying again.';
      default:
        return e.message;
    }
  }

  // Database methods
  static PostgrestQueryBuilder from(String table) => _client.from(table);

  static SupabaseStorageClient get storage => _client.storage;

  static RealtimeChannel channel(String name) => _client.channel(name);

  // Fixed user profile methods with proper enum handling
  static Future<UserModel?> getCurrentUserProfile() async {
    if (currentUserId == null) return null;

    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', currentUserId!)
          .single();

      return _processUserJson(response);
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Helper method to process user JSON with proper enum handling
  static UserModel? _processUserJson(Map<String, dynamic>? rawJson) {
    if (rawJson == null) return null;

    try {
      final Map<String, dynamic> processedJson = {
        'id': (rawJson['id'] as String?) ?? '',
        'email': (rawJson['email'] as String?) ?? '',
        'fullName': (rawJson['full_name'] as String?) ?? '',
        'role':
            _parseUserRole(rawJson['role']), // Use the fixed parsing function
        'avatarUrl': rawJson['avatar_url'] as String?,
        'phone': rawJson['phone'] as String?,
        'isActive': (rawJson['is_active'] as bool?) ?? true,
        'createdAt': _parseDateTime(rawJson['created_at']),
        'updatedAt': _parseDateTime(rawJson['updated_at']),
      };

      return UserModel.fromJson(processedJson);
    } catch (e) {
      print('Error processing user JSON: $e');
      print('Raw JSON: $rawJson');
      return null;
    }
  }

  static Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    if (currentUserId == null) return;

    try {
      // Convert any UserRole enums to strings before sending to database
      final Map<String, dynamic> dbUpdates = {};
      updates.forEach((key, value) {
        switch (key) {
          case 'fullName':
            dbUpdates['full_name'] = value;
            break;
          case 'avatarUrl':
            dbUpdates['avatar_url'] = value;
            break;
          case 'isActive':
            dbUpdates['is_active'] = value;
            break;
          case 'role':
            // Handle UserRole enum conversion
            if (value is UserRole) {
              dbUpdates['role'] = value.dbValue;
            } else {
              dbUpdates['role'] = value;
            }
            break;
          case 'createdAt':
            dbUpdates['created_at'] = value;
            break;
          case 'updatedAt':
            dbUpdates['updated_at'] = value;
            break;
          default:
            dbUpdates[key] = value;
        }
      });

      await _client.from('users').update(dbUpdates).eq('id', currentUserId!);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  // Health check method
  static Future<bool> isConnected() async {
    try {
      await _client.from('users').select('id').limit(1);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get user by role with fixed enum handling
  static Future<List<UserModel>> getUsersByRole(UserRole role) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('role', role.dbValue) // Use the extension method for consistency
          .eq('is_active', true)
          .order('full_name');

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((item) {
            final Map<String, dynamic> rawJson =
                Map<String, dynamic>.from(item as Map);
            return _processUserJson(rawJson);
          })
          .where((user) => user != null)
          .cast<UserModel>()
          .toList();
    } on PostgrestException catch (e) {
      print(
          'Supabase Error getting users by role: ${e.message}, Code: ${e.code}');
      throw Exception('Failed to get users: ${e.message}');
    } catch (e) {
      print('Unexpected Error getting users by role: $e');
      throw Exception('Failed to get users: ${e.toString()}');
    }
  }
}
