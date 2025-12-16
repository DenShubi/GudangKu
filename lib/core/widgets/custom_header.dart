import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const CustomHeader({
    super.key,
    this.title = 'Products', 
    this.showBackButton = false, 
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBackButton) ...[
          IconButton(
            // Jika onBackTap tidak diisi, default-nya Navigator.pop
            onPressed: onBackTap ?? () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 28),
            padding: EdgeInsets.zero, 
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16), 
        ],
        
        // Judul Utama
        Text(
          title,
          style: const TextStyle(
            fontSize: 34, 
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}