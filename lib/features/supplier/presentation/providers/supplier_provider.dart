import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/supplier_model.dart';
import '../../data/repositories/supplier_repository.dart';

class SupplierProvider extends ChangeNotifier {
  final SupplierRepository _repository;

  SupplierProvider(this._repository);

  List<SupplierModel> _suppliers = [];
  bool _isLoading = false;
  String? _errorMessage;
  List<SupplierModel> get suppliers => _suppliers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSuppliers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _suppliers = await _repository.getSuppliers();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addSupplier(
    String name,
    String contactPerson,
    String phone,
    String address,
    String notes, {
    File? imageFile,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.addSupplier(
        name: name,
        contactPerson: contactPerson,
        phone: phone,
        address: address,
        notes: notes,
        imageFile: imageFile, // Teruskan ke Repository
      );
      
      // Refresh list setelah berhasil tambah
      await fetchSuppliers();
      
      return true; // Berhasil
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false; // Gagal
    }
  }
}