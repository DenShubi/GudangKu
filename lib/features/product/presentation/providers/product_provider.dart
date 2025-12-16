import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepositoryImpl repository;
  
  // Kita butuh akses ke Supabase client langsung untuk Storage (khusus addProduct versi ini)
  final SupabaseClient supabase = Supabase.instance.client;

  ProductProvider(this.repository);

  // State
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // 1. Fetch Products
  Future<void> fetchProducts() async {
  _isLoading = true;
  notifyListeners(); // Update UI jadi loading
  
  try {
    print("Fetching products..."); // Debug log
    _products = await repository.getProducts();
    print("Fetched ${_products.length} products"); // Debug log
    _errorMessage = null;
  } catch (e) {
    print("Error fetching products: $e"); // Debug log
    _errorMessage = e.toString();
  }
  
  _isLoading = false;
  notifyListeners(); // Update UI setelah selesai
}

  // 2. Add Product
  Future<bool> addProduct(
    String name,
    String price,
    String stock,
    String category,
    String desc,
    File? imageFile,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      String? imageUrl;

      // --- LOGIKA UPLOAD GAMBAR (Untuk Add) ---
      if (imageFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        const bucketName = 'product-images';
        
        await supabase.storage.from(bucketName).upload(fileName, imageFile);
        imageUrl = supabase.storage.from(bucketName).getPublicUrl(fileName);
      }
      // ---------------------------

      final doublePrice = double.tryParse(price) ?? 0.0;
      final intStock = int.tryParse(stock) ?? 0;

      final newProduct = ProductModel(
        id: '', // ID akan di-generate otomatis oleh DB
        name: name,
        price: doublePrice,
        stock: intStock,
        category: category,
        description: desc,
        imageUrl: imageUrl,
      );

      await repository.addProduct(newProduct);
      await fetchProducts();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct({
    required String id,
    required String name,
    required String price,
    required String stock,
    required String category,
    required String description,
    required String? oldImageUrl, // URL lama (jika tidak ganti gambar)
    File? newImageFile,           // File baru (jika ganti gambar)
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final doublePrice = double.tryParse(price) ?? 0.0;
      final intStock = int.tryParse(stock) ?? 0;

      // Kita buat objek model sementara.
      // Note: imageUrl diisi oldImageUrl dulu. 
      // Jika ada newImageFile, DataSource akan menimpanya dengan URL baru.
      final productToUpdate = ProductModel(
        id: id,
        name: name,
        price: doublePrice,
        stock: intStock,
        category: category,
        description: description,
        imageUrl: oldImageUrl, 
      );

      await repository.updateProduct(
        product: productToUpdate, 
        newImageFile: newImageFile
      );

      // Refresh data agar tampilan list terupdate otomatis
      await fetchProducts(); 

      _isLoading = false;
      notifyListeners();
      return true; // Berhasil
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false; // Gagal
    }
  }
}