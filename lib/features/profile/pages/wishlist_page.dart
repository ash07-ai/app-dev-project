import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/routes.dart';
import '../../../data/providers/favorites_provider.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/providers/cart_provider.dart';
import '../../home/widgets/product_grid.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: Consumer3<FavoritesProvider, ProductProvider, CartProvider>(
        builder: (context, favoritesProvider, productProvider, cartProvider, child) {
          // Ensure products are loaded
          if (productProvider.products.isEmpty && !productProvider.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              productProvider.loadProducts();
            });
          }

          final wishlistProducts = favoritesProvider.getFavoriteProducts(productProvider.products);

          if (wishlistProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on products to add them to your wishlist',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ProductGrid(
            products: wishlistProducts,
            onProductTap: (productId) {
              Navigator.pushNamed(
                context,
                AppRoutes.productDetail.replaceAll(':id', productId),
              );
            },
          );
        },
      ),
    );
  }
}

