import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier
{
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  // Add item to cart
  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // Product already exists, update quantity
      _items[existingIndex] = CartItem(
        id: _items[existingIndex].id,
        product: product,
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      // Add new product
      _items.add(CartItem(
        id: DateTime.now().toString(),
        product: product,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  // Remove item from cart
  void removeItem(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String cartItemId, int quantity) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeItem(cartItemId);
      } else {
        _items[index] = CartItem(
          id: _items[index].id,
          product: _items[index].product,
          quantity: quantity,
        );
        notifyListeners();
      }
    }
  }

  // Increment quantity
  void incrementQuantity(String cartItemId) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      updateQuantity(cartItemId, _items[index].quantity + 1);
    }
  }

  // Decrement quantity
  void decrementQuantity(String cartItemId) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      updateQuantity(cartItemId, _items[index].quantity - 1);
    }
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // Get quantity of product in cart
  int getProductQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        id: '',
        product: Product(
          id: '',
          name: '',
          description: '',
          price: 0,
          imageUrl: '',
          category: '',
          rating: 0,
          reviewCount: 0,
          inStock: false,
        ),
        quantity: 0,
      ),
    );
    return item.quantity;
  }
}