import 'package:flutter/material.dart';
import 'package:gudangku/core/constants/app_colors.dart';
import 'package:gudangku/core/widgets/custom_header.dart';
import 'package:gudangku/core/widgets/custom_button.dart';

class CategoryDetailPage extends StatelessWidget {
  final String name;
  final String description;
  final Color color;
  final bool isActive;

  const CategoryDetailPage({
    super.key,
    required this.name,
    required this.description,
    required this.color,
    required this.isActive,
  });

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
                title: "Category Detail",
                showBackButton: true,
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.shopping_bag,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    "Status: ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.green[100] : Colors.red[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? "Active" : "Inactive",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: "Edit Category",
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Edit functionality coming soon")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
