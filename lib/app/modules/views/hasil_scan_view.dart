import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hasil_scan_controller.dart';
import '../widgets/batik_accordion.dart';
import '../widgets/batik_terkait_row.dart';
import '../widgets/nav_bar_bawah.dart';
import '../models/batik_model.dart';
import '../../routes/app_routes.dart';

class HasilScanView extends StatelessWidget {
  const HasilScanView({super.key});

  static const Color coklat = Color(0xFF6B5744);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HasilScanController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC9A961)),
            ),
          ),
        );
      }

      if (controller.errorMsg.value.isNotEmpty) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.orange),
                const SizedBox(height: 12),
                Text(
                  controller.errorMsg.value,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Kembali'),
                ),
              ],
            ),
          ),
        );
      }

      final batik = controller.currentBatik.value;
      if (batik == null) {
        return const Scaffold(body: Center(child: Text('Data tidak tersedia')));
      }

      return Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: Stack(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(batik.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Text(
                    batik.nama,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(batik.route, arguments: batik.docId),
              child: Container(
                margin: const EdgeInsets.only(top: 270),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: coklat,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            batik.daerah,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: coklat,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      BatikAccordionList(items: batik.detail),
                      const SizedBox(height: 25),
                      RelatedBatikRow(items: batik.terkait),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BatikBottomNavBar(activeIndex: 2),
      );
    });
  }
}
