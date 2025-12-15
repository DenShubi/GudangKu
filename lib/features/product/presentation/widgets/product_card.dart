import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final int stock;
  final String category;
  final String id;
  final VoidCallback onTap;
  final String? imageUrl;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.id,
    required this.onTap,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. Bagian Gambar (Tetap sama seperti sebelumnya)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                image: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: (imageUrl == null || imageUrl!.isEmpty)
                  ? const Icon(Icons.image_not_supported, color: Colors.grey)
                  : null,
            ),
            
            const SizedBox(width: 16),
            
            // 2. Bagian Informasi Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAMA PRODUK
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18, // Sedikit disesuaikan agar proporsional
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),

                  // --- [BARU] ID PRODUK ---
                  Text(
                    id, // Menampilkan ID
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600], // Abu-abu agak gelap
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // ------------------------

                  const SizedBox(height: 4),
                  
                  // KATEGORI
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey, // Abu-abu standar
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // HARGA & STOK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Atau AppColors.primaryGreen
                        ),
                      ),
                      Text(
                        "Stok: $stock",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}