import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/product_card.dart';
import '../providers/product_provider.dart';
import 'product_add_page.dart';
import 'product_detail_page.dart';


// Import Custom Header
import '../../../../core/widgets/custom_header.dart'; 

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // Header
              const CustomHeader(
                title: "Products",
                showBackButton: false,
              ),
              
              const SizedBox(height: 20),

              // List Produk
              Expanded(
                child: Consumer<ProductProvider>(
                   builder: (context, provider, child) {
                      // Loading
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      // Error
                      if (provider.errorMessage != null) {
                        return Center(child: Text(provider.errorMessage!));
                      }
                      
                      // Kosong
                      if (provider.products.isEmpty) {
                        return const Center(child: Text("Belum ada produk, silakan tambah."));
                      }
                      
                      // Ada Data
                      return ListView.builder(
                        itemCount: provider.products.length,
                        itemBuilder: (context, index) {
                          final product = provider.products[index];
                          
                          return GestureDetector(
                            onLongPress: () {
                              _showDeleteDialog(
                                context,
                                'Hapus Produk',
                                'Apakah Anda yakin ingin menghapus "${product.name}"?',
                                () async {
                                  final success = await provider.deleteProduct(product.id);
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(success
                                            ? 'Produk berhasil dihapus'
                                            : 'Gagal menghapus produk'),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                            child: ProductCard(
                            name: product.name,
                            // Tampilkan ID pendek di Card (biar rapi)
                            id: product.id.length > 8 ? product.id.substring(0, 8) : product.id,
                            category: product.category,
                            price: "Rp. ${product.price.toStringAsFixed(0)}",
                            stock: product.stock,
                            imageUrl: product.imageUrl,
                            onTap: () {
                              // Navigasi ke Detail
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(
                                    // [PERBAIKAN ERROR DI SINI]
                                    // Kita wajib kirim ID lengkap ke halaman detail
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
      
      // Floating Action Button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100, right: 10),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductAddPage()));
            },
            backgroundColor: AppColors.creamBackground,
            shape: const CircleBorder(),
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