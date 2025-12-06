import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/product.dart';
import '../../../data/providers/favorites_provider.dart';
import '../../../data/providers/cart_provider.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(String) onProductTap;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<FavoritesProvider, CartProvider>(
      builder: (context, favoritesProvider, cartProvider, child) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final isFavorite = favoritesProvider.isFavorite(product.id);
            return ProductCard(
              product: product,
              onTap: () => onProductTap(product.id),
              isFavorite: isFavorite,
              onToggleFavorite: () => favoritesProvider.toggleFavorite(product.id),
              onAddToCart: () => cartProvider.addItem(product),
            );
          },
        );
      },
    );
  }
}