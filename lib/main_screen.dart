import 'package:flutter/material.dart';
import 'core/widgets/custom_bottom_navbar.dart';
// ... import halaman lainnya ...

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // ... pages anda ...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pastikan background scaffold putih
      
      // --- TAMBAHKAN BARIS INI (WAJIB) ---
      extendBody: true, 
      // Artinya: Paksa konten halaman memanjang sampai ke belakang navbar
      // -----------------------------------
      
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