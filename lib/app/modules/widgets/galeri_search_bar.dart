import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/galeri_controller.dart';

class GaleriSearchBar extends StatelessWidget {
  const GaleriSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GaleriController>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Cari koleksimu',

                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
