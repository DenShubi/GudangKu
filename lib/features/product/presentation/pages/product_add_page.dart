import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../category/presentation/providers/category_provider.dart';
// Import Provider
import '../providers/product_provider.dart';
import 'package:gudangku/features/category/presentation/providers/providers.dart'; // [BARU] Import CategoryProvider

// Import Shared Components
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({super.key});

  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  File? _imageFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  // final TextEditingController _categoryController = TextEditingController(); // [HAPUS INI]
  final TextEditingController _descController = TextEditingController();

  String? _selectedCategory; // [BARU] Variable untuk nyimpan pilihan dropdown

  @override
  void initState() {
    super.initState();
    // [BARU] Ambil data kategori saat halaman dibuka
    Future.microtask(() =>
        Provider.of<CategoryProvider>(context, listen: false).fetchCategories());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    // _categoryController.dispose(); // [HAPUS]
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
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
    // [BARU] Ambil list kategori dari provider
    final categoryProvider = context.watch<CategoryProvider>();

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

              // 1. PREVIEW AREA
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

              // 2. FORM INPUT FIELDS
              CustomTextField(
                label: "Nama Produk :",
                hint: "Laptop",
                controller: _nameController,
                onChanged: (value) => setState(() {}),
              ),
              CustomTextField(
                label: "Harga :",
                hint: "1000000",
                controller: _priceController,
                isNumber: true,
              ),
              CustomTextField(
                label: "Stok :",
                hint: "99",
                controller: _stockController,
                isNumber: true,
              ),

              // [UPDATE] KATEGORI DROPDOWN (Ganti CustomTextField Kategori)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  "Kategori :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100], // Samakan warna dengan CustomTextField
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    hint: const Text("Pilih Kategori", style: TextStyle(color: Colors.grey)),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: categoryProvider.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.name, // Kita simpan Namanya
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
              ),
              // ---------------------------------------------------------

              CustomTextField(
                label: "Deskripsi :",
                hint: "Opsional",
                controller: _descController,
                maxLines: 1,
              ),

              const SizedBox(height: 20),

              // 3. TOMBOL SAVE
              CustomButton(
                text: "Save",
                isLoading: isLoading,
                onPressed: () async {
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama produk tidak boleh kosong")));
                    return;
                  }
                  
                  // [BARU] Validasi Kategori
                  if (_selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Silakan pilih kategori")));
                    return;
                  }

                  final productProvider = Provider.of<ProductProvider>(context, listen: false);

                  final success = await productProvider.addProduct(
                    _nameController.text,
                    _priceController.text,
                    _stockController.text,
                    _selectedCategory!, // [UPDATE] Pakai nilai dropdown
                    _descController.text,
                    _imageFile,
                  );

                  if (success && context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Produk berhasil disimpan!")));
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(productProvider.errorMessage ?? "Gagal menyimpan")));
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
}