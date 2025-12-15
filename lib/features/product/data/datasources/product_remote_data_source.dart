import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final SupabaseClient supabase;

  ProductRemoteDataSource(this.supabase);

  // 1. Ambil Semua Produk
  Future<List<ProductModel>> getProducts() async {
    try {
      // Select * from products order by created_at desc
      final response = await supabase
          .from('products')
          .select()
          .order('created_at', ascending: false);

      // Ubah list json menjadi List<ProductModel>
      return (response as List).map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      throw 'Gagal mengambil data produk: $e';
    }
  }

  // 2. Tambah Produk Baru
  Future<void> addProduct(ProductModel product) async {
    try {
      await supabase.from('products').insert(product.toJson());
    } catch (e) {
      throw 'Gagal menambah produk: $e';
    }
  }
}