import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/mock_data/mock_products.dart';
import '../../../data/models/product.dart';
import '../widgets/product_grid.dart';

class CategoryPage extends StatefulWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late List<Product> _filteredProducts;
  String _sortBy = 'popularity';

  @override
  void initState() {
    super.initState();
    _filterProducts();
  }

  void _filterProducts() {
    _filteredProducts = MockProducts.products
        .where((product) => product.category == widget.category)
        .toList();

    // Sort products
    switch (_sortBy) {
      case 'price_low':
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'popularity':
      default:
        // Assume popularity is based on review count
        _filteredProducts.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sort options
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Sort by:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(
                      value: 'popularity',
                      child: Text('Popularity'),
                    ),
                    DropdownMenuItem(
                      value: 'price_low',
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: 'price_high',
                      child: Text('Price: High to Low'),
                    ),
                    DropdownMenuItem(
                      value: 'rating',
                      child: Text('Rating'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sortBy = value;
                        _filterProducts();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Products grid
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(
                    child: Text('No products found in this category'),
                  )
                : ProductGrid(
                    products: _filteredProducts,
                    onProductTap: (productId) {
                      Navigator.pushNamed(
                        context,
                        '/product/$productId',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Price Range',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            RangeSlider(
              values: const RangeValues(0, 1000),
              min: 0,
              max: 1000,
              divisions: 10,
              labels: const RangeLabels('\$0', '\$1000'),
              onChanged: (RangeValues values) {
                // Implement price range filter
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Rating',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  color: index < 4 ? AppColors.secondary : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}