// import 'package:flutter/material.dart';
// import '../../../core/constants/colors.dart';
// import '../../../core/constants/app_constants.dart';
// import '../../../data/models/product.dart';

// class ProductCard extends StatelessWidget {
//   final Product product;
//   final VoidCallback onTap;

//   const ProductCard({
//     super.key,
//     required this.product,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product image
//             ClipRRect(
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//               child: AspectRatio(
//                 aspectRatio: 1,
//                 child: Image.network(
//                   product.imageUrl,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       color: Colors.grey[200],
//                       child: const Center(
//                         child: Icon(Icons.image_not_supported, size: 40),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
            
//             // Product details
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.name,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${AppConstants.currencySymbol}${product.price.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       color: AppColors.primary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.star,
//                         size: 16,
//                         color: Colors.amber,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         product.rating.toString(),
//                         style: TextStyle(fontSize: 12),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         '(${product.reviewCount})',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





























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

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- IMAGE + BADGES ----------
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
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
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              size: 32,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),

                      // Favorite icon
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: onToggleFavorite,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
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
                          left: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '-${product.discountPercentage!.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand (optional)
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

                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Rating + reviews
                    Row(
                      children: [
                        const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.rating,
                          ),
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
                          Text(
                            '${AppConstants.currencySymbol}${originalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary.withOpacity(0.7),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        const Spacer(),
                        // Stock pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: product.inStock
                                ?AppColors.successSoft
                                :AppColors.errorSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            product.inStock ? 'In stock' : 'Out of stock',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: product.inStock
                                  ?AppColors.successSoft
                                :AppColors.errorSoft,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Add to cart button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onAddToCart,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: BorderSide(
                            color: AppColors.primary.withOpacity(0.6),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.add_shopping_cart_outlined,
                          size: 18,
                        ),
                        label: const Text(
                          'Add to cart',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
