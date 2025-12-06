import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/providers/order_provider.dart';
import '../../../data/models/order.dart';


class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sales Analytics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Stats Grid
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatCard(
                      'Total Revenue',
                      '${AppConstants.currencySymbol}${orderProvider.totalRevenue.toStringAsFixed(2)}',
                      Icons.attach_money,
                      Colors.green,
                    ),
                    _buildStatCard(
                      'Total Orders',
                      orderProvider.totalOrders.toString(),
                      Icons.shopping_bag,
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'Pending Orders',
                      orderProvider.pendingOrdersCount.toString(),
                      Icons.pending,
                      Colors.orange,
                    ),
                    _buildStatCard(
                      'Delivered Orders',
                      orderProvider.getOrdersByStatus(OrderStatus.delivered).length.toString(),
                      Icons.check_circle,
                      Colors.purple,
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Order Status Breakdown
                const Text(
                  'Order Status Breakdown',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildStatusRow('Pending', orderProvider.getOrdersByStatus(OrderStatus.pending).length, Colors.orange),
                        _buildStatusRow('Processing', orderProvider.getOrdersByStatus(OrderStatus.processing).length, Colors.blue),
                        _buildStatusRow('Shipped', orderProvider.getOrdersByStatus(OrderStatus.shipped).length, Colors.purple),
                        _buildStatusRow('Delivered', orderProvider.getOrdersByStatus(OrderStatus.delivered).length, Colors.green),
                        _buildStatusRow('Cancelled', orderProvider.getOrdersByStatus(OrderStatus.cancelled).length, Colors.red),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Coming Soon Message
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'More detailed analytics and charts coming soon!',
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String status, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

