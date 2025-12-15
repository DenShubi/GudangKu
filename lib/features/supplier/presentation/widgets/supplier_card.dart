import 'package:flutter/material.dart';

class SupplierCard extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final String? imageUrl;
  final VoidCallback onTap;

  const SupplierCard({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil inisial untuk fallback jika gambar kosong
    String initial = "?";
    if (name.isNotEmpty) {
      initial = name[0].toUpperCase();
    }

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
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // --- BAGIAN GAMBAR / INISIAL ---
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                image: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: (imageUrl != null && imageUrl!.isNotEmpty)
                  ? null
                  : Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
            ),
            // -------------------------------
            
            const SizedBox(width: 16),
            
            // Informasi Text (Tanpa Icon)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Phone Text Only
                  Text(
                    phone,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  
                  const SizedBox(height: 2),
                  
                  // Address Text Only
                  Text(
                    address,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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