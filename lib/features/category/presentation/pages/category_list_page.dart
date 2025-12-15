import 'package:flutter/material.dart';

// 1. Import App Colors & Header (Sesuaikan path jika perlu)
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_header.dart';


// 2. Import Widget & Halaman Lain (INI YANG MEMPERBAIKI ERROR 'UNDEFINED')
import '../widgets/category_card.dart'; // Pastikan file ini ada
import 'category_add_page.dart';        // Pastikan file ini ada
import 'category_detail_page.dart';     // Pastikan file ini ada

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy
    final List<Map<String, dynamic>> dummyCategories = [
      {"name": "Electronic", "color": const Color(0xFFF4A4A4)}, 
      {"name": "Fashion", "color": const Color(0xFFE5E5E5)}, 
      {"name": "Stationary", "color": const Color(0xFFE5E5E5)},
      {"name": "Automotive", "color": const Color(0xFFE5E5E5)},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Header
              const CustomHeader(
                title: "Category",
                showBackButton: false,
              ),
              const SizedBox(height: 30),

              // GridView
              Expanded(
                child: GridView.builder(
                  itemCount: dummyCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.8, 
                  ),
                  itemBuilder: (context, index) {
                    final category = dummyCategories[index];
                    // Error 'CategoryCard isn't defined' hilang karena import di atas
                    return CategoryCard(
                      title: category['name'],
                      color: category['color'],
                      onTap: () {
                        // Navigasi ke Detail Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // Error 'CategoryDetailPage isn't defined' hilang karena import di atas
                            builder: (context) => CategoryDetailPage(
                              name: category['name'],
                              color: category['color'],
                              description:
                                  "Kategori ini mencakup segala jenis perangkat elektronik...",
                              isActive: true, 
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // FAB Tambah Kategori
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80, right: 10),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    // [PERBAIKAN] HAPUS kata 'const' di sini agar error hilang
                    builder: (context) => CategoryAddPage()), 
              );
            },
            backgroundColor: AppColors.creamBackground,
            shape: const CircleBorder(),
            elevation: 4,
            child: const Icon(Icons.add, color: Colors.white, size: 40),
          ),
        ),
      ),
    );
  }
}