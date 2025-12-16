import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;

  CategoryProvider(this._repository);

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _repository.getCategories();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCategory(
    String name,
    String description,
    bool isActive, {
    File? imageFile,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      const String defaultPinkColor = "0xFFF4A4A4";

      await _repository.addCategory(
        name: name,
        description: description,
        isActive: isActive,
        hexColor: defaultPinkColor,
        imageFile: imageFile,
      );

      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCategory({
    required String id,
    required String name,
    required String description,
    required bool isActive,
    String? oldImageUrl,
    File? newImageFile,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      const String defaultPinkColor = "0xFFF4A4A4";

      await _repository.updateCategory(
        id: id,
        name: name,
        description: description,
        isActive: isActive,
        hexColor: defaultPinkColor,
        oldImageUrl: oldImageUrl,
        newImageFile: newImageFile,
      );

      await fetchCategories();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
