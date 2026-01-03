import 'package:flutter/material.dart';

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


  Color _getStockColor(int stock) {
    if (stock > 100) {
      return const Color(0xFFA3E635);
    } else if (stock >= 30) {
      return const Color(0xFFFDE047); 
    } else {
      return const Color(0xFFF87171); 
    }
  }

  // Helper untuk menentukan warna teks (agar kontras)
  Color _getStockTextColor(int stock) {
    return Colors.black87; 
  }

  @override
  Widget build(BuildContext context) {
    // Cache color calculations
    final stockColor = _getStockColor(stock);
    final stockTextColor = _getStockTextColor(stock);
    
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
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            // 1. Bagian Gambar
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
                  // --- ROW ATAS: NAMA & KOTAK STOK ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Produk (Pakai Expanded agar tidak nabrak stok)
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      const SizedBox(width: 8),

                      // KOTAK STOK [Optimized with cached colors]
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: stockColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "$stock",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: stockTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // -----------------------------------

                  const SizedBox(height: 4),

                  // ID PRODUK
                  Text(
                    id, 
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),
                  
                  // KATEGORI (Badge Kecil)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // HARGA
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, 
                    ),
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