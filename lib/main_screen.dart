import 'package:flutter/material.dart';

// Import Pages
import 'features/home/presentation/pages/home_page.dart';
import 'features/product/presentation/pages/product_list_page.dart';
import 'features/supplier/presentation/pages/supplier_list_page.dart';
import 'features/category/presentation/pages/category_list_page.dart';
import 'features/auth/presentation/pages/setting_page.dart';

// Import Widget
import 'core/widgets/custom_bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 1. Controller untuk mengontrol perpindahan halaman
  final PageController _pageController = PageController(initialPage: 0);
  
  int _currentIndex = 0; // Mulai dari Home (Index 0)

  // List Halaman
  final List<Widget> _pages = [
    const HomePage(),             // Index 0
    const ProductListPage(),      // Index 1
    const SupplierListPage(),     // Index 2
    const CategoryListPage(),     // Index 3
    const SettingPage(),          // Index 4
  ];

  @override
  void dispose() {
    // Jangan lupa dispose controller saat widget dihancurkan
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, 
      
      // 2. [UBAH DISINI] Ganti body statis menjadi PageView
      body: PageView(
        controller: _pageController,
        // physics: const NeverScrollableScrollPhysics(), // Hapus komentar ini jika ingin MEMATIKAN fitur swipe
        onPageChanged: (index) {
          // Saat user menggeser (swipe), update icon di navbar
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // 3. [SINKRONISASI] Saat navbar diklik, pindah halaman di PageView
            // Gunakan jumpToPage untuk pindah instan
            _pageController.jumpToPage(index); 
            
            // Atau gunakan ini jika ingin ada animasi scroll saat klik navbar:
            // _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          });
        },
      ),
    );
  }
}