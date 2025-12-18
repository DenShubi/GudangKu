class ProductModel {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String description;
  final String? imageUrl;

  // Foreign Key IDs
  final String? categoryId;
  final String? supplierId;

  // Data relasi (untuk tampilan UI, diambil dari join query)
  final String? categoryName;
  final String? supplierName;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    this.imageUrl,
    this.categoryId,
    this.supplierId,
    this.categoryName,
    this.supplierName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Ambil data relasi dari nested object (hasil join query)
    final categoriesData = json['categories'];
    final suppliersData = json['suppliers'];

    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      description: json['description'] ?? '-',
      imageUrl: json['image_url'],
      // Foreign key IDs
      categoryId: json['category_id'],
      supplierId: json['supplier_id'],
      // Nama dari relasi (untuk tampilan)
      categoryName: categoriesData != null ? categoriesData['name'] : (json['category'] ?? '-'),
      supplierName: suppliersData != null ? suppliersData['name'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'price': price,
      'stock': stock,
      'description': description,
      // Kirim ID relasi, bukan nama
      'category_id': categoryId,
      'supplier_id': supplierId,
    };

    if (imageUrl != null) {
      data['image_url'] = imageUrl;
    }

    return data;
  }

  // CopyWith untuk kemudahan update
  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    int? stock,
    String? description,
    String? imageUrl,
    String? categoryId,
    String? supplierId,
    String? categoryName,
    String? supplierName,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      supplierId: supplierId ?? this.supplierId,
      categoryName: categoryName ?? this.categoryName,
      supplierName: supplierName ?? this.supplierName,
    );
  }
}