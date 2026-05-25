import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/galeri_controller.dart';
import '../widgets/galeri_batik_card.dart';
import '../widgets/nav_bar_bawah.dart';
import '../widgets/galeri_search_bar.dart';
import '../widgets/galeri_stat_card.dart';

class GaleriView extends GetView<GaleriController> {
  const GaleriView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Galeri',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Stat cards (reaktif dari Firestore) ──────────────────
            Obx(() {
              final s = controller.stats.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GaleriStatCard(
                        title: 'Terakhir ditambahkan',
                        value: s?.terakhirDitambahkan ?? '-',
                        backgroundColor: const Color(0xFFB08A6A),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GaleriStatCard(
                        title: 'Motif terbanyak',
                        value: s?.motifTerbanyak ?? '-',
                        backgroundColor: const Color(0xFFE8E2DA),
                        textColor: const Color(0xFF6D4A36),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GaleriStatCard(
                        title: 'Asal dominan',
                        value: s?.asalDominan ?? '-',
                        backgroundColor: const Color(0xFF6D4A36),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // ── Search bar ───────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GaleriSearchBar(),
            ),

            const SizedBox(height: 16),

            // ── List riwayat scan ────────────────────────────────────
            Expanded(
              child: Obx(() {
                // Loading state
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFC9A961)),
                  );
                }

                // Empty state — belum ada riwayat scan
                if (controller.semuaRiwayat.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada riwayat scan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Scan batik pertamamu sekarang!',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Empty state — hasil search tidak ditemukan
                if (controller.riwayatTerfilter.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Batik tidak ditemukan',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                }

                // List data
                return RefreshIndicator(
                  color: const Color(0xFFC9A961),
                  onRefresh: controller.refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: controller.riwayatTerfilter.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, index) {
                      final item = controller.riwayatTerfilter[index];
                      return GaleriBatikCard(item: item);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BatikBottomNavBar(activeIndex: 2),
    );
  }
}
