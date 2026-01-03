import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepositoryImpl repository;

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
  notifyListeners(); 
  
  try {
    _products = await repository.getProducts();
    _errorMessage = null;
  } catch (e) {
    _errorMessage = e.toString();
  }
  
  _isLoading = false;
  notifyListeners(); 
}

  // 2. Add Product
  Future<bool> addProduct(
    String name,
    String price,
    String stock,
    String? categoryId,  // Diubah ke ID
    String? supplierId,  // Tambah supplier ID
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
        final supabase = Supabase.instance.client;
        
        await supabase.storage.from(bucketName).upload(fileName, imageFile);
        imageUrl = supabase.storage.from(bucketName).getPublicUrl(fileName);
      }
      // ---------------------------

      final doublePrice = double.tryParse(price) ?? 0.0;
      final intStock = int.tryParse(stock) ?? 0;

      final newProduct = ProductModel(
        id: '', 
        name: name,
        price: doublePrice,
        stock: intStock,
        description: desc,
        imageUrl: imageUrl,
        categoryId: categoryId,
        supplierId: supplierId,
      );

      await repository.addProduct(newProduct);
      // Optimized: Fetch only once after operation to get server-generated data
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
    required String? categoryId,
    required String? supplierId,
    required String description,
    required String? oldImageUrl, 
    File? newImageFile,           
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final doublePrice = double.tryParse(price) ?? 0.0;
      final intStock = int.tryParse(stock) ?? 0;

      final productToUpdate = ProductModel(
        id: id,
        name: name,
        price: doublePrice,
        stock: intStock,
        description: description,
        imageUrl: oldImageUrl,
        categoryId: categoryId,
        supplierId: supplierId,
      );

      await repository.updateProduct(
        product: productToUpdate, 
        newImageFile: newImageFile
      );

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

  /// Deletes a product by ID.
  Future<bool> deleteProduct(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.deleteProduct(id);
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
}