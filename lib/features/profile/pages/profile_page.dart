import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/routes.dart';
import '../../../core/services/firebase_auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser;

        // If no user is logged in, redirect to login
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Profile image
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: user.profileImage != null
                              ? NetworkImage(user.profileImage!)
                              : null,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: user.profileImage == null
                              ? Text(
                                  user.fullName.isNotEmpty
                                      ? user.fullName[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),

                        // User details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (user.userType == 'admin') ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Admin',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Edit button
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditProfileDialog(context, authService, user);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // User Info Card
                if (user.phoneNumber != null || user.address != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contact Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (user.phoneNumber != null) ...[
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 20, color: AppColors.textSecondary),
                                const SizedBox(width: 12),
                                Text(user.phoneNumber!),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (user.address != null)
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 20, color: AppColors.textSecondary),
                                const SizedBox(width: 12),
                                Expanded(child: Text(user.address!)),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Profile options
                Card(
                  child: Column(
                    children: [
                      _buildProfileOption(
                        context,
                        icon: Icons.person,
                        title: 'Account Settings',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.settings);
                        },
                      ),
                      const Divider(height: 1),
                      _buildProfileOption(
                        context,
                        icon: Icons.shopping_bag,
                        title: 'My Orders',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.orders);
                        },
                      ),
                      const Divider(height: 1),
                      _buildProfileOption(
                        context,
                        icon: Icons.favorite,
                        title: 'Wishlist',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.wishlist);
                        },
                      ),
                      const Divider(height: 1),
                      _buildProfileOption(
                        context,
                        icon: Icons.location_on,
                        title: 'Shipping Addresses',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.shippingAddresses);
                        },
                      ),
                      const Divider(height: 1),
                      _buildProfileOption(
                        context,
                        icon: Icons.payment,
                        title: 'Payment Methods',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.paymentMethods);
                        },
                      ),
                      if (user.userType == 'admin') ...[
                        const Divider(height: 1),
                        _buildProfileOption(
                          context,
                          icon: Icons.admin_panel_settings,
                          title: 'Admin Dashboard',
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.admin);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Support and logout
                Card(
                  child: Column(
                    children: [
                      _buildProfileOption(
                        context,
                        icon: Icons.help,
                        title: 'Help & Support',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Support coming soon!')),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _buildProfileOption(
                        context,
                        icon: Icons.info,
                        title: 'About Us',
                        onTap: () {
                          _showAboutDialog(context);
                        },
                      ),
                      const Divider(height: 1),
                      _buildProfileOption(
                        context,
                        icon: Icons.logout,
                        title: 'Logout',
                        textColor: Colors.red,
                        onTap: () {
                          _showLogoutDialog(context, authService);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    FirebaseAuthService authService,
    UserCredential user,
  ) {
    final nameController = TextEditingController(text: user.fullName);
    final phoneController = TextEditingController(text: user.phoneNumber ?? '');
    final addressController = TextEditingController(text: user.address ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await authService.updateUserProfile(
                fullName: nameController.text.trim(),
                phoneNumber: phoneController.text.trim(),
                address: addressController.text.trim(),
              );

              if (!context.mounted) return;

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success ? 'Profile updated successfully!' : 'Failed to update profile',
                  ),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, FirebaseAuthService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await authService.logout();
              if (!context.mounted) return;
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About E-Shop'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'E-Shop',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text('Your one-stop shop for all your needs!'),
            SizedBox(height: 8),
            Text('Built with Flutter & Firebase'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}