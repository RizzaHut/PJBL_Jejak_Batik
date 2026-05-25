import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/galeri_model.dart';
import '../controllers/galeri_controller.dart';

class GaleriBatikCard extends StatelessWidget {
  final RiwayatScanItem item;

  static const Color coklat = Color(0xFF6B5244);

  const GaleriBatikCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GaleriController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Gambar batik ────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item.imagePath,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110,
                  height: 110,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.grey, size: 32),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ── Konten ──────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama batik
                  Text(
                    item.nama,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Daerah asal
                  Text(
                    item.daerah,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 7),

                  // Deskripsi singkat
                  Text(
                    item.deskripsi,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Tombol baca + tanggal scan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Baca → navigasi ke hasil_scan_view
                      GestureDetector(
                        onTap: () => Get.toNamed(
                          item.route,
                          arguments: item.batikId,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: coklat,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Baca',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // Tanggal scan
                      Text(
                        controller.formatTanggal(item.scannedAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
