import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth_service.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Settings
          _SettingsSection(
            title: 'Account',
            children: [
              _SettingsTile(
                icon: Icons.person,
                title: 'Profile Information',
                subtitle: 'Update your personal information',
                onTap: () {
                  // Navigate to profile edit
                },
              ),
              _SettingsTile(
                icon: Icons.lock,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () {
                  // Navigate to change password
                },
              ),
              if (user?.role.name == 'student')
                _SettingsTile(
                  icon: Icons.face,
                  title: 'Face Recognition',
                  subtitle: 'Update your face data',
                  onTap: () {
                    // Navigate to face data update
                  },
                ),
            ],
          ),
          
          // Notification Settings
          _SettingsSection(
            title: 'Notifications',
            children: [
              _SettingsTile(
                icon: Icons.notifications,
                title: 'Push Notifications',
                subtitle: 'Receive attendance reminders',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // Toggle notifications
                  },
                ),
              ),
              _SettingsTile(
                icon: Icons.email,
                title: 'Email Notifications',
                subtitle: 'Receive updates via email',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // Toggle email notifications
                  },
                ),
              ),
            ],
          ),
          
          // App Settings
          _SettingsSection(
            title: 'App',
            children: [
              _SettingsTile(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                subtitle: 'Switch to dark theme',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // Toggle theme
                  },
                ),
              ),
              _SettingsTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
                onTap: () {
                  // Show language selection
                },
              ),
            ],
          ),
          
          // Privacy & Security
          _SettingsSection(
            title: 'Privacy & Security',
            children: [
              _SettingsTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {
                  // Show privacy policy
                },
              ),
              _SettingsTile(
                icon: Icons.security,
                title: 'Security',
                subtitle: 'Manage security settings',
                onTap: () {
                  // Navigate to security settings
                },
              ),
            ],
          ),
          
          // Support
          _SettingsSection(
            title: 'Support',
            children: [
              _SettingsTile(
                icon: Icons.help,
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () {
                  // Navigate to help
                },
              ),
              _SettingsTile(
                icon: Icons.info,
                title: 'About',
                subtitle: 'App version and information',
                onTap: () {
                  // Show about dialog
                },
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Sign Out Button
          ElevatedButton(
            onPressed: () {
              _showSignOutDialog(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authServiceProvider.notifier).signOut();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
