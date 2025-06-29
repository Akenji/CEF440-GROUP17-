import 'package:flutter/material.dart';
import '../../../../core/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: user.avatarUrl != null 
                  ? NetworkImage(user.avatarUrl!) 
                  : null,
              child: user.avatarUrl == null 
                  ? Text(
                      user.fullName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            
            // Name
            Text(
              user.fullName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            
            // Email
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            
            // Role Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getRoleColor(user.role).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.role.name.toUpperCase(),
                style: TextStyle(
                  color: _getRoleColor(user.role),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            
            // Status
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  user.isActive ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: user.isActive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  user.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: user.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Colors.blue;
      case UserRole.lecturer:
        return Colors.green;
      case UserRole.admin:
        return Colors.orange;
    }
  }
}
