import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/supplier_model.dart';

class SupplierRepository {
  final SupabaseClient _supabase;

  SupplierRepository(this._supabase);

  // Ambil Data
  Future<List<SupplierModel>> getSuppliers() async {
    try {
      final response = await _supabase
          .from('suppliers')
          .select()
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((e) => SupplierModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data supplier: $e');
    }
  }

  // Tambah Data
  Future<void> addSupplier({
    required String name,
    required String contactPerson,
    required String phone,
    required String address,
    required String notes,
  }) async {
    try {
      await _supabase.from('suppliers').insert({
        'name': name,
        'contact_person': contactPerson,
        'phone': phone,
        'address': address,
        'notes': notes,
      });
    } catch (e) {
      throw Exception('Gagal menambah supplier: $e');
    }
  }
}