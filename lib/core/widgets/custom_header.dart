import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const CustomHeader({
    super.key,
    this.title = 'Products', // Default text
    this.showBackButton = false, // Default tidak ada tombol back
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Logika: Jika showBackButton true, tampilkan icon panah
        if (showBackButton) ...[
          IconButton(
            // Jika onBackTap tidak diisi, default-nya Navigator.pop
            onPressed: onBackTap ?? () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 28),
            padding: EdgeInsets.zero, // Hapus padding bawaan agar rapat kiri
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16), // Jarak antara panah dan teks
        ],
        
        // Judul Utama
        Text(
          title,
          style: const TextStyle(
            fontSize: 34, // Ukuran font disamakan dengan Product List Page
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}