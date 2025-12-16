import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../main_screen.dart';
import '../../../auth/presentation/pages/sign_in_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      _checkAuthAndNavigate();
    });
  }

  void _checkAuthAndNavigate() {
    // Cek apakah user sudah login
    final session = Supabase.instance.client.auth.currentSession;
    
    if (session != null) {
      // User sudah login -> ke MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // User belum login -> ke SignInPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar Kardus
            Image.asset(
              'assets/images/logo_box.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            // Opsional: Jika ingin ada teks judul aplikasi
            /*
            const Text(
              "GudangKu",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            */
          ],
        ),
      ),
    );
  }
}