import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/mock_data/mock_products.dart';
import '../../../data/models/product.dart';

class ProductReviewPage extends StatefulWidget {
  final String productId;

  const ProductReviewPage({super.key, required this.productId});

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  late Product _product;
  final _reviewController = TextEditingController();
  double _userRating = 5.0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _product = MockProducts.products.firstWhere(
      (product) => product.id == widget.productId,
      orElse: () => MockProducts.products.first,
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write a review'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isSubmitting = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _reviewController.clear();
      setState(() {
        _userRating = 5.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Reviews'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Product info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(_product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < _product.rating.floor()
                                ? Icons.star
                                : index < _product.rating
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: AppColors.secondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_product.rating} (${_product.reviewCount} reviews)',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Write a review
          const Text(
            'Write a Review',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Rating selector
          Row(
            children: [
              const Text('Your Rating: '),
              const SizedBox(width: 8),
              ...List.generate(
                5,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _userRating = index + 1.0;
                    });
                  },
                  child: Icon(
                    index < _userRating ? Icons.star : Icons.star_border,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Review text field
          TextField(
            controller: _reviewController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Write your review here...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Review'),
            ),
          ),
          const SizedBox(height: 24),
          
          // Reviews list
          const Text(
            'Customer Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Sample reviews
          _buildReviewItem(
            name: 'John Doe',
            rating: 5.0,
            date: '2023-05-15',
            comment: 'Excellent product! Exactly as described and arrived on time.',
          ),
          const Divider(),
          _buildReviewItem(
            name: 'Jane Smith',
            rating: 4.0,
            date: '2023-05-10',
            comment: 'Good quality product. Shipping was a bit slow but overall satisfied.',
          ),
          const Divider(),
          _buildReviewItem(
            name: 'Mike Johnson',
            rating: 3.5,
            date: '2023-05-05',
            comment: 'Average product. It works but not as good as I expected for the price.',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required double rating,
    required String date,
    required String comment,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  index < rating.floor()
                      ? Icons.star
                      : index < rating
                          ? Icons.star_half
                          : Icons.star_border,
                  color: AppColors.secondary,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment),
        ],
      ),
    );
  }
}