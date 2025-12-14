import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import file-file auth yang baru dibuat
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Supabase (Ganti URL & Key punya kelompok Anda)
  await Supabase.initialize(
    url: 'https://kjnnphugfyxumdckhets.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtqbm5waHVnZnl4dW1kY2toZXRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU3MjcxNTMsImV4cCI6MjA4MTMwMzE1M30.eTS5JdY6lt48SX3OR-aETkRAjv7O5lzVGjkjnlFXpts',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Setup MultiProvider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            AuthRepositoryImpl(
              AuthRemoteDataSource(Supabase.instance.client),
            ),
          ),
        ),
        // Nanti provider Product, Category, Supplier ditambah di sini juga
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inventory App',
        home: const SignInPage(), // Ubah Home ke SignInPage dulu
      ),
    );
  }
}