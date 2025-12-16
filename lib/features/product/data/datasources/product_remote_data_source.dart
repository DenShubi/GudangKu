import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';
import 'dart:io';


class ProductRemoteDataSource {
  final SupabaseClient client;

  ProductRemoteDataSource(this.client);

  // 1. Ambil Data (Restore logika agar list tidak kosong)
  Future<List<ProductModel>> getProducts() async {
    try {
      // Mengambil data dari tabel 'products' diurutkan dari yang terbaru
      final response = await client
          .from('products')
          .select()
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Failed to fetch products: $e");
    }
  }

  // 2. Tambah Data
  Future<void> addProduct(ProductModel product) async {
    try {
      // Mengirim data JSON ke database
      await client.from('products').insert(product.toJson());
    } catch (e) {
      throw Exception("Failed to add product: $e");
    }
  }

  Future<void> updateProduct({
    required ProductModel product,
    File? newImageFile,
  }) async {
    try {
      Map<String, dynamic> dataToUpdate = product.toJson();

      // 1. Jika ada gambar baru, upload dulu
      if (newImageFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        const bucketName = 'product-images';

        await client.storage.from(bucketName).upload(fileName, newImageFile);
        final newImageUrl = client.storage.from(bucketName).getPublicUrl(fileName);
        
        // Update field image_url dengan URL baru
        dataToUpdate['image_url'] = newImageUrl;
      }

      // 2. Update data di tabel berdasarkan ID
      await client
          .from('products')
          .update(dataToUpdate)
          .eq('id', product.id); 
          
    } catch (e) {
      throw Exception("Failed to update product: $e");
    }
  }
}