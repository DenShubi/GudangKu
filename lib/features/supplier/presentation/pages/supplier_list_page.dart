import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_header.dart';
import '../widgets/supplier_card.dart';

// Nanti import SupplierAddPage jika sudah dibuat
// import 'supplier_add_page.dart';

class SupplierListPage extends StatelessWidget {
  const SupplierListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy (Pura-pura dari database)
    final List<Map<String, String>> dummySuppliers = [
      {
        "name": "PT. Utilities",
        "phone": "0812-2314-6767",
        "address": "Jl. Bunga Merah No.172"
      },
      {
        "name": "PT. Amogus",
        "phone": "0812-2314-6767",
        "address": "Jl. Bunga Merah No.172"
      },
      {
        "name": "PT. Utilities Cabang 2",
        "phone": "0812-2314-6767",
        "address": "Jl. Bunga Merah No.172"
      },
       {
        "name": "PT. Amogus Pusat",
        "phone": "0812-2314-6767",
        "address": "Jl. Bunga Merah No.172"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // 1. Header (Shared Component)
              const CustomHeader(
                title: "Supplier",
                showBackButton: false, // Set true jika ingin tombol back
              ),

              const SizedBox(height: 20),

              // 2. List Supplier
              Expanded(
                child: ListView.builder(
                  itemCount: dummySuppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = dummySuppliers[index];
                    return SupplierCard(
                      name: supplier['name']!,
                      phone: supplier['phone']!,
                      address: supplier['address']!,
                      onTap: () {
                        // Nanti navigasi ke Detail Supplier
                        print("Klik ${supplier['name']}");
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80, right: 10), // Padding agar tidak tertutup nav bar
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              // Navigasi ke Halaman Tambah Supplier
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplierAddPage()));
            },
            backgroundColor: AppColors.creamBackground, // Gunakan warna cream/kuning emas
            shape: const CircleBorder(),
            elevation: 4,
            child: const Icon(Icons.add, color: Colors.white, size: 40),
          ),
        ),
      ),
    );
  }
}