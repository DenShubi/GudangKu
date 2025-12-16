import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/supplier_model.dart';

class SupplierRepository {
  final SupabaseClient _supabase;

  SupplierRepository(this._supabase);

  Future<List<SupplierModel>> getSuppliers() async {
    try {
      final response = await _supabase
          .from('suppliers')
          .select()
          .order('created_at', ascending: false);

      // Konversi data JSON ke List<SupplierModel>
      final List<dynamic> data = response as List<dynamic>;
      return data.map((e) => SupplierModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch suppliers: $e');
    }
  }

  // 2. Tambah Data Supplier (Dengan Gambar)
  // ... import dan kode lainnya ...

  // 2. Tambah Data Supplier (Dengan Gambar)
  Future<void> addSupplier({
    required String name,
    required String contactPerson,
    required String phone,
    required String address,
    required String email,
    required String notes,
    File? imageFile, 
  }) async {
    try {
      String? imageUrl;

      if (imageFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await _supabase.storage.from('suppliers').upload(
              fileName,
              imageFile,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );
        imageUrl = _supabase.storage.from('suppliers').getPublicUrl(fileName);
      }

      // --- PERBAIKAN DI SINI ---
      await _supabase.from('suppliers').insert({
        'name': name,
        'contact_person': contactPerson,
        'phone': phone,
        'address': address,
        'email': email,
        
        // [UBAH INI] Dari 'note' menjadi 'notes'
        // Pastikan nama ini SAMA PERSIS dengan nama kolom di Supabase Table Editor
        'notes': notes, 
        
        'image_url': imageUrl,
      });
      
    } catch (e) {
      throw Exception('Failed to add supplier: $e');
    }
  }

  // 3. Update Data Supplier (Dengan Gambar)
  Future<void> updateSupplier({
    required String id,
    required String name,
    required String contactPerson,
    required String phone,
    required String address,
    required String email,
    required String notes,
    String? oldImageUrl,
    File? newImageFile,
  }) async {
    try {
      String? imageUrl = oldImageUrl;

      // Upload gambar baru jika ada
      if (newImageFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await _supabase.storage.from('suppliers').upload(
              fileName,
              newImageFile,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );
        imageUrl = _supabase.storage.from('suppliers').getPublicUrl(fileName);
      }

      // Update data di tabel
      await _supabase.from('suppliers').update({
        'name': name,
        'contact_person': contactPerson,
        'phone': phone,
        'address': address,
        'email': email,
        'notes': notes,
        'image_url': imageUrl,
      }).eq('id', id);

    } catch (e) {
      throw Exception('Failed to update supplier: $e');
    }
  }

  /// Deletes a supplier from the database.
  Future<void> deleteSupplier(String id) async {
    try {
      await _supabase.from('suppliers').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete supplier: $e');
    }
  }
}