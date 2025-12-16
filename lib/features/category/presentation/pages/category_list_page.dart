import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_header.dart';
import '../widgets/category_card.dart';
import 'category_add_page.dart';
import 'category_detail_page.dart';
import '../providers/providers.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  
  @override
  void initState() {
    super.initState();
    // Ambil data saat halaman dibuka
    Future.microtask(() =>
        Provider.of<CategoryProvider>(context, listen: false).fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const CustomHeader(
                title: "Category",
                showBackButton: false,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Consumer<CategoryProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.errorMessage != null) {
                      return Center(child: Text(provider.errorMessage!));
                    }

                    if (provider.categories.isEmpty) {
                      return const Center(child: Text("Belum ada kategori"));
                    }

                    return GridView.builder(
                      itemCount: provider.categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final category = provider.categories[index];
                        return GestureDetector(
                          onLongPress: () {
                            _showDeleteDialog(
                              context,
                              'Hapus Kategori',
                              'Apakah Anda yakin ingin menghapus "${category.name}"?\n\n⚠️ Perhatian: Semua produk yang memiliki kategori ini juga akan ikut terhapus!',
                              () async {
                                final success = await provider.deleteCategory(category.id);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(success
                                          ? 'Kategori berhasil dihapus'
                                          : 'Gagal menghapus kategori'),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          child: CategoryCard(
                          title: category.name,
                          color: category.color,
                          imageUrl: category.imageUrl,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryDetailPage(
                                  id: category.id,
                                  name: category.name,
                                  color: category.color,
                                  description: category.description,
                                  isActive: category.isActive,
                                  imageUrl: category.imageUrl,
                                ),
                              ),
                            );
                          },
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
      // FAB tetap sama
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 120, right: 10),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryAddPage()),
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

  void _showDeleteDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: onConfirm,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}