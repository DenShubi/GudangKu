import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Shared Widgets
import '../../../../core/widgets/custom_header.dart';

// Import Product Feature (Provider, Card, & Detail Page)
import '../../../product/presentation/providers/product_provider.dart';
import '../../../product/presentation/widgets/product_card.dart';
import '../../../product/presentation/pages/product_detail_page.dart';

class CategoryDetailPage extends StatefulWidget {
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
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  @override
  void initState() {
    super.initState();
    // Memastikan data produk terbaru diambil saat halaman ini dibuka
    // (Opsional, jika data sudah ada di main screen, ini bisa dihapus)
    Future.microtask(() =>
        Provider.of<ProductProvider>(context, listen: false).fetchProducts());
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
              // 1. Header Aplikasi
              const CustomHeader(
                title: "Category",
                showBackButton: true,
              ),
              const SizedBox(height: 20),

              // 2. Banner Nama Kategori (Sesuai Desain)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: widget.color, // Warna sesuai kategori
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // 3. List Produk (Filtered by Category Name)
              Expanded(
                child: Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    // FILTER: Ambil produk yang kategorinya sama dengan widget.name
                    final categoryProducts = provider.products
                        .where((product) => product.category == widget.name)
                        .toList();

                    // Kondisi Loading
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Kondisi Kosong
                    if (categoryProducts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[300]),
                            const SizedBox(height: 10),
                            Text(
                              "Tidak ada produk di kategori ${widget.name}",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      );
                    }

                    // Tampilkan List
                    return ListView.builder(
                      itemCount: categoryProducts.length,
                      itemBuilder: (context, index) {
                        final product = categoryProducts[index];
                        
                        return ProductCard(
                          // Tampilkan ID pendek
                          id: product.id.length > 8 
                              ? product.id.substring(0, 8) 
                              : product.id,
                          name: product.name,
                          price: "Rp. ${product.price.toStringAsFixed(0)}",
                          stock: product.stock,
                          imageUrl: product.imageUrl,
                          category: product.category,
                          onTap: () {
                            // Navigasi ke Product Detail
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  id: product.id,
                                  name: product.name,
                                  price: "Rp. ${product.price.toStringAsFixed(0)}",
                                  stock: "${product.stock}",
                                  category: product.category,
                                  description: product.description,
                                  imageUrl: product.imageUrl,
                                ),
                              ),
                            );
                          },
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
    );
  }
}