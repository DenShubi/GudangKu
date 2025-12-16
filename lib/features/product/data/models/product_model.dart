class ProductModel {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String category;
  final String description;
  final String? imageUrl; 

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
    this.imageUrl, 
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      category: json['category'] ?? '-',
      description: json['description'] ?? '-',
      imageUrl: json['image_url'], 
    );
  }

  Map<String, dynamic> toJson() {
    // Jika imageUrl null, jangan kirim key 'image_url' agar tidak error di DB
    final Map<String, dynamic> data = {
      'name': name,
      'price': price,
      'stock': stock,
      'category': category,
      'description': description,
    };
    
    if (imageUrl != null) {
       data['image_url'] = imageUrl;
    }

    return data;
  }
}