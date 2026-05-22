import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profil_controller.dart';
import '../widgets/nav_bar_bawah.dart';
import '../../routes/app_routes.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  static const Color coklat = Color(0xFF6B5744);
  static const Color kuning = Color(0xFFC9A961);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfilController>();
    final url = controller.photoUrl.value;
    final isBase64 = url.startsWith('data:image');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.offAllNamed(Routes.home),
        ),
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Obx(
                () => Row(
                  children: [
                    GestureDetector(
                      onTap: controller.pickAndUploadFoto,
                      child: Obx(() {
                        final url = controller.photoUrl.value;
                        final isBase64 = url.startsWith('data:image');
                        return CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          backgroundImage: isBase64
                              ? MemoryImage(base64Decode(url.split(',').last))
                              : url.isNotEmpty
                              ? MemoryImage(base64Decode(url.split(',').last))
                              : null,
                          child: url.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 36,
                                  color: Colors.grey,
                                )
                              : null,
                        );
                      }),
                    ),
                    const SizedBox(width: 16),
                    // ── Nama & email reaktif ───────────────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.nama.value.isEmpty
                              ? '...'
                              : controller.nama.value,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.email.value,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── [3] Tombol Edit Profil ──────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.editProfil),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: coklat,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Edit Profil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Koleksi Batik',
                      '${controller.koleksiBatik} Motif',
                      const Color(0xFFC8A27C),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      'Total Scan',
                      '${controller.totalScan}x',
                      const Color(0xFFAF9E86),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      'Daerah Terdeteksi',
                      '${controller.daerahTerdeteksi} Daerah',
                      kuning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Pengaturan',
                onTap: () {},
              ),
              const SizedBox(height: 5),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Pusat Bantuan',
                onTap: () {},
              ),
              const SizedBox(height: 5),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'Tentang Aplikasi',
                onTap: () {},
              ),
              const SizedBox(height: 5),
              _buildMenuItem(
                icon: Icons.logout_outlined,
                title: 'Keluar',
                onTap: () => Get.offAllNamed(Routes.welcome),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BatikBottomNavBar(activeIndex: 3),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF7D6650), size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.black,
          size: 24,
        ),
        onTap: onTap,
      ),
    );
  }
}
