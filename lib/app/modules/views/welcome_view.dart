import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(),

          // Logo dan nama aplikasi
          Column(
            children: [
              Image.asset('lib/assets/home/logo.png', width: 51, height: 51),
            ],
          ),

          const Spacer(),

          // Panel bawah
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(45),
            decoration: const BoxDecoration(
              color: Color(0xFF6D4A36),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WELCOME',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Scan batik yang kamu miliki, dan jelajahi perjalanan panjang budaya Indonesia yang tersimpan dalam setiap helai kain.',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 24),

                // Tombol Buat Akun
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6D4A36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => Get.toNamed(Routes.register),
                    child: const Text(
                      'Buat Akun',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xFF6D4A36),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Tombol Masuk
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => Get.toNamed(Routes.login),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
