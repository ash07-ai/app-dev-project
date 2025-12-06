import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  // Fetch products with pagination
  static Future<Map<String, dynamic>> fetchProducts({
    int page = 1,
    int limit = 12,
    String? searchQuery,
  }) async {
    try {
      final skip = (page - 1) * limit;
      String url;

      if (searchQuery != null && searchQuery.isNotEmpty) {
        url = '$baseUrl/products/search?q=$searchQuery&limit=$limit&skip=$skip';
      } else {
        url = '$baseUrl/products?limit=$limit&skip=$skip';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = (data['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();

        return {
          'products': products,
          'total': data['total'],
          'skip': data['skip'],
          'limit': data['limit'],
        };
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Fetch products by category
  static Future<Map<String, dynamic>> fetchProductsByCategory({
    required String category,
    int page = 1,
    int limit = 12,
  }) async {
    try {
      final skip = (page - 1) * limit;
      final url = '$baseUrl/products/category/$category?limit=$limit&skip=$skip';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = (data['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();

        return {
          'products': products,
          'total': data['total'],
          'skip': data['skip'],
          'limit': data['limit'],
        };
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

static Future<List<String>> fetchCategories() async {
  try {
    final response =
        await http.get(Uri.parse('$baseUrl/products/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((cat) {
        if (cat is Map<String, dynamic>) {
          return cat['slug'] as String; // e.g. "beauty"
        } else {
          return cat.toString();
        }
      }).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  } catch (e) {
    throw Exception('Error fetching categories: $e');
  }
}

  static Future<Product> fetchProduct(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }
}