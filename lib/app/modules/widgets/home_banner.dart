import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  static const Color kuning = Color(0xFFC9A961);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('lib/assets/home/batik_header.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.black.withOpacity(0.4),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Jelajahi Keindahan Batik',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pindai kain batik untuk mengetahui sejarahnya.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => Get.toNamed(Routes.scan),
              style: ElevatedButton.styleFrom(
                backgroundColor: kuning,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Mulai Pemindaian',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
