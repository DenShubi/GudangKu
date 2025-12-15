import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // 1. Container Induk sebagai "Kartu"
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Warna dasar kartu (untuk area teks)
          borderRadius: BorderRadius.circular(16), // Sudut melengkung untuk seluruh kartu
          // Shadow diletakkan di container induk ini
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Bayangan sedikit lebih halus
              blurRadius: 10,
              offset: const Offset(0, 5),
              spreadRadius: 2,
            ),
          ],
        ),
        // ClipRRect memastikan anak widget tidak keluar dari sudut melengkung kartu
        child: ClipRRect(
           borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Agar melebar penuh
            children: [
              // 2. Bagian Atas (Kotak Berwarna)
              Expanded(
                flex: 3, // Memberi porsi lebih besar untuk kotak warna
                child: Container(
                  color: color, // Hanya warna, tidak perlu border radius lagi (sudah di-clip)
                ),
              ),
              
              // 3. Bagian Bawah (Teks Judul)
              Expanded(
                 flex: 2, // Memberi porsi untuk area teks
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  alignment: Alignment.center, // Memastikan teks di tengah secara vertikal & horizontal
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}