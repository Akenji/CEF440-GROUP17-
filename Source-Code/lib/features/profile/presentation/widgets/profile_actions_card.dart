import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/auth_service.dart';

class ProfileActionsCard extends ConsumerWidget {
  const ProfileActionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Edit Profile
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              subtitle: const Text('Update your personal information'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to edit profile
              },
            ),
            
            // Change Password
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              subtitle: const Text('Update your account password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to change password
              },
            ),
            
            // Notifications Settings
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Settings'),
              subtitle: const Text('Manage your notification preferences'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to notification settings
              },
            ),
            
            // Privacy Settings
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Settings'),
              subtitle: const Text('Control your privacy preferences'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to privacy settings
              },
            ),
            
            const Divider(),
            
            // Sign Out
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
              subtitle: const Text('Sign out of your account'),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await ref.read(authServiceProvider.notifier).signOut();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
