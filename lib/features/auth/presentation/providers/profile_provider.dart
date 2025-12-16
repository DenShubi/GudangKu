import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;

  ProfileProvider(this._repository);

  ProfileModel? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get avatarUrl => _profile?.avatarUrl;

  /// Fetch profile for a user
  Future<void> fetchProfile(String userId, String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _repository.getProfile(userId);
      
      // If profile doesn't exist, create one
      if (_profile == null) {
        _profile = ProfileModel(
          id: userId,
          email: email,
        );
        await _repository.upsertProfile(_profile!);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update avatar from image file
  Future<bool> updateAvatar(String userId, File imageFile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Delete old avatar first
      if (_profile?.avatarUrl != null) {
        await _repository.deleteOldAvatar(_profile!.avatarUrl);
      }

      // Upload new avatar
      final newAvatarUrl = await _repository.uploadAvatar(userId, imageFile);
      
      // Update local profile
      _profile = _profile?.copyWith(avatarUrl: newAvatarUrl);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear profile data (on logout)
  void clearProfile() {
    _profile = null;
    _errorMessage = null;
    notifyListeners();
  }
}
