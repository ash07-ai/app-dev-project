import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/firebase_auth_service.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int _filterIndex = 0; // 0: All, 1: Admins, 2: Users

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<FirebaseAuthService>(context);
    final currentUserEmail = authService.userEmail;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: StreamBuilder<List<UserCredential>>(
        stream: authService.getAllUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final allUsers = snapshot.data ?? [];

          // Apply filter
          List<UserCredential> filteredUsers = [];
          switch (_filterIndex) {
            case 1:
              filteredUsers = allUsers.where((u) => u.userType == 'admin').toList();
              break;
            case 2:
              filteredUsers = allUsers.where((u) => u.userType == 'user').toList();
              break;
            default:
              filteredUsers = allUsers;
          }

          // Apply search
          if (_searchQuery.isNotEmpty) {
            filteredUsers = filteredUsers.where((user) {
              return user.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  user.email.toLowerCase().contains(_searchQuery.toLowerCase());
            }).toList();
          }

          final adminCount = allUsers.where((u) => u.userType == 'admin').length;
          final userCount = allUsers.where((u) => u.userType == 'user').length;

          return Column(
            children: [
              // Filter chips
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip('All', 0, allUsers.length),
                    const SizedBox(width: 8),
                    _buildFilterChip('Admins', 1, adminCount),
                    const SizedBox(width: 8),
                    _buildFilterChip('Users', 2, userCount),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
              ),

              // Users list
              Expanded(
                child: filteredUsers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No users found'
                                  : 'No users match your search',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          final isCurrentUser = user.email == currentUserEmail;
                          return _buildUserCard(
                              context, user, authService, isCurrentUser);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, int index, int count) {
    final isSelected = _filterIndex == index;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterIndex = index;
        });
      },
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
    );
  }

  Widget _buildUserCard(BuildContext context, UserCredential user,
      FirebaseAuthService authService, bool isCurrentUser) {
    final isAdmin = user.userType == 'admin';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              user.profileImage != null ? NetworkImage(user.profileImage!) : null,
          child: user.profileImage == null
              ? Text(
                  user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : null,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (isAdmin)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(user.email),
            if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                user.phoneNumber!,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
        trailing: isCurrentUser
            ? const Chip(
                label: Text('You'),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )
            : PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          isAdmin ? Icons.person : Icons.admin_panel_settings,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(isAdmin ? 'Remove Admin' : 'Make Admin'),
                      ],
                    ),
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 100), () async {
                        final success = await authService.toggleAdminStatus(user.uid);
                        if (!mounted) return;
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? (isAdmin
                                      ? 'Admin access removed'
                                      : 'Admin access granted')
                                  : 'Failed to update user',
                            ),
                            backgroundColor: success ? Colors.green : Colors.red,
                          ),
                        );
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete User', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _showDeleteDialog(context, user, authService);
                      });
                    },
                  ),
                ],
              ),
        isThreeLine: true,
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, UserCredential user, FirebaseAuthService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
            'Are you sure you want to delete "${user.fullName}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await authService.deleteUser(user.uid);
              if (!mounted) return;
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? 'User deleted' : 'Failed to delete user'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}