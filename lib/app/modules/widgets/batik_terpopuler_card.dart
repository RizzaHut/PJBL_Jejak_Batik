import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/batik_model.dart';

class BatikPickCard extends StatelessWidget {
  final BatikModel batik;

  const BatikPickCard({super.key, required this.batik});

  static const Color coklat = Color(0xFF6B5744);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              batik.imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  batik.nama,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  batik.daerah,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => Get.toNamed(batik.route, arguments: batik.docId),
                  child: const Text(
                    'Baca Lebih Lanjut',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: coklat,
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
