import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final SupabaseClient _supabase;

  CategoryRepository(this._supabase);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil kategori: $e');
    }
  }

  Future<void> addCategory({
    required String name,
    required String description,
    required bool isActive,
    String hexColor = '0xFFE5E5E5', // Default warna
  }) async {
    try {
      await _supabase.from('categories').insert({
        'name': name,
        'description': description,
        'is_active': isActive,
        'hex_color': hexColor,
      });
    } catch (e) {
      throw Exception('Gagal menambah kategori: $e');
    }
  }
}