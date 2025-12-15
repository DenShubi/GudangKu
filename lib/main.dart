import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_colors.dart'; 
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/presentation/providers/product_provider.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            AuthRepositoryImpl(
              AuthRemoteDataSource(Supabase.instance.client),
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            ProductRepositoryImpl(
              ProductRemoteDataSource(Supabase.instance.client),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GudangKu', // Sesuaikan nama aplikasi
        
        // --- SETUP TEMA & FONT DI SINI ---
        theme: ThemeData(
          // Pastikan nama ini SAMA PERSIS dengan family di pubspec.yaml
          fontFamily: 'SFPro', 
          
          // Warna Background Default Putih
          scaffoldBackgroundColor: Colors.white,
          
          // Skema Warna Utama
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryGreen,
            primary: AppColors.primaryGreen,
          ),
          
          useMaterial3: true,
          
          // Setup AppBar default agar bersih (Putih, Teks Hitam)
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'SFPro', // Pastikan judul juga kena font baru
            ),
          ),
        ),
        // ---------------------------------

        home: const SignInPage(),
      ),
    );
  }
}