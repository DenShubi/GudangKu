import 'dart:io'; // [IMPORT BARU]
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // [IMPORT BARU] untuk akses client
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepositoryImpl repository;
  // Kita butuh akses ke Supabase client langsung untuk Storage
  final SupabaseClient supabase = Supabase.instance.client;

  ProductProvider(this.repository);

  // ... (State lainnya sama) ...
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    // ... (Fungsi fetch tidak berubah) ...
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

  // UPDATE FUNGSI ADD PRODUCT
  Future<bool> addProduct(
    String name,
    String price,
    String stock,
    String category,
    String desc,
    File? imageFile, // [PARAMETER BARU] Terima file gambar
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      String? imageUrl;

      // --- LOGIKA UPLOAD GAMBAR ---
      if (imageFile != null) {
        // 1. Buat nama file unik (pakai timestamp agar tidak bentrok)
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final path = 'uploads/$fileName';

        // 2. Upload file ke bucket 'product-images'
        await supabase.storage.from('product-images').upload(path, imageFile);

        // 3. Dapatkan URL publik dari file yang diupload
        imageUrl = supabase.storage.from('product-images').getPublicUrl(path);
      }
      // ---------------------------

      final doublePrice = double.tryParse(price) ?? 0.0;
      final intStock = int.tryParse(stock) ?? 0;

      // Update Model agar menerima image url (Lihat Langkah 5 di bawah)
      final newProduct = ProductModel(
        id: '',
        name: name,
        price: doublePrice,
        stock: intStock,
        category: category,
        description: desc,
        imageUrl: imageUrl, // [BARU] Simpan URL ke model
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
}