abstract class AuthRepository {
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password, String name); // Tambah name
  Future<void> signOut();
}