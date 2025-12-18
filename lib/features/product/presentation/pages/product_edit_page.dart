import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import 'package:gudangku/features/product/presentation/providers/product_provider.dart';
import 'package:gudangku/features/product/data/models/product_model.dart';
import 'package:gudangku/features/category/presentation/providers/providers.dart';
import 'package:gudangku/features/supplier/presentation/providers/supplier_provider.dart';
import 'package:gudangku/features/category/data/models/category_model.dart';
import 'package:gudangku/features/supplier/data/models/supplier_model.dart';

class ProductEditScreen extends StatefulWidget {
  final String id;
  final String currentName;
  final String currentPrice; 
  final String currentStock;
  final String? currentCategoryId;
  final String? currentCategoryName;
  final String? currentSupplierId;
  final String? currentSupplierName;
  final String currentDescription;
  final String? currentImageUrl;

  const ProductEditScreen({
    super.key,
    required this.id,
    required this.currentName,
    required this.currentPrice,
    required this.currentStock,
    this.currentCategoryId,
    this.currentCategoryName,
    this.currentSupplierId,
    this.currentSupplierName,
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
  
  CategoryModel? _selectedCategory;
  SupplierModel? _selectedSupplier;
  File? _newImageFile;

  @override
  void initState() {
    super.initState();
    // 1. Isi Controller dengan data lama
    _nameController = TextEditingController(text: widget.currentName);
    
    String cleanPrice = widget.currentPrice.replaceAll(RegExp(r'[^0-9]'), '');
    _priceController = TextEditingController(text: cleanPrice);
    
    _stockController = TextEditingController(text: widget.currentStock);
    _descController = TextEditingController(text: widget.currentDescription);

    // Fetch kategori dan supplier
    Future.microtask(() {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final supplierProvider = Provider.of<SupplierProvider>(context, listen: false);
      
      categoryProvider.fetchCategories().then((_) {
        // Set kategori terpilih berdasarkan ID
        if (widget.currentCategoryId != null) {
          final category = categoryProvider.categories.firstWhere(
            (c) => c.id == widget.currentCategoryId,
            orElse: () => categoryProvider.categories.isNotEmpty 
              ? categoryProvider.categories.first 
              : CategoryModel(id: '', name: '', description: '', isActive: true, hexColor: ''),
          );
          if (category.id.isNotEmpty) {
            setState(() => _selectedCategory = category);
          }
        }
      });
      
      supplierProvider.fetchSuppliers().then((_) {
        // Set supplier terpilih berdasarkan ID
        if (widget.currentSupplierId != null) {
          final supplier = supplierProvider.suppliers.firstWhere(
            (s) => s.id == widget.currentSupplierId,
            orElse: () => SupplierModel(id: '', name: '', contactPerson: '', phone: '', address: '', email: '', notes: ''),
          );
          if (supplier.id.isNotEmpty) {
            setState(() => _selectedSupplier = supplier);
          }
        }
      });
    });
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
    final supplierProvider = context.watch<SupplierProvider>();

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
                  child: DropdownButton<CategoryModel>(
                    value: _selectedCategory,
                    hint: const Text("Select Category"),
                    isExpanded: true,
                    items: categoryProvider.categories.map((cat) {
                      return DropdownMenuItem<CategoryModel>(value: cat, child: Text(cat.name));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                  ),
                ),
              ),

              // Dropdown Supplier
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text("Supplier :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100], borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SupplierModel>(
                    value: _selectedSupplier,
                    hint: const Text("Select Supplier (Optional)"),
                    isExpanded: true,
                    items: supplierProvider.suppliers.map((sup) {
                      return DropdownMenuItem<SupplierModel>(value: sup, child: Text(sup.name));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedSupplier = val),
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
                    description: _descController.text,
                    imageUrl: widget.currentImageUrl,
                    categoryId: _selectedCategory?.id,
                    supplierId: _selectedSupplier?.id,
                  );

                  // Call repository directly to update, then refresh list
                  await provider.repository.updateProductDirect(
                    product: product,
                    newImageFile: _newImageFile,
                  );
                  await provider.fetchProducts();
                  final success = true;

                  if (success && context.mounted) {
                    Navigator.pop(context); 
                    Navigator.pop(context); 
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