import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'cart_item.dart';

enum OrderStatus {
  pending,
  shipped,
  delivered,
  cancelled,
  processing,
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime orderDate;          // 🔹 keep the old name used everywhere
  final String? paymentMethod;
  final String? shippingAddress;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.paymentMethod,
    this.shippingAddress,
  });

  /// for updateOrderStatus
Order copyWith({
  String? id,
  String? userId,
  List<CartItem>? items,
  double? totalAmount,
  OrderStatus? status,
  DateTime? orderDate,
  String? paymentMethod,
  String? shippingAddress,
}) {
  return Order(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    items: items ?? this.items,
    totalAmount: totalAmount ?? this.totalAmount,
    status: status ?? this.status,
    orderDate: orderDate ?? this.orderDate,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    shippingAddress: shippingAddress ?? this.shippingAddress,
  );
}

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((e) => e.toMap()).toList(), // 🔹 needs CartItem.toMap
      'totalAmount': totalAmount,
      'status': status.name, // "pending" etc.
      'orderDate': firestore.Timestamp.fromDate(orderDate),
      'paymentMethod': paymentMethod,
      'shippingAddress': shippingAddress,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromMap(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      orderDate: (map['orderDate'] is firestore.Timestamp)
          ? (map['orderDate'] as firestore.Timestamp).toDate()
          : DateTime.now(),
      paymentMethod: map['paymentMethod'],
      shippingAddress: map['shippingAddress'],
    );
  }
}
