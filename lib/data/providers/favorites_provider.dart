import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<String> _favoriteProductIds = [];

  List<String> get favoriteProductIds => [..._favoriteProductIds];

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }

  void addFavorite(String productId) {
    if (!_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.add(productId);
      notifyListeners();
    }
  }

  void removeFavorite(String productId) {
    _favoriteProductIds.remove(productId);
    notifyListeners();
  }

  List<Product> getFavoriteProducts(List<Product> allProducts) {
    return allProducts.where((product) => isFavorite(product.id)).toList();
  }

  int get favoriteCount => _favoriteProductIds.length;
}

