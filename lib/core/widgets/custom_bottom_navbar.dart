import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.only(
        top: 22,
        left: 20,
        right: 20,
        bottom: 28,
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 50,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.accentYellow,
          unselectedItemColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            // 1. HOME
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Home_Icon.png', 
                width: 24,
                height: 24,
                color: Colors.black, 
              ),
              activeIcon: Image.asset(
                'assets/images/Home_Icon.png',
                width: 24,
                height: 24,
                color: AppColors.accentYellow, 
              ),
              label: 'Home',
            ),

            // 2. PRODUCT
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Product_Icon.png', 
                width: 24,
                height: 24,
                color: Colors.black, 
              ),
              activeIcon: Image.asset(
                'assets/images/Product_Icon.png',
                width: 24,
                height: 24,
                color: AppColors.accentYellow, 
              ),
              label: 'Product',
            ),

            // 3. SUPPLIER
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Supplier_Icon.png', 
                width: 24,
                height: 24,
                color: Colors.black, 
              ),
              activeIcon: Image.asset(
                'assets/images/Supplier_Icon.png',
                width: 24,
                height: 24,
                color: AppColors.accentYellow, 
              ),
              label: 'Supplier',
            ),

            // 4. CATEGORY
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Category_Icon.png', 
                width: 24,
                height: 24,
                color: Colors.black, 
              ),
              activeIcon: Image.asset(
                'assets/images/Category_Icon.png',
                width: 24,
                height: 24,
                color: AppColors.accentYellow, 
              ),
              label: 'Category',
            ),

            // 5. SETTING
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Setting_Icon.png', 
                width: 24,
                height: 24,
                color: Colors.black, 
              ),
              activeIcon: Image.asset(
                'assets/images/Setting_Icon.png',
                width: 24,
                height: 24,
                color: AppColors.accentYellow, 
              ),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}