// lib/data/providers/order_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/order.dart';
// Import these if not already imported
import '../models/cart_item.dart';
import '../models/product.dart';

class OrderProvider extends ChangeNotifier {
  final firestore.FirebaseFirestore _firestore =
      firestore.FirebaseFirestore.instance;

  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  // Get orders sorted by date (newest first)
  List<Order> get ordersByDate {
    final sortedOrders = List<Order>.from(_orders);
    sortedOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    return sortedOrders;
  }

  // Get total number of orders
  int get totalOrders => _orders.length;

  // Get total revenue from all orders
  double get totalRevenue {
    return _orders.fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  // Get pending orders count
  int get pendingOrdersCount {
    return _orders.where((order) => order.status == OrderStatus.pending).length;
  }

  // Get orders by status
  List<Order> getOrdersByStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // Get recent orders
  List<Order> getRecentOrders({int count = 5}) {
    final sorted = ordersByDate;
    return sorted.take(count).toList();
  }

  // Get orders for a specific user
  List<Order> getOrdersByUser(String userId) {
    return _orders.where((order) => order.userId == userId).toList();
  }

  /// Add new order to Firestore
  Future<void> addOrder(Order order) async {
    try {
      // Convert order to Firestore format
      final orderData = {
        'userId': order.userId,
        'totalAmount': order.totalAmount,
        'status': order.status.toString().split('.').last,
        'orderDate': firestore.Timestamp.fromDate(order.orderDate),
        'paymentMethod': order.paymentMethod,
        'shippingAddress': order.shippingAddress,
        'items': order.items
            .map(
              (item) => {
                'productId': item.product.id,
                'productName': item.product.name,
                'productImage': item.product.imageUrl,
                'productPrice': item.product.price,
                'quantity': item.quantity,
              },
            )
            .toList(),
        'createdAt': firestore.FieldValue.serverTimestamp(),
      };

      // Add to Firestore
      await _firestore.collection('orders').doc(order.id).set(orderData);

      // Add to local list
      _orders.add(order);
      notifyListeners();

      print('✅ Order added successfully: ${order.id}');
    } catch (e) {
      print('❌ Error adding order to Firestore: $e');
      rethrow;
    }
  }

  /// Fetch all orders from Firestore (for admin)
  Future<void> fetchAllOrders() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .get();

      _orders = snapshot.docs.map((doc) {
        return _orderFromFirestore(doc);
      }).toList();

      _isLoading = false;
      notifyListeners();

      print('✅ Fetched ${_orders.length} orders');
    } catch (e) {
      print('❌ Error fetching orders: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch orders for specific user
  Future<void> fetchUserOrders(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Fetch without orderBy to avoid index requirement
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      // Sort in memory instead of in query
      _orders = snapshot.docs.map((doc) {
        return _orderFromFirestore(doc);
      }).toList();

      // Sort by date descending
      _orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));

      _isLoading = false;
      notifyListeners();

      print('✅ Fetched ${_orders.length} orders for user: $userId');
    } catch (e) {
      print('❌ Error fetching user orders: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Listen to orders in real-time (for admin)
  Stream<List<Order>> getOrdersStream() {
    return _firestore
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => _orderFromFirestore(doc)).toList();
        });
  }

  /// Listen to user orders in real-time
  Stream<List<Order>> getUserOrdersStream(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => _orderFromFirestore(doc))
              .toList();
          // Sort by date descending in memory
          orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
          return orders;
        });
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus.toString().split('.').last,
        'updatedAt': firestore.FieldValue.serverTimestamp(),
      });

      // Update local list
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: newStatus);
        notifyListeners();
      }

      print('✅ Order status updated: $orderId -> $newStatus');
    } catch (e) {
      print('❌ Error updating order status: $e');
      rethrow;
    }
  }

  /// Delete order (admin only)
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();

      _orders.removeWhere((order) => order.id == orderId);
      notifyListeners();

      print('✅ Order deleted: $orderId');
    } catch (e) {
      print('❌ Error deleting order: $e');
      rethrow;
    }
  }

  /// Helper: Convert Firestore document to Order object
  Order _orderFromFirestore(firestore.DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Order(
      id: doc.id,
      userId: data['userId'] ?? '',
      items:
          (data['items'] as List<dynamic>?)?.map((item) {
            return CartItem(
              id: item['productId'] ?? '',
              product: Product(
                id: item['productId']?.toString() ?? '',
                name: item['productName'] ?? '',
                description: item['productDescription'] ?? '',
                price: (item['productPrice'] ?? 0).toDouble(),
                imageUrl: item['productImage'] ?? '',
                category: item['productCategory'] ?? '',
                rating: (item['productRating'] ?? 0).toDouble(),
                reviewCount: (item['productReviews'] ?? 0) as int,
                inStock: (item['productInStock'] ?? true) as bool,
              ),
              quantity: item['quantity'] ?? 1,
            );
          }).toList() ??
          [],
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      status: _statusFromString(data['status'] ?? 'pending'),
      orderDate:
          (data['orderDate'] as firestore.Timestamp?)?.toDate() ??
          DateTime.now(),
      paymentMethod: data['paymentMethod'],
      shippingAddress: data['shippingAddress'],
    );
  }

  /// Helper: Convert string to OrderStatus
  OrderStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
