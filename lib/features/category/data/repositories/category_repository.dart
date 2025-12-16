import 'dart:io';
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
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<void> addCategory({
    required String name,
    required String description,
    required bool isActive,
    String hexColor = '0xFFE5E5E5',
    File? imageFile,
  }) async {
    try {
      String? imageUrl;

      // Upload gambar jika ada
      if (imageFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await _supabase.storage.from('categories').upload(
              fileName,
              imageFile,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );
        imageUrl = _supabase.storage.from('categories').getPublicUrl(fileName);
      }

      await _supabase.from('categories').insert({
        'name': name,
        'description': description,
        'is_active': isActive,
        'hex_color': hexColor,
        'image_url': imageUrl,
      });
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String description,
    required bool isActive,
    String hexColor = '0xFFE5E5E5',
    String? oldImageUrl,
    File? newImageFile,
  }) async {
    try {
      String? imageUrl = oldImageUrl;

      // Upload gambar baru jika ada
      if (newImageFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await _supabase.storage.from('categories').upload(
              fileName,
              newImageFile,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );
        imageUrl = _supabase.storage.from('categories').getPublicUrl(fileName);
      }

      await _supabase.from('categories').update({
        'name': name,
        'description': description,
        'is_active': isActive,
        'hex_color': hexColor,
        'image_url': imageUrl,
      }).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  /// Deletes a category and all related products from the database.
  Future<void> deleteCategory(String id) async {
    try {
      // 1. Ambil nama kategori terlebih dahulu
      final categoryResponse = await _supabase
          .from('categories')
          .select('name')
          .eq('id', id)
          .maybeSingle();
      
      if (categoryResponse != null) {
        final categoryName = categoryResponse['name'] as String;
        
        // 2. Hapus semua produk yang memiliki kategori ini
        await _supabase.from('products').delete().eq('category', categoryName);
      }
      
      // 3. Hapus kategori
      await _supabase.from('categories').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}