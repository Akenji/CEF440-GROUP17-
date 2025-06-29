import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

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

class AuthService extends StateNotifier<AsyncValue<UserModel?>> {
  AuthService() : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    // Listen to auth state changes
    SupabaseService.authStateChanges.listen((data) {
      _handleAuthStateChange(data);
    });

    // Check initial auth state
    _checkInitialAuth();
  }

  // Fixed user processing with proper enum handling
  UserModel? _processUserJson(Map<String, dynamic>? rawJson) {
    if (rawJson == null) return null;

    try {
      final Map<String, dynamic> processedJson = {
        'id': (rawJson['id'] as String?) ?? '',
        'email': (rawJson['email'] as String?) ?? '',
        'fullName': (rawJson['full_name'] as String?) ?? '',
        'role': rawJson['role'],
        'avatarUrl': rawJson['avatar_url'] as String?,
        'phone': rawJson['phone'] as String?,
        'isActive': (rawJson['is_active'] as bool?) ?? true,
        'createdAt': rawJson['created_at'],
        'updatedAt': rawJson['updated_at'],
      };
      return UserModel.fromJson(processedJson);
    } catch (e) {
      print('Error processing user JSON: $e');
      print('Raw JSON: $rawJson');
      return null;
    }
  }

  Future<void> _checkInitialAuth() async {
    try {
      final user = SupabaseService.currentUser;
      if (user != null) {
        final rawProfileResponse = await SupabaseService.from('users')
            .select()
            .eq('id', user.id)
            .single();
        final profile = _processUserJson(rawProfileResponse);
        state = AsyncValue.data(profile);
      } else {
        state = const AsyncValue.data(null);
      }
    } on PostgrestException catch (e) {
      print(
          'Supabase Error: ${e.message}, Code: ${e.code}, Details: ${e.details}');
      state = AsyncValue.error(
          Exception('Failed to check auth: ${e.message}'), StackTrace.current);
    } catch (error, stackTrace) {
      print('Unexpected Error: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _handleAuthStateChange(AuthState authState) async {
    try {
      if (authState.session != null) {
        final rawProfileResponse = await SupabaseService.from('users')
            .select()
            .eq('id', authState.session!.user.id)
            .single();
        final profile = _processUserJson(rawProfileResponse);
        state = AsyncValue.data(profile);
      } else {
        state = const AsyncValue.data(null);
      }
    } on PostgrestException catch (e) {
      print(
          'Supabase Error: ${e.message}, Code: ${e.code}, Details: ${e.details}');
      state = AsyncValue.error(
          Exception('Failed to handle auth state: ${e.message}'),
          StackTrace.current);
    } catch (error, stackTrace) {
      print('Unexpected Error: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    UserRole? expectedRole,
  }) async {
    try {
      state = const AsyncValue.loading();

      final response = await SupabaseService.signInWithEmail(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final rawProfileResponse = await SupabaseService.from('users')
            .select()
            .eq('id', response.user!.id)
            .single();
        final profile = _processUserJson(rawProfileResponse);

        if (profile == null) {
          await SupabaseService.signOut();
          throw Exception(
              'User profile not found. Please contact administrator.');
        }

        if (expectedRole != null && profile.role != expectedRole) {
          await SupabaseService.signOut();
          throw Exception(
              'Access denied. This account is registered as profile.role.dbValue}, '
              'but you\'re trying to login as expectedRole.dbValue}.');
        }

        if (!profile.isActive) {
          await SupabaseService.signOut();
          throw Exception(
              'Your account has been deactivated. Please contact administrator.');
        }

        state = AsyncValue.data(profile);
      }
    } on PostgrestException catch (e) {
      state = AsyncValue.error(
          Exception('Sign-in failed: ${e.message}'), StackTrace.current);
      rethrow;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      state = const AsyncValue.loading();

      final emailExists = await _checkEmailExists(email);
      if (emailExists) {
        throw Exception('An account with this email already exists.');
      }

      final response = await SupabaseService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
      );

      if (response.user != null) {
        // Create user profile in public.users table
        await SupabaseService.from('users').insert({
          'id': response.user!.id,
          'email': email.toLowerCase().trim(),
          'full_name': fullName,
          'role': role.name,
          'is_active': true,
        });
      }

      if (response.user != null && additionalData != null) {
        try {
          await _createRoleSpecificProfile(
              response.user!.id, role, additionalData);
        } catch (e) {
          // Clean up the user if role-specific profile creation fails
          try {
            await SupabaseService.client.auth.admin
                .deleteUser(response.user!.id);
          } catch (deleteError) {
            print(
                'Failed to delete user after profile creation error: $deleteError');
          }
          throw Exception('Failed to create role-specific profile: $e');
        }
      }

      final rawProfileResponse = await SupabaseService.from('users')
          .select()
          .eq('id', response.user!.id)
          .single();
      final profile = _processUserJson(rawProfileResponse);
      state = AsyncValue.data(profile);
    } on PostgrestException catch (e) {
      state = AsyncValue.error(
          Exception('Sign-up failed: ${e.message}'), StackTrace.current);
      rethrow;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<bool> _checkEmailExists(String email) async {
    try {
      final result = await SupabaseService.from('users')
          .select('id')
          .eq('email', email.toLowerCase().trim())
          .maybeSingle();
      return result != null;
    } on PostgrestException catch (e) {
      print(
          'Supabase Error: ${e.message}, Code: ${e.code}, Details: ${e.details}');
      return false;
    } catch (e) {
      print('Unexpected Error: $e');
      return false;
    }
  }

  Future<void> _createRoleSpecificProfile(
    String userId,
    UserRole role,
    Map<String, dynamic> additionalData,
  ) async {
    switch (role) {
      case UserRole.student:
        if (!additionalData.containsKey('matricule') ||
            !additionalData.containsKey('department_id') ||
            !additionalData.containsKey('level') ||
            !additionalData.containsKey('admission_year')) {
          throw Exception(
              'Missing required student data: matricule, department_id, level, admission_year');
        }
        if (![200, 300, 400, 500].contains(additionalData['level'])) {
          throw Exception(
              'Invalid student level: must be 200, 300, 400, or 500');
        }
        await SupabaseService.from('students').insert({
          'id': userId,
          'matricule': additionalData['matricule'],
          'department_id': additionalData['department_id'],
          'level': additionalData['level'],
          'admission_year': additionalData['admission_year'],
          'current_semester': additionalData['current_semester'] ?? 1,
          'current_academic_year':
              additionalData['current_academic_year'] ?? '2024-2025',
          'is_active': true,
        });

        if (additionalData['face_encoding'] != null) {
          if (additionalData['face_encoding'] is! List<int>) {
            throw Exception('face_encoding must be a List<int>');
          }
          await SupabaseService.from('face_data').insert({
            'student_id': userId,
            'face_encoding': additionalData['face_encoding'],
            'face_image_url': additionalData['face_image_url'],
            'is_verified': false,
          });
        }
        break;

      case UserRole.lecturer:
        if (!additionalData.containsKey('employee_id') ||
            !additionalData.containsKey('department_id')) {
          throw Exception(
              'Missing required lecturer data: employee_id, department_id');
        }
        await SupabaseService.from('lecturers').insert({
          'id': userId,
          'employee_id': additionalData['employee_id'],
          'department_id': additionalData['department_id'],
          'title': additionalData['title'],
          'specialization': additionalData['specialization'],
          'hire_date': additionalData['hire_date'],
          'office_location': additionalData['office_location'],
          'office_hours': additionalData['office_hours'],
          'is_active': true,
        });
        break;

      case UserRole.admin:
        await SupabaseService.from('admins').insert({
          'id': userId,
          'department_id': additionalData['department_id'],
          'admin_level': additionalData['admin_level'] ?? 'department',
          'permissions': additionalData['permissions'] ?? {},
        });
        break;
    }

    await _sendWelcomeNotification(userId, role);
  }

  Future<void> _sendWelcomeNotification(String userId, UserRole role) async {
    try {
      await SupabaseService.from('notifications').insert({
        'user_id': userId,
        'title': 'Welcome to School Attendance System!',
        'message':
            'Your ${UserRoleExtension(role).dbValue} account has been created successfully. '
                'You can now start using the attendance system.',
        'type': 'system',
        'priority': 'normal',
        'created_at': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      print(
          'Supabase Error sending notification: ${e.message}, Code: ${e.code}, Details: ${e.details}');
    }
  }

  Future<void> signOut() async {
    try {
      await SupabaseService.signOut();
      state = const AsyncValue.data(null);
    } on PostgrestException catch (e) {
      state = AsyncValue.error(
          Exception('Sign-out failed: ${e.message}'), StackTrace.current);
      rethrow;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final userExists = await _checkEmailExists(email);
      if (!userExists) {
        throw Exception('No account found with this email address.');
      }

      await SupabaseService.resetPassword(email);
    } on PostgrestException catch (e) {
      throw Exception('Password reset failed: ${e.message}');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    try {
      final currentUser = state.value;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final sanitizedUpdates = Map<String, dynamic>.from(updates);

      // Convert camelCase keys to snake_case for Supabase if needed
      final Map<String, dynamic> dbUpdates = {};
      sanitizedUpdates.forEach((key, value) {
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
            // Convert UserRole enum to string
            if (value is UserRole) {
              dbUpdates['role'] = UserRoleExtension(value).dbValue;
            } else {
              dbUpdates['role'] = value;
            }
            break;
          case 'createdAt':
          case 'updatedAt':
            // Skip these fields
            break;
          default:
            dbUpdates[key] = value;
        }
      });

      if (dbUpdates.isNotEmpty) {
        await SupabaseService.updateUserProfile(dbUpdates);
      }

      // Re-fetch and re-process the user profile
      final rawUpdatedProfile = await SupabaseService.from('users')
          .select()
          .eq('id', currentUser.id)
          .single();
      final updatedProfile = _processUserJson(rawUpdatedProfile);
      state = AsyncValue.data(updatedProfile);
    } on PostgrestException catch (e) {
      state = AsyncValue.error(
          Exception('Profile update failed: ${e.message}'), StackTrace.current);
      rethrow;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      await SupabaseService.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      await SupabaseService.client.auth.refreshSession();

      final rawProfileResponse = await SupabaseService.from('users')
          .select()
          .eq('id', user.id)
          .single();
      final profile = _processUserJson(rawProfileResponse);
      state = AsyncValue.data(profile);
    } on AuthException catch (e) {
      throw Exception('Password change failed: ${e.message}');
    } catch (error) {
      rethrow;
    }
  }
}

final authServiceProvider =
    StateNotifierProvider<AuthService, AsyncValue<UserModel?>>((ref) {
  return AuthService();
});

final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authServiceProvider);
  return authState.maybeWhen(
    data: (user) => user,
    orElse: () => null,
  );
});

final isLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

final userRoleProvider = Provider<UserRole?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.role;
});
