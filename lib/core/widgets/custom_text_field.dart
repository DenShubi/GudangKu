import 'package:flutter/material.dart';
import '../constants/app_colors.dart'; 

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isNumber;
  final int maxLines;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText; // [BARU] Tambahkan parameter ini

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint = '',
    this.isNumber = false,
    this.maxLines = 1,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false, // [BARU] Defaultnya false (teks terlihat)
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas input
        Text(
          label,
          style: const TextStyle(
            fontSize: 22, // Tetap 22 sesuai kode Anda
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 15), // Tetap 15 sesuai kode Anda
        
        // Input Field
        TextFormField(
          controller: controller,
          keyboardType: keyboardType ?? (isNumber ? TextInputType.number : TextInputType.text),
          maxLines: maxLines,
          onChanged: onChanged,
          obscureText: obscureText, // [BARU] Pasang Logic Password di sini
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black54),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            
            // --- ATUR STYLE GLOBAL DISINI (Sesuai kode Anda) ---
            // Border Normal
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            // Border saat tidak diklik
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            // Border saat diklik (Fokus)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accentYellow, width: 2), // Tetap accentYellow
            ),
            // --------------------------------
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}