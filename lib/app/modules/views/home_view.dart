import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_banner.dart';
import '../widgets/riwayat_scan_row.dart';
import '../widgets/batik_terpopuler_card.dart';
import '../widgets/nav_bar_bawah.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const Color kuning = Color(0xFFC9A961);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selamat Datang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                controller.nama.value.isEmpty ? '-' : controller.nama.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Obx(() {
              final url = controller.photoUrl.value;
              final isBase64 = url.startsWith('data:image');
              return CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                backgroundImage: isBase64
                    ? MemoryImage(base64Decode(url.split(',').last))
                    : url.isNotEmpty
                    ? NetworkImage(url)
                    : null,
                child: url.isEmpty
                    ? const Icon(Icons.person, size: 36, color: Colors.grey)
                    : null,
              );
            }),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: kuning),
        ),
      ),

      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kuning, Colors.white],
                stops: [0.8, 1.0],
              ),
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: RefreshIndicator(
              color: kuning,
              onRefresh: controller.refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 150, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeBanner(),
                    const SizedBox(height: 25),
                    Obx(() {
                      if (controller.isLoadingRiwayat.value) {
                        return const SizedBox(
                          height: 120,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: kuning,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }
                      if (controller.terakhirMemindai.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Belum ada riwayat scan',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                      return ScanHistoryRow(items: controller.terakhirMemindai);
                    }),
                    const SizedBox(height: 35),
                    const Text(
                      'Batik Terpopuler',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Obx(() {
                      if (controller.isLoadingPilihan.value) {
                        return const SizedBox(
                          height: 160,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: kuning,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }
                      final pilihan = controller.batikPilihan.value;
                      if (pilihan == null) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Data belum tersedia',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                      return BatikPickCard(batik: pilihan);
                    }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: const BatikBottomNavBar(activeIndex: 0),
    );
  }
}
