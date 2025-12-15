import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // [WAJIB IMPORT]

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/providers.dart'; // [WAJIB IMPORT]

class CategoryAddPage extends StatefulWidget {
  const CategoryAddPage({super.key});

  @override
  State<CategoryAddPage> createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isActive = true;
  bool _isLoading = false; // Local loading state

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Warna default (Merah Muda)
    final previewColor = const Color(0xFFF4A4A4);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(
                title: "Category",
                showBackButton: false,
              ),
              const SizedBox(height: 20),

              // Preview Box
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: previewColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "Preview",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Form Inputs
              CustomTextField(
                label: "Nama Kategori :",
                hint: "Contoh: Electronic",
                controller: _nameController,
              ),
              CustomTextField(
                label: "Deskripsi :",
                hint: "Contoh: Barang elektronik...",
                controller: _descController,
                maxLines: 3,
              ),

              const SizedBox(height: 10),
              
              // Status Selection
              const Text(
                "Status :",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  _buildStatusButton("Active", true),
                  const SizedBox(width: 20),
                  _buildStatusButton("Non Active", false),
                ],
              ),
              const SizedBox(height: 40),

              // [UPDATE] Tombol Save
              CustomButton(
                text: "Save",
                isLoading: _isLoading, 
                onPressed: () async {
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Nama kategori wajib diisi")),
                    );
                    return;
                  }

                  setState(() => _isLoading = true);

                  final success = await Provider.of<CategoryProvider>(context, listen: false)
                      .addCategory(
                        _nameController.text,
                        _descController.text,
                        _isActive,
                      );

                  if (context.mounted) {
                    setState(() => _isLoading = false);
                    
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Kategori berhasil disimpan!")));
                    } else {
                       final errorMsg = Provider.of<CategoryProvider>(context, listen: false).errorMessage;
                       ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMsg ?? "Gagal menyimpan")));
                    }
                  }
                },
              ),
               const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ... Widget _buildStatusButton tetap sama ...
  Widget _buildStatusButton(String text, bool statusValue) {
    final isSelected = _isActive == statusValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isActive = statusValue;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (statusValue ? AppColors.primaryGreen : Colors.grey[400])
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}