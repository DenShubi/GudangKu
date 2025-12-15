import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

// Import Shared Components
import '../../../../core/widgets/custom_header.dart'; 
import '../../../../core/widgets/custom_text_field.dart'; 
import '../../../../core/widgets/custom_button.dart'; // [BARU]

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({super.key});

  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  // ... (Variable Controller & File tetap sama) ...
  File? _imageFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    // ... (Dispose tetap sama) ...
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // ... (Fungsi pickImage tetap sama) ...
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ProductProvider>().isLoading;

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

              // 1. PREVIEW AREA (Tetap sama)
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                        image: _imageFile != null
                            ? DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  BlendMode.darken,
                                ),
                              )
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: _imageFile != null ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      _nameController.text.isEmpty ? "Preview" : _nameController.text,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 2. FORM INPUT FIELDS (Tetap sama pakai CustomTextField)
              CustomTextField(
                label: "Nama Produk :",
                hint: "Laptop",
                controller: _nameController,
                onChanged: (value) {
                  setState(() {}); 
                },
              ),
              CustomTextField(
                label: "Harga :",
                hint: "1000999",
                controller: _priceController,
                isNumber: true,
              ),
              CustomTextField(
                label: "Stok :",
                hint: "99",
                controller: _stockController,
                isNumber: true,
              ),
              CustomTextField(
                label: "Kategori :",
                hint: "",
                controller: _categoryController,
              ),
              CustomTextField(
                label: "Deskripsi :",
                hint: "Opsional",
                controller: _descController,
                maxLines: 1,
              ),

              const SizedBox(height: 20),

              // 3. TOMBOL SAVE (MENGGUNAKAN WIDGET CUSTOM BARU)
              CustomButton(
                text: "Save",
                isLoading: isLoading,
                onPressed: () async {
                  // --- Logika Simpan (Copy paste dari yang lama) ---
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama produk tidak boleh kosong")));
                    return;
                  }
                  final productProvider = Provider.of<ProductProvider>(context, listen: false);

                  final success = await productProvider.addProduct(
                    _nameController.text,
                    _priceController.text,
                    _stockController.text,
                    _categoryController.text,
                    _descController.text,
                    _imageFile,
                  );

                  if (success && context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Produk berhasil disimpan!")));
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(productProvider.errorMessage ?? "Gagal menyimpan")));
                  }
                  // ------------------------------------------------
                },
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}