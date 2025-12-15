import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core
import 'core/constants/app_colors.dart';

// Feature: Auth
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';

// Feature: Product
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/presentation/providers/product_provider.dart';

// Feature: Supplier (PENTING: Pastikan path ini benar)
import 'features/supplier/data/repositories/supplier_repository.dart';
import 'features/supplier/presentation/providers/providers.dart';

import 'features/category/data/repositories/category_repository.dart';
import 'features/category/presentation/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://kjnnphugfyxumdckhets.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtqbm5waHVnZnl4dW1kY2toZXRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU3MjcxNTMsImV4cCI6MjA4MTMwMzE1M30.eTS5JdY6lt48SX3OR-aETkRAjv7O5lzVGjkjnlFXpts',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            AuthRepositoryImpl(AuthRemoteDataSource(Supabase.instance.client)),
          ),
        ),

        // 2. Product Provider
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            ProductRepositoryImpl(
              ProductRemoteDataSource(Supabase.instance.client),
            ),
          ),
        ),

        // 3. Supplier Provider [SOLUSI ERROR SEBELUMNYA]
        ChangeNotifierProvider(
          create: (_) =>
              SupplierProvider(SupplierRepository(Supabase.instance.client)),
        ),

        ChangeNotifierProvider(
          create: (_) => CategoryProvider(
            CategoryRepository(Supabase.instance.client),
          ),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GudangKu',

        // Tema Aplikasi
        theme: ThemeData(
          fontFamily: 'SFPro',
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryGreen,
            primary: AppColors.primaryGreen,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'SFPro',
            ),
          ),
        ),

        // Halaman Awal
        home: const SignInPage(),
      ),
    );
  }
}
