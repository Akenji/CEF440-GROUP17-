import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/models/user_model.dart';
import '../../../student/data/providers/student_providers.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/profile_actions_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentUserProvider);
          if (user.role == UserRole.student) {
            ref.invalidate(studentProfileProvider(user.id));
            ref.invalidate(simplestudentStatsProvider(user.id));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              ProfileHeader(user: user),
              const SizedBox(height: 16),
              
              // Profile Information
              ProfileInfoCard(user: user),
              const SizedBox(height: 16),
              
              // Role-specific content
              if (user.role == UserRole.student) ...[
                ProfileStatsCard(userId: user.id),
                const SizedBox(height: 16),
              ],
              
              // Profile Actions
              const ProfileActionsCard(),
            ],
          ),
        ),
      ),
    );
  }
}
