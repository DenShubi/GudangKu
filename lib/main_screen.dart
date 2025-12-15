import 'package:flutter/material.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/product/presentation/pages/product_list_page.dart';
import 'features/supplier/presentation/pages/supplier_list_page.dart';
import 'features/category/presentation/pages/category_list_page.dart';
import 'features/auth/presentation/pages/setting_page.dart';
import 'core/widgets/custom_bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const ProductListPage(),
    const SupplierListPage(),
    const CategoryListPage(),
    const SettingPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
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
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}