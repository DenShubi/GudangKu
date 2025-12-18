import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../category/presentation/providers/category_provider.dart';
import '../../../supplier/presentation/providers/supplier_provider.dart';
import '../../../category/data/models/category_model.dart';
import '../../../supplier/data/models/supplier_model.dart';
import '../providers/product_provider.dart';
import 'package:gudangku/features/category/presentation/providers/providers.dart'; 
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
  final TextEditingController _descController = TextEditingController();

  // Simpan object kategori & supplier untuk mendapatkan ID-nya
  CategoryModel? _selectedCategory;
  SupplierModel? _selectedSupplier;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<SupplierProvider>(context, listen: false).fetchSuppliers();
    });
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
          _imageFile = File(image.path);
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
    // Ambil list kategori dan supplier dari provider
    final categoryProvider = context.watch<CategoryProvider>();
    final supplierProvider = context.watch<SupplierProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(
                title: "Add Product",
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
                label: "Product Name :",
                hint: "Laptop",
                controller: _nameController,
                onChanged: (value) => setState(() {}),
              ),
              CustomTextField(
                label: "Price :",
                hint: "1000000",
                controller: _priceController,
                isNumber: true,
              ),
              CustomTextField(
                label: "Stock :",
                hint: "99",
                controller: _stockController,
                isNumber: true,
              ),

              // [UPDATE] KATEGORI DROPDOWN (Menggunakan Object untuk menyimpan ID)
              const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  "Category :",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CategoryModel>(
                    value: _selectedCategory,
                    hint: const Text("Select Category", style: TextStyle(color: Colors.black54)),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    items: categoryProvider.categories.map((category) {
                      return DropdownMenuItem<CategoryModel>(
                        value: category,
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

              // SUPPLIER DROPDOWN
              const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  "Supplier :",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SupplierModel>(
                    value: _selectedSupplier,
                    hint: const Text("Select Supplier (Optional)", style: TextStyle(color: Colors.black54)),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    items: supplierProvider.suppliers.map((supplier) {
                      return DropdownMenuItem<SupplierModel>(
                        value: supplier,
                        child: Text(supplier.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSupplier = value;
                      });
                    },
                  ),
                ),
              ),
              // ---------------------------------------------------------

              CustomTextField(
                label: "Description :",
                hint: "Optional",
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Product name is required")));
                    return;
                  }
                  
                  // Validasi Kategori
                  if (_selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a category")));
                    return;
                  }

                  final productProvider = Provider.of<ProductProvider>(context, listen: false);

                  // Kirim ID kategori dan supplier, bukan namanya
                  final success = await productProvider.addProduct(
                    _nameController.text,
                    _priceController.text,
                    _stockController.text,
                    _selectedCategory!.id,        // Category ID
                    _selectedSupplier?.id,        // Supplier ID (opsional)
                    _descController.text,
                    _imageFile,
                  );

                  if (success && context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Product saved successfully!")),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(productProvider.errorMessage ?? "Failed to save")),
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