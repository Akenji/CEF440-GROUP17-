import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_service.dart';

// Re-export auth providers from auth service
final authServiceProvider = StateNotifierProvider<AuthService, AsyncValue<UserModel?>>((ref) {
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
