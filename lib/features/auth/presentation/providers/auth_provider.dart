import 'package:flutter/material.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository; 

  AuthProvider(this.repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> authenticate(String email, String password, String name, bool isSignIn) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (isSignIn) {
        await repository.signIn(email, password);
      } else {
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

  Future<void> signOut() async {
    try {
      await repository.signOut(); 
      notifyListeners();
    } catch (e) {
      rethrow; 
    }
  }
}