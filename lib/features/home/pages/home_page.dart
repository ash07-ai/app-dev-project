import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/routes.dart';
import '../../../data/services/api_service.dart';
import '../../../data/models/product.dart';
import '../../../data/providers/cart_provider.dart';
import '../widgets/category_list.dart';
import '../widgets/product_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _currentPage = 1;
  final int _itemsPerPage = 12;
  
  List<String> _categories = ['All'];
  List<Product> _products = [];
  int _totalProducts = 0;
  bool _isLoading = false;
  bool _hasError = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.fetchCategories();
      setState(() {
        _categories = ['All', ...categories];
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      Map<String, dynamic> result;
      
      if (_searchQuery.isNotEmpty) {
        result = await ApiService.fetchProducts(
          page: _currentPage,
          limit: _itemsPerPage,
          searchQuery: _searchQuery,
        );
      } else if (_selectedIndex > 0) {
        result = await ApiService.fetchProductsByCategory(
          category: _categories[_selectedIndex],
          page: _currentPage,
          limit: _itemsPerPage,
        );
      } else {
        result = await ApiService.fetchProducts(
          page: _currentPage,
          limit: _itemsPerPage,
        );
      }

      setState(() {
        _products = result['products'];
        _totalProducts = result['total'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading products: $e')),
      );
    }
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedIndex = index;
      _currentPage = 1;
      _searchQuery = '';
      _searchController.clear();
    });
    _loadProducts();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1;
      _selectedIndex = 0;
    });
    _loadProducts();
  }

  void _nextPage() {
    final totalPages = (_totalProducts / _itemsPerPage).ceil();
    if (_currentPage < totalPages) {
      setState(() {
        _currentPage++;
      });
      _loadProducts();
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final totalPages = (_totalProducts / _itemsPerPage).ceil();

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(onSearch: _onSearch),
              );
            },
          ),
          IconButton(
            icon: Badge(
              label: Text(cart.itemCount.toString()),
              isLabelVisible: cart.itemCount > 0,
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Categories
          CategoryList(
            categories: _categories,
            selectedIndex: _selectedIndex,
            onCategorySelected: _onCategorySelected,
          ),
          
          // Products grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            const Text('Failed to load products'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadProducts,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _products.isEmpty
                        ? const Center(child: Text('No products found'))
                        : ProductGrid(
                            products: _products,
                            onProductTap: (productId) {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.productDetail.replaceAll(':id', productId),
                              );
                            },
                          ),
          ),
          
          // Pagination controls
          if (!_isLoading && _products.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _currentPage > 1 ? _previousPage : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                  Text(
                    'Page $_currentPage of $totalPages',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _currentPage < totalPages ? _nextPage : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.favorites);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.cart);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.profile);
              break;
          }
        },
      ),
    );
  }
}

// Search delegate
class ProductSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;

  ProductSearchDelegate({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}