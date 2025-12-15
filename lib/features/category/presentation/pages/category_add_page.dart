import 'package:flutter/material.dart';
import 'package:gudangku/core/constants/app_colors.dart';
import 'package:gudangku/core/widgets/custom_button.dart';
import 'package:gudangku/core/widgets/custom_header.dart';
import 'package:gudangku/core/widgets/custom_text_field.dart';

class CategoryAddPage extends StatefulWidget {
  const CategoryAddPage({super.key});

  @override
  State<CategoryAddPage> createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(
                title: "Add Category",
                showBackButton: true,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                label: "Category Name:",
                hint: "e.g., Electronics",
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Description:",
                hint: "Brief description...",
                controller: _descController,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    "Status:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SwitchListTile(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() => _isActive = value);
                      },
                      title: Text(_isActive ? "Active" : "Inactive"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: "Save Category",
                isLoading: _isLoading,
                onPressed: () async {
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Category name is required")),
                    );
                    return;
                  }

                  setState(() => _isLoading = true);

                  await Future.delayed(const Duration(seconds: 1));

                  if (context.mounted) {
                    setState(() => _isLoading = false);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Category added successfully!")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
