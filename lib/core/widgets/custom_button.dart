import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Fungsi yang dijalankan saat klik
  final bool isLoading; // Status loading
  final Color? backgroundColor; // Opsional: jika ingin warna selain Hijau
  final Color? textColor; // Opsional: jika ingin warna teks selain Hitam

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55, // Tinggi sesuai desain Anda (55)
      child: ElevatedButton(
        // Logika: Jika sedang loading, tombol dimatikan (null) agar tidak bisa diklik 2x
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryGreen,
          // Warna saat tombol disabled/loading (tetap hijau tapi agak pudar dikit atau tetap)
          disabledBackgroundColor: (backgroundColor ?? AppColors.primaryGreen), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.black, // Warna spinner sesuai desain Anda
                  strokeWidth: 3,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
      ),
    );
  }
}