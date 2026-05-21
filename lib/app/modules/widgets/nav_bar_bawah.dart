import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nav_controller.dart';

class BatikBottomNavBar extends StatelessWidget {
  final int activeIndex;

  const BatikBottomNavBar({super.key, required this.activeIndex});

  static const Color coklat = Color(0xFF6B5744);

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      nav.setIndex(activeIndex);
    });

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: coklat,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(icon: Icons.home_filled,     index: 0, nav: nav),
          _NavItem(icon: Icons.crop_free,        index: 1, nav: nav),
          _NavItem(icon: Icons.explore_outlined, index: 2, nav: nav),
          _NavItem(icon: Icons.person_outline,   index: 3, nav: nav),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final NavController nav;

  const _NavItem({required this.icon, required this.index, required this.nav});

  static const Color kuning = Color(0xFFC9A961);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => nav.onNavTap(index),
      child: Obx(() {
        final bool isSelected = nav.selectedIndex.value == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? kuning : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        );
      }),
    );
  }
}
