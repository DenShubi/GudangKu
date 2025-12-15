import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_header.dart';

// [HAPUS IMPORT product_edit_page.dart]

class ProductDetailPage extends StatelessWidget {
  final String id;
  final String name;
  final String price;
  final String stock;
  final String category;
  final String description;
  final String? imageUrl;

  const ProductDetailPage({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(
                title: "Products",
                showBackButton: true,
              ),
              
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                      image: imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: imageUrl == null
                        ? const Icon(Icons.image_not_supported, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              const Text("Detail :", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              _buildDetailRow("ID", id.length > 8 ? id.substring(0, 8) : id), 
              _buildDetailRow("Harga", price),    
              _buildDetailRow("Stok", stock),
              _buildDetailRow("Kategori", category),

              const SizedBox(height: 20),
              const Text("Deskripsi", style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(fontSize: 20, height: 1.5, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      // [FLOATING ACTION BUTTON DIHAPUS DARI SINI]
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 20, color: Colors.black)),
          Expanded(
            child: Text(
              value, 
              style: const TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}