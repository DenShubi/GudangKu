import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // [WAJIB]

import '../../../../core/widgets/custom_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/providers.dart';

// [PENTING] INI YANG HILANG TADI

class SupplierAddPage extends StatefulWidget {
  const SupplierAddPage({super.key});

  @override
  State<SupplierAddPage> createState() => _SupplierAddPageState();
}

class _SupplierAddPageState extends State<SupplierAddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              const CustomHeader(title: "Supplier", showBackButton: true),

              const SizedBox(height: 20),

              // Preview Area
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
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
                label: "Note : (Opsional)",
                hint: "Catatan tambahan...",
                controller: _noteController,
                maxLines: 1,
              ),

              const SizedBox(height: 20),

              // Tombol Save
              CustomButton(
                text: "Save",
                isLoading: _isLoading,
                onPressed: () async {
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Nama PT wajib diisi")),
                    );
                    return;
                  }

                  setState(() => _isLoading = true);

                  // Panggil Provider (Sekarang sudah dikenali karena import ada)
                  final success =
                      await Provider.of<SupplierProvider>(
                        context,
                        listen: false,
                      ).addSupplier(
                        _nameController.text,
                        _cpController.text,
                        _phoneController.text,
                        _addressController.text,
                        _noteController.text,
                      );

                  if (context.mounted) {
                    setState(() => _isLoading = false);

                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Supplier berhasil disimpan!"),
                        ),
                      );
                    } else {
                      final errorMsg = Provider.of<SupplierProvider>(
                        context,
                        listen: false,
                      ).errorMessage;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMsg ?? "Gagal menyimpan")),
                      );
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
}
