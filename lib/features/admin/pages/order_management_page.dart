import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../data/providers/order_provider.dart';
import '../../../data/models/order.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  OrderStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = context.read<OrderProvider>();
      if (orderProvider.orders.isEmpty) {
        orderProvider.fetchAllOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<OrderProvider>().fetchAllOrders();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Orders refreshed')));
            },
          ),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final orders = _selectedFilter == null
              ? orderProvider.ordersByDate
              : orderProvider.getOrdersByStatus(_selectedFilter!);

          return Column(
            children: [
              // Filter chips
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', null),
                      const SizedBox(width: 8),
                      _buildFilterChip('Pending', OrderStatus.pending),
                      const SizedBox(width: 8),
                      _buildFilterChip('Processing', OrderStatus.processing),
                      const SizedBox(width: 8),
                      _buildFilterChip('Shipped', OrderStatus.shipped),
                      const SizedBox(width: 8),
                      _buildFilterChip('Delivered', OrderStatus.delivered),
                      const SizedBox(width: 8),
                      _buildFilterChip('Cancelled', OrderStatus.cancelled),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),

              // Orders list
              Expanded(
                child: orders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No orders found',
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
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return _buildOrderCard(context, order, orderProvider);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, OrderStatus? status) {
    final isSelected = _selectedFilter == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? status : null;
        });
      },
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    Order order,
    OrderProvider orderProvider,
  ) {
    final totalItems = order.items.fold(0, (sum, item) => sum + item.quantity);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        children: [
          // Order header with status change button
          ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(order.status).withOpacity(0.1),
              child: Icon(
                Icons.shopping_bag,
                color: _getStatusColor(order.status),
              ),
            ),
            title: Text(
              'Order #${order.id.substring(order.id.length - 6)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('User: ${order.userId}'),
                const SizedBox(height: 4),
                Text(
                  '${_formatDate(order.orderDate)} • ${totalItems} item${totalItems != 1 ? 's' : ''}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: ${AppConstants.currencySymbol}${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [_buildStatusChip(order.status)],
            ),
          ),

          // Status change buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: order.status == OrderStatus.cancelled
                        ? null
                        : () => _showStatusChangeDialog(
                            context,
                            order,
                            orderProvider,
                          ),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Change Status'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showOrderDetails(context, order),
                  icon: const Icon(Icons.info_outline),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusChangeDialog(
    BuildContext context,
    Order order,
    OrderProvider orderProvider,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Order #${order.id.substring(order.id.length - 6)}'),
            const SizedBox(height: 16),
            const Text('Select new status:'),
            const SizedBox(height: 16),
            _buildStatusButton(
              ctx,
              'Pending',
              OrderStatus.pending,
              Icons.pending,
              Colors.orange,
              order,
              orderProvider,
            ),
            _buildStatusButton(
              ctx,
              'Processing',
              OrderStatus.processing,
              Icons.autorenew,
              Colors.blue,
              order,
              orderProvider,
            ),
            _buildStatusButton(
              ctx,
              'Shipped',
              OrderStatus.shipped,
              Icons.local_shipping,
              Colors.purple,
              order,
              orderProvider,
            ),
            _buildStatusButton(
              ctx,
              'Delivered',
              OrderStatus.delivered,
              Icons.check_circle,
              Colors.green,
              order,
              orderProvider,
            ),
            _buildStatusButton(
              ctx,
              'Cancelled',
              OrderStatus.cancelled,
              Icons.cancel,
              Colors.red,
              order,
              orderProvider,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(
    BuildContext ctx,
    String label,
    OrderStatus status,
    IconData icon,
    Color color,
    Order order,
    OrderProvider orderProvider,
  ) {
    final isCurrentStatus = order.status == status;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isCurrentStatus
            ? null
            : () async {
                try {
                  await orderProvider.updateOrderStatus(order.id, status);
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text('Order status updated to $label'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!ctx.mounted) return;
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update status: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isCurrentStatus ? Colors.grey : color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Order #${order.id.substring(order.id.length - 6)}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Order ID', order.id),
              _buildDetailRow('Date', _formatDate(order.orderDate)),
              _buildDetailRow('Status', _getStatusLabel(order.status)),
              _buildDetailRow('Payment Method', order.paymentMethod ?? 'N/A'),
              if (order.shippingAddress != null)
                _buildDetailRow('Shipping Address', order.shippingAddress!),
              const Divider(height: 24),
              const Text(
                'Products:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '• ${item.product.name} x${item.quantity} - ${AppConstants.currencySymbol}${item.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${AppConstants.currencySymbol}${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    return Chip(
      label: Text(
        _getStatusLabel(status),
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
      backgroundColor: _getStatusColor(status),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
