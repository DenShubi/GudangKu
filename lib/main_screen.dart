import 'package:flutter/material.dart';
import 'package:gudangku/features/supplier/presentation/pages/supplier_list_page.dart';
import 'core/widgets/custom_bottom_navbar.dart';
// Pastikan import halaman Product ada.
// Jika belum buat halaman lain, sementara pakai Text placeholder dulu tidak apa-apa.
import 'features/product/presentation/pages/product_list_page.dart'; 

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index awal = 1 (Product). 
  // Pastikan list _pages punya minimal 2 item supaya tidak error.
  int _currentIndex = 1; 

  // --- BAGIAN INI TIDAK BOLEH KOSONG ---
  final List<Widget> _pages = [
    const Center(child: Text("Halaman Home")),        // Index 0
    const ProductListPage(),                          // Index 1 (Product)
    const SupplierListPage(),    // Index 2
    const Center(child: Text("Halaman Category")),    // Index 3
    const Center(child: Text("Halaman Setting")),     // Index 4
  ];
  // -------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, // Agar navbar transparan menyatu
      
      // Error terjadi di sini jika _pages kosong
      body: _pages[_currentIndex], 
      
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}