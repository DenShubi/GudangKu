import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

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
      throw Exception("Gagal mengambil produk: $e");
    }
  }

  // 2. Tambah Data
  Future<void> addProduct(ProductModel product) async {
    try {
      // Mengirim data JSON ke database
      await client.from('products').insert(product.toJson());
    } catch (e) {
      throw Exception("Gagal menambah produk: $e");
    }
  }

  // [FITUR EDIT SUDAH DIHAPUS SESUAI PERMINTAAN]
}