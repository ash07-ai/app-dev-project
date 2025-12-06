import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/routes.dart';
import '../../../data/mock_data/mock_users.dart';
import '../../../data/providers/order_provider.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/models/order.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Fetch orders when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats cards
                _buildStatsSection(context, orderProvider),
                const SizedBox(height: 24),

                // Quick actions
                _buildQuickActionsSection(context),
                const SizedBox(height: 24),

                // Recent orders
                _buildRecentOrdersSection(context, orderProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, OrderProvider orderProvider) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard(
                  context,
                  title: 'Products',
                  value: productProvider.products.length.toString(),
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                ),
                _buildStatCard(
                  context,
                  title: 'Users',
                  value: MockUsers.users.length.toString(),
                  icon: Icons.people,
                  color: Colors.green,
                ),
                _buildStatCard(
                  context,
                  title: 'Orders',
                  value: orderProvider.totalOrders.toString(),
                  icon: Icons.shopping_bag,
                  color: Colors.orange,
                ),
                _buildStatCard(
                  context,
                  title: 'Revenue',
                  value:
                      '${AppConstants.currencySymbol}${orderProvider.totalRevenue.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const Spacer(),
                Icon(Icons.trending_up, color: Colors.green, size: 20),
                const SizedBox(width: 4),
                Text(
                  '+12%',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                title: 'Add Product',
                icon: Icons.add_circle,
                color: AppColors.primary,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.productManagement);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                context,
                title: 'Manage Orders',
                icon: Icons.list_alt,
                color: Colors.orange,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.orderManagement);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                title: 'User Management',
                icon: Icons.people,
                color: Colors.green,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.userManagement);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                context,
                title: 'Analytics',
                icon: Icons.bar_chart,
                color: Colors.purple,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.analytics);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentOrdersSection(
    BuildContext context,
    OrderProvider orderProvider,
  ) {
    // Fetch orders if not already loaded
    if (orderProvider.orders.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProvider.fetchAllOrders();
      });
    }
    final recentOrders = orderProvider.getRecentOrders(count: 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Orders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.orderManagement);
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: recentOrders.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No orders yet',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentOrders.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final order = recentOrders[index];
                    final itemCount = order.items.fold(
                      0,
                      (sum, item) => sum + item.quantity,
                    );
                    return ListTile(
                      title: Text(
                        'Order #${order.id.substring(order.id.length - 6)}',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('User: ${order.userId}'),
                          const SizedBox(height: 4),
                          Text(
                            '${itemCount} item${itemCount != 1 ? 's' : ''} • ${AppConstants.currencySymbol}${order.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: _buildOrderStatusChip(order.status),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.orderManagement);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildOrderStatusChip(OrderStatus status) {
    String label;
    Color color;

    switch (status) {
      case OrderStatus.pending:
        label = 'Pending';
        color = Colors.orange;
        break;
      case OrderStatus.processing:
        label = 'Processing';
        color = Colors.blue;
        break;
      case OrderStatus.shipped:
        label = 'Shipped';
        color = Colors.purple;
        break;
      case OrderStatus.delivered:
        label = 'Delivered';
        color = Colors.green;
        break;
      case OrderStatus.cancelled:
        label = 'Cancelled';
        color = Colors.red;
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
