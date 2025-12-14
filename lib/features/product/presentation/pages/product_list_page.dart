import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/product_card.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih bersih
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Title
              const Text(
                "Products",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // 2. List Produk (Menggunakan ListView)
              Expanded(
                child: ListView.builder(
                  itemCount: 5, // Contoh ada 5 data dummy
                  itemBuilder: (context, index) {
                    // Data Dummy (Nanti diganti data dari Supabase/Provider)
                    return ProductCard(
                      name: "Laptop Asus Vivobook 14MX",
                      id: "1234567890",
                      category: "Electronic",
                      price: "Rp. 11.200.999",
                      stock: 15 + index, // Dummy stock variasi
                      onTap: () {
                        // Navigasi ke Detail nanti di sini
                        print("Klik produk ke-$index"); 
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      
      // 3. Floating Action Button (Tombol Tambah)
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
             // Navigasi ke Form Tambah Produk
          },
          backgroundColor: AppColors.creamBackground, // Warna krem
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}