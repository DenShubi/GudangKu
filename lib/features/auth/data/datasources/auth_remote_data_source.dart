import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  final SupabaseClient supabase;

  AuthRemoteDataSource(this.supabase);

  // Fungsi Sign In (Login)
  Future<String> signIn(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw 'Login gagal: Data user tidak ditemukan.';
      }
      
      return response.user!.id; 
    } on AuthException catch (e) {
      throw e.message; 
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }

  // Fungsi Sign Up (Daftar Baru)
  Future<String> signUp(String email, String password, String name) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name}, 
      );

      if (response.user == null) {
        throw 'Registrasi gagal.';
      }

      return response.user!.id;
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}