import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../main_screen.dart'; // Import halaman utama (Navigation Bar) nanti

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  @override
  void initState() {
    super.initState();
    // Logika Timer: Pindah halaman setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      // Menggunakan pushReplacement agar user tidak bisa kembali ke splash screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground, // Warna dari core
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar Kardus
            Image.asset(
              'assets/images/logo_box.png',
              width: 150, // Sesuaikan ukuran
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