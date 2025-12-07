import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  // Optional extras for future use
  final VoidCallback? onAddToCart;
  final VoidCallback? onToggleFavorite;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAddToCart,
    this.onToggleFavorite,
    this.isFavorite = false,
  });

  /// Compute the original price before discount (for strike-through display)
  double? get _originalPrice {
    final discount = product.discountPercentage;
    if (discount == null || discount <= 0) return null;
    return product.price / (1 - discount / 100);
  }

  String get _displayImage {
    if (product.images != null &&
        product.images!.isNotEmpty &&
        product.images!.first.isNotEmpty) {
      return product.images!.first;
    }
    return product.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final originalPrice = _originalPrice;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Determine if we're on mobile (< 600px) or desktop/tablet
    final isMobile = screenWidth < 600;
    
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: isMobile ? 8 : 10,
                offset: Offset(0, isMobile ? 2 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- IMAGE + BADGES ----------
              Expanded(
                flex: isMobile ? 5 : 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isMobile ? 12 : 16),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Product image
                      Image.network(
                        _displayImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: isMobile ? 28 : 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),

                      // Favorite icon
                      Positioned(
                        top: isMobile ? 6 : 8,
                        right: isMobile ? 6 : 8,
                        child: InkWell(
                          onTap: onToggleFavorite,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(isMobile ? 5 : 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: isMobile ? 16 : 18,
                              color: isFavorite
                                  ? Colors.redAccent
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),

                      if (product.discountPercentage != null &&
                          product.discountPercentage! > 0)
                        Positioned(
                          left: isMobile ? 6 : 8,
                          top: isMobile ? 6 : 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 6 : 8,
                              vertical: isMobile ? 3 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                            ),
                            child: Text(
                              '-${product.discountPercentage!.toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 10 : 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Product details section - Responsive
              Expanded(
                flex: isMobile ? 4 : 2,
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 8 : 12),
                  child: isMobile
                      ? _buildMobileLayout(originalPrice)
                      : _buildDesktopLayout(originalPrice),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mobile layout (compact)
  Widget _buildMobileLayout(double? originalPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product name
        Expanded(
          child: Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Rating + Price
        Row(
          children: [
            const Icon(Icons.star, size: 12, color: AppColors.rating),
            const SizedBox(width: 2),
            Text(
              product.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${AppConstants.currencySymbol}${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Stock + Button
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: product.inStock
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                product.inStock ? 'In stock' : 'Out',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: product.inStock
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: SizedBox(
                height: 28,
                child: OutlinedButton(
                  onPressed: onAddToCart,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide(
                      color: AppColors.primary.withOpacity(0.6),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Icon(Icons.add_shopping_cart, size: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Desktop/Tablet layout (spacious)
  Widget _buildDesktopLayout(double? originalPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand (if available)
        if (product.brand != null && product.brand!.isNotEmpty)
          Text(
            product.brand!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),

        // Product name
        Flexible(
          child: Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Rating + reviews
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 16, color: AppColors.rating),
            const SizedBox(width: 2),
            Text(
              product.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${product.reviewCount})',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Price row
        Row(
          children: [
            Text(
              '${AppConstants.currencySymbol}${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 6),
            if (originalPrice != null)
              Flexible(
                child: Text(
                  '${AppConstants.currencySymbol}${originalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary.withOpacity(0.7),
                    decoration: TextDecoration.lineThrough,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),

        // Stock badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: product.inStock
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            product.inStock ? 'In stock' : 'Out of stock',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: product.inStock
                  ? Colors.green.shade700
                  : Colors.red.shade700,
            ),
          ),
        ),
        const Spacer(),

        // Add to cart button (full text on desktop)
        SizedBox(
          width: double.infinity,
          height: 36,
          child: OutlinedButton.icon(
            onPressed: onAddToCart,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              side: BorderSide(
                color: AppColors.primary.withOpacity(0.6),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.add_shopping_cart_outlined, size: 18),
            label: const Text('Add to cart', style: TextStyle(fontSize: 13)),
          ),
        ),
      ],
    );
  }
}