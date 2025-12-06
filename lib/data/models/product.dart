class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final List<String>? images;
  final String? brand;
  final double? discountPercentage;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    this.images,
    this.brand,
    this.discountPercentage,
  });

  // Factory constructor to create Product from JSON (DummyJSON API)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? 'Unknown Product',
      description: json['description'] ?? 'No description available',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['thumbnail'] ?? json['images']?[0] ?? '',
      category: json['category'] ?? 'Uncategorized',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['stock'] ?? 0, // Using stock as review count placeholder
      inStock: (json['stock'] ?? 0) > 0,
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : null,
      brand: json['brand'],
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
    );
  }

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'description': description,
      'price': price,
      'thumbnail': imageUrl,
      'category': category,
      'rating': rating,
      'stock': reviewCount,
      'images': images,
      'brand': brand,
      'discountPercentage': discountPercentage,
    };
  }
}