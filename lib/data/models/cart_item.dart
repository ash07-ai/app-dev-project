import 'product.dart';

class CartItem
{
  final String id;
  final Product product;
  int quantity;

  CartItem(
    {
    required this.id,
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      product: Product.fromJson(map['product'] as Map<String, dynamic>), // ✅ Product.fromJson()
      quantity: (map['quantity'] ?? 1) as int,
    );
  }
}
