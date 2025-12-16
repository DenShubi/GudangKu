import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// Imports
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import 'package:gudangku/features/product/presentation/providers/product_provider.dart';
import 'package:gudangku/features/product/data/models/product_model.dart';
import 'package:gudangku/features/category/presentation/providers/providers.dart';

class ProductEditScreen extends StatefulWidget {
  // Terima data awal dari Detail Page
  final String id;
  final String currentName;
  final String currentPrice; // String format (Rp...)
  final String currentStock;
  final String currentCategory;
  final String currentDescription;
  final String? currentImageUrl;

  const ProductEditScreen({
    super.key,
    required this.id,
    required this.currentName,
    required this.currentPrice,
    required this.currentStock,
    required this.currentCategory,
    required this.currentDescription,
    this.currentImageUrl,
  });

  @override
  State<ProductEditScreen> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _descController;
  
  String? _selectedCategory;
  File? _newImageFile;

  @override
  void initState() {
    super.initState();
    // 1. Isi Controller dengan data lama
    _nameController = TextEditingController(text: widget.currentName);
    
    // Bersihkan format "Rp. " agar jadi angka saja di textfield
    String cleanPrice = widget.currentPrice.replaceAll(RegExp(r'[^0-9]'), '');
    _priceController = TextEditingController(text: cleanPrice);
    
    _stockController = TextEditingController(text: widget.currentStock);
    _descController = TextEditingController(text: widget.currentDescription);
    _selectedCategory = widget.currentCategory; // Set kategori awal

    // Fetch kategori biar dropdown tidak kosong
    Future.microtask(() =>
        Provider.of<CategoryProvider>(context, listen: false).fetchCategories());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (image != null) {
        setState(() {
          _newImageFile = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ProductProvider>().isLoading;
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Edit Product", showBackButton: true),
              const SizedBox(height: 20),

              // --- PREVIEW GAMBAR ---
              GestureDetector(
                onTap: _pickImage,
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                        // Logika Tampilan: 
                        // 1. Jika pilih gambar baru -> Tampilkan File
                        // 2. Jika tidak, tapi ada URL lama -> Tampilkan Network
                        // 3. Kosong
                        image: _newImageFile != null
                            ? DecorationImage(image: FileImage(_newImageFile!), fit: BoxFit.cover)
                            : (widget.currentImageUrl != null 
                                ? DecorationImage(image: NetworkImage(widget.currentImageUrl!), fit: BoxFit.cover)
                                : null),
                      ),
                      child: (_newImageFile == null && widget.currentImageUrl == null)
                          ? const Icon(Icons.add_a_photo, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    const Text("Tap image to change", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- FORM ---
              CustomTextField(label: "Product Name :", controller: _nameController),
              CustomTextField(label: "Price :", controller: _priceController, isNumber: true),
              CustomTextField(label: "Stock :", controller: _stockController, isNumber: true),

              // Dropdown Kategori
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text("Category :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100], borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    hint: const Text("Select Category"),
                    isExpanded: true,
                    items: categoryProvider.categories.map((cat) {
                      return DropdownMenuItem(value: cat.name, child: Text(cat.name));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                  ),
                ),
              ),

              CustomTextField(label: "Description :", controller: _descController),

              const SizedBox(height: 30),

              // --- TOMBOL UPDATE ---
              CustomButton(
                text: "Update",
                isLoading: isLoading,
                onPressed: () async {
                  if (_nameController.text.isEmpty) return;

                  final provider = context.read<ProductProvider>();
                  final doublePrice = double.tryParse(_priceController.text) ?? 0.0;
                  final intStock = int.tryParse(_stockController.text) ?? 0;

                  final product = ProductModel(
                    id: widget.id,
                    name: _nameController.text,
                    price: doublePrice,
                    stock: intStock,
                    category: _selectedCategory ?? "-",
                    description: _descController.text,
                    imageUrl: widget.currentImageUrl,
                  );

                  // Call repository directly to update, then refresh list
                  await provider.repository.updateProductDirect(
                    product: product,
                    newImageFile: _newImageFile,
                  );
                  await provider.fetchProducts();
                  final success = true;

                  if (success && context.mounted) {
                    Navigator.pop(context); // Balik ke Detail
                    Navigator.pop(context); // Balik ke List (biar refresh full)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Product updated successfully!")),
                    );
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