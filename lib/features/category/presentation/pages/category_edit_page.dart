import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/providers.dart';

class CategoryEditPage extends StatefulWidget {
  final String id;
  final String currentName;
  final String currentDescription;
  final bool currentIsActive;
  final String? currentImageUrl;

  const CategoryEditPage({
    super.key,
    required this.id,
    required this.currentName,
    required this.currentDescription,
    required this.currentIsActive,
    this.currentImageUrl,
  });

  @override
  State<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late bool _isActive;
  File? _newImageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _descController = TextEditingController(text: widget.currentDescription);
    _isActive = widget.currentIsActive;

    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
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
    final isLoading = context.watch<CategoryProvider>().isLoading;
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
                title: "Edit Category",
                showBackButton: true,
              ),
              const SizedBox(height: 20),

              // Preview Area dengan Image Picker
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: previewColor,
                        borderRadius: BorderRadius.circular(16),
                        image: _newImageFile != null
                            ? DecorationImage(
                                image: FileImage(_newImageFile!),
                                fit: BoxFit.cover,
                              )
                            : (widget.currentImageUrl != null &&
                                    widget.currentImageUrl!.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(widget.currentImageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                      ),
                      child: (_newImageFile == null &&
                              (widget.currentImageUrl == null ||
                                  widget.currentImageUrl!.isEmpty))
                          ? const Icon(Icons.add_a_photo, color: Colors.white, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameController.text.isEmpty
                              ? "Preview"
                              : _nameController.text,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Tap image to change",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Form Inputs
              CustomTextField(
                label: "Category Name :",
                hint: "Contoh: Electronic",
                controller: _nameController,
                onChanged: (val) => setState(() {}),
              ),
              CustomTextField(
                label: "Description :",
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

              // Tombol Update
              CustomButton(
                text: "Update",
                isLoading: isLoading,
                onPressed: () async {
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Category name is required")),
                    );
                    return;
                  }

                  final success = await context.read<CategoryProvider>().updateCategory(
                    id: widget.id,
                    name: _nameController.text,
                    description: _descController.text,
                    isActive: _isActive,
                    oldImageUrl: widget.currentImageUrl,
                    newImageFile: _newImageFile,
                  );

                  if (success && context.mounted) {
                    Navigator.pop(context); 
                    Navigator.pop(context); 
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Category updated successfully!")),
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
