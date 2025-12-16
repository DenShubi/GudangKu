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
    String email,
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
        email: email,
        notes: notes,
        imageFile: imageFile, 
      );
      
      // Refresh list setelah berhasil tambah
      await fetchSuppliers();
      
      return true; 
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false; 
    }
  }

  Future<bool> updateSupplier({
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateSupplier(
        id: id,
        name: name,
        contactPerson: contactPerson,
        phone: phone,
        address: address,
        email: email,
        notes: notes,
        oldImageUrl: oldImageUrl,
        newImageFile: newImageFile,
      );

      // Refresh list setelah berhasil update
      await fetchSuppliers();

      return true; 
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false; 
    }
  }

  /// Deletes a supplier by ID.
  Future<bool> deleteSupplier(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteSupplier(id);
      await fetchSuppliers();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}