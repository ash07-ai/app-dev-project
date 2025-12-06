import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _adminProducts = []; // Products added by admin
  bool _isLoading = false;

  List<Product> get products => [..._products, ..._adminProducts];
  List<Product> get adminProducts => [..._adminProducts];
  bool get isLoading => _isLoading;

  // Load products from API
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await ApiService.fetchProducts(limit: 100);
      _products = result['products'] as List<Product>;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load products: $e');
    }
  }

  // Add a new product (admin only)
  void addProduct(Product product) {
    _adminProducts.add(product);
    notifyListeners();
  }

  // Update an existing product
  void updateProduct(String productId, Product updatedProduct) {
    // Ensure the updated product has the same ID as the original
    final productToUpdate = Product(
      id: productId, // Always use the original productId
      name: updatedProduct.name,
      description: updatedProduct.description,
      price: updatedProduct.price,
      imageUrl: updatedProduct.imageUrl,
      category: updatedProduct.category,
      rating: updatedProduct.rating,
      reviewCount: updatedProduct.reviewCount,
      inStock: updatedProduct.inStock,
      images: updatedProduct.images,
      brand: updatedProduct.brand,
      discountPercentage: updatedProduct.discountPercentage,
    );

    // First, check if it's already an admin product - update in place
    final adminIndex = _adminProducts.indexWhere((p) => p.id == productId);
    if (adminIndex >= 0) {
      _adminProducts[adminIndex] = productToUpdate;
      notifyListeners();
      return;
    }

    // If it's an API product, we can't modify it directly
    // So we remove any existing admin version with same ID and add the updated one
    _adminProducts.removeWhere((p) => p.id == productId);
    _adminProducts.add(productToUpdate);
    notifyListeners();
  }

  // Delete a product
  void deleteProduct(String productId) {
    _adminProducts.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  // Get product by ID
  Product? getProductById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search products
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return products;
    final lowerQuery = query.toLowerCase();
    return products.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery) ||
          product.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Get products by category
  List<Product> getProductsByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }
}

