import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as u;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/models/user_model.dart';

class AdminUsersPage extends ConsumerStatefulWidget {
  const AdminUsersPage({super.key});

  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Students'),
            Tab(text: 'Lecturers'),
            Tab(text: 'Admins'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _UsersList(role: UserRole.student),
          _UsersList(role: UserRole.lecturer),
          _UsersList(role: UserRole.admin),
        ],
      ),
    );
  }
}

class _UsersList extends ConsumerWidget {
  final UserRole role;

  const _UsersList({required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: SupabaseService.getUsersByRole(role)
          .then((users) => users.map((u) => u.toJson()).toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final users = snapshot.data ?? [];

        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${role.name}s found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user['avatar_url'] != null
                      ? NetworkImage(user['avatar_url'])
                      : null,
                  child: user['avatar_url'] == null
                      ? Text(user['full_name'][0].toUpperCase())
                      : null,
                ),
                title: Text(user['full_name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user['email']),
                    if (user['phone'] != null) Text(user['phone']),
                  ],
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Text('View Details'),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: user['is_active'] ? 'deactivate' : 'activate',
                      child:
                          Text(user['is_active'] ? 'Deactivate' : 'Activate'),
                    ),
                  ],
                  onSelected: (value) =>
                      _handleUserAction(context, user, value),
                ),
                isThreeLine: user['phone'] != null,
              ),
            );
          },
        );
      },
    );
  }

  void _handleUserAction(
      BuildContext context, Map<String, dynamic> user, String action) {
    switch (action) {
      case 'view':
        _showUserDetails(context, user);
        break;
      case 'edit':
        _showEditUser(context, user);
        break;
      case 'activate':
      case 'deactivate':
        _toggleUserStatus(context, user);
        break;
    }
  }

  void _showUserDetails(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user['full_name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user['email']}'),
            if (user['phone'] != null) Text('Phone: ${user['phone']}'),
            Text('Role: ${user['role']}'),
            Text('Status: ${user['is_active'] ? 'Active' : 'Inactive'}'),
            Text(
                'Created: ${DateTime.parse(user['created_at']).toString().split(' ')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditUser(BuildContext context, Map<String, dynamic> user) {
    // TODO: Implement edit user dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit user functionality coming soon')),
    );
  }

  Future<void> _toggleUserStatus(
      BuildContext context, Map<String, dynamic> user) async {
    try {
      await SupabaseService.from('users')
          .update({'is_active': !user['is_active']}).eq('id', user['id']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User ${user['is_active'] ? 'deactivated' : 'activated'} successfully',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user: $e')),
      );
    }
  }
}
