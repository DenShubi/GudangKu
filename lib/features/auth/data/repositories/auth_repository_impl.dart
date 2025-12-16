import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> signIn(String email, String password) async {
    await remoteDataSource.signIn(email, password);
  }

  @override
  Future<void> signUp(String email, String password, String name) async {
    await remoteDataSource.signUp(email, password, name);
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }
}