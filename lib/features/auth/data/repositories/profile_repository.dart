import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  final SupabaseClient _supabase;

  ProfileRepository(this._supabase);

  /// Get current user's profile
  Future<ProfileModel?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return ProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  /// Create or update profile
  Future<void> upsertProfile(ProfileModel profile) async {
    try {
      await _supabase.from('profiles').upsert(profile.toJson());
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Upload avatar image and return the public URL
  Future<String> uploadAvatar(String userId, File imageFile) async {
    try {
      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Upload to avatars bucket
      await _supabase.storage.from('avatars').upload(
        fileName,
        imageFile,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );

      // Get public URL
      final imageUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);

      // Update profile with new avatar URL
      await _supabase.from('profiles').upsert({
        'id': userId,
        'avatar_url': imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });

      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  /// Delete old avatar from storage
  Future<void> deleteOldAvatar(String? oldAvatarUrl) async {
    if (oldAvatarUrl == null || oldAvatarUrl.isEmpty) return;

    try {
      // Extract filename from URL
      final uri = Uri.parse(oldAvatarUrl);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        final fileName = pathSegments.last;
        await _supabase.storage.from('avatars').remove([fileName]);
      }
    } catch (e) {
      // Ignore errors when deleting old avatar
    }
  }
}
