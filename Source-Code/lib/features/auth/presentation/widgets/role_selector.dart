import 'package:flutter/material.dart';
import '../../../../core/models/user_model.dart';

class RoleSelector extends StatelessWidget {
  final UserRole selectedRole;
  final ValueChanged<UserRole> onRoleChanged;
  final bool isCompact;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactSelector(context);
    }
    return _buildFullSelector(context);
  }

  Widget _buildCompactSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login as:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: UserRole.values.map((role) {
            final isSelected = selectedRole == role;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => onRoleChanged(role),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? _getRoleColor(role)
                            : Theme.of(context).colorScheme.outline.withOpacity(0.5),
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected
                          ? _getRoleColor(role).withOpacity(0.1)
                          : null,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getRoleIcon(role),
                          size: 20,
                          color: isSelected
                              ? _getRoleColor(role)
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getRoleTitle(role),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? _getRoleColor(role)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFullSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Role',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: UserRole.values.map((role) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _RoleCard(
                  role: role,
                  title: _getRoleTitle(role),
                  description: _getRoleDescription(role),
                  icon: _getRoleIcon(role),
                  isSelected: selectedRole == role,
                  onTap: () => onRoleChanged(role),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getRoleTitle(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Student';
      case UserRole.lecturer:
        return 'Lecturer';
      case UserRole.admin:
        return 'Admin';
    }
  }

  String _getRoleDescription(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Take attendance and view courses';
      case UserRole.lecturer:
        return 'Manage courses and sessions';
      case UserRole.admin:
        return 'System administration';
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Icons.school;
      case UserRole.lecturer:
        return Icons.person;
      case UserRole.admin:
        return Icons.admin_panel_settings;
    }
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

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getRoleColor(role);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color
                : Theme.of(context).colorScheme.outline.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? color.withOpacity(0.1)
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? color
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? color : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
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
