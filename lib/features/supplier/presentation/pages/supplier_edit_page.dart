import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/supplier_provider.dart';

class SupplierEditPage extends StatefulWidget {
  final String id;
  final String currentName;
  final String currentContactPerson;
  final String currentPhone;
  final String currentAddress;
  final String currentEmail;
  final String currentNotes;
  final String? currentImageUrl;

  const SupplierEditPage({
    super.key,
    required this.id,
    required this.currentName,
    required this.currentContactPerson,
    required this.currentPhone,
    required this.currentAddress,
    required this.currentEmail,
    required this.currentNotes,
    this.currentImageUrl,
  });

  @override
  State<SupplierEditPage> createState() => _SupplierEditPageState();
}

class _SupplierEditPageState extends State<SupplierEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _cpController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _noteController;

  File? _newImageFile;

  @override
  void initState() {
    super.initState();
    // Isi controller dengan data lama
    _nameController = TextEditingController(text: widget.currentName);
    _cpController = TextEditingController(text: widget.currentContactPerson);
    _phoneController = TextEditingController(text: widget.currentPhone);
    _addressController = TextEditingController(text: widget.currentAddress);
    _emailController = TextEditingController(text: widget.currentEmail);
    _noteController = TextEditingController(text: widget.currentNotes);

    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _noteController.dispose();
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
          SnackBar(content: Text('Gagal memilih gambar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<SupplierProvider>().isLoading;

    // Inisial untuk fallback gambar
    String initial = "?";
    if (_nameController.text.isNotEmpty) {
      initial = _nameController.text[0].toUpperCase();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Edit Supplier", showBackButton: true),

              const SizedBox(height: 20),

              // Preview Area
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
                        // Logika tampilan:
                        // 1. Jika ada gambar baru -> tampilkan File
                        // 2. Jika tidak, tapi ada URL lama -> tampilkan Network
                        // 3. Kosong -> tampilkan inisial
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
                          ? Center(
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            )
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
                              ? "PT. Preview"
                              : "PT. ${_nameController.text}",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Tap gambar untuk mengubah",
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
                label: "Nama PT :",
                hint: "Contoh: Utilities",
                controller: _nameController,
                onChanged: (val) => setState(() {}),
              ),

              CustomTextField(
                label: "Nama Contact Person :",
                hint: "Contoh: Ridwan",
                controller: _cpController,
              ),

              CustomTextField(
                label: "No. HP :",
                hint: "0812...",
                controller: _phoneController,
                isNumber: true,
              ),

              CustomTextField(
                label: "Alamat Lengkap :",
                hint: "Jl. Bunga Merah...",
                controller: _addressController,
                maxLines: 1,
              ),

              CustomTextField(
                label: "Email :",
                hint: "contoh@email.com",
                controller: _emailController,
              ),

              CustomTextField(
                label: "Note : (Opsional)",
                hint: "Catatan tambahan...",
                controller: _noteController,
                maxLines: 1,
              ),

              const SizedBox(height: 20),

              // Update Button
              CustomButton(
                text: "Update",
                isLoading: isLoading,
                onPressed: () async {
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Nama PT wajib diisi")),
                    );
                    return;
                  }

                  final success = await context.read<SupplierProvider>().updateSupplier(
                    id: widget.id,
                    name: _nameController.text,
                    contactPerson: _cpController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    email: _emailController.text,
                    notes: _noteController.text,
                    oldImageUrl: widget.currentImageUrl,
                    newImageFile: _newImageFile,
                  );

                  if (success && context.mounted) {
                    Navigator.pop(context); // Kembali ke Detail
                    Navigator.pop(context); // Kembali ke List (refresh)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Supplier berhasil diupdate!")),
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
