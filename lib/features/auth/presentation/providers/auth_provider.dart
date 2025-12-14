import 'package:flutter/material.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;

  AuthProvider(this.repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Fungsi gabungan untuk Login atau Register
  // Update parameter fungsi authenticate
  Future<bool> authenticate(String email, String password, String name, bool isSignIn) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (isSignIn) {
        await repository.signIn(email, password);
      } else {
        // Kirim nama saat Sign Up
        await repository.signUp(email, password, name);
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}