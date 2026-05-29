import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pengaturan_controller.dart';

class PengaturanView extends GetView<PengaturanController> {
  const PengaturanView({super.key});

  static const Color coklat = Color(0xFF6B5744);
  static const Color kuning = Color(0xFFC9A961);

  @override
  Widget build(BuildContext context) {
    final themeC = Get.find<PengaturanController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildSectionLabel('Tampilan'),
            const Sizedbox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Obx(
                    () => _buildDropdownItem(
                      icon: Icons.palette_outlined,
                      label: 'Tema',
                      nilai: themeC.tema.value == 'gelap' ? 'Gelap' : 'Terang',
                      pilihan: const ['Terang', 'Gelap'],
                      onChanged: (val) {
                        if (val != null) themeC.gantiTema(val.toLowerCase());
                      },
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  Obx(
                    () => _buildDropdownItem(
                      icon: Icons.text_fields,
                      label: 'Ukuran Teks',
                      nilai: _kapital(themeC.ukuranTeks.value),
                      pilihan: const ['Kecil', 'Sedang', 'Besar'],
                      onChanged: (val) {
                        if (val != null)
                          themeC.gantiUkuranTeks(val.toLowerCase());
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _buildSectionLabel('Notifikasi'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Obx(() {
                if (controller.isLoadingNotif.value) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: kuning,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    _buildToggleItem(
                      icon: Icons.notifications_outlined,
                      label: 'Scan Berhasil',
                      nilai: controller.notifScanBerhasil.value,
                      onChanged: controller.toggleScanBerhasil,
                    ),
                    Divider(height: 1, color: Colors.grey.shade100),
                    _buildToggleItem(
                      icon: Icons.notifications_outlined,
                      label: 'Batik Terpopuler',
                      nilai: controller.notifBatikPopuler.value,
                      onChanged: controller.toggleBatikPopuler,
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 32),
            Text(
              'Versi Aplikasi 1.0.0',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) => Text(
    label,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: coklat,
    ),
  );

  Widget _buildDropdownItem({
    required IconData icon,
    required String label,
    required String nilai,
    required List<String> pilihan,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EFE6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: coklat, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          DropdownButton<String>(
            value: nilai,
            underline: const SizedBox(),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black54,
              size: 20,
            ),
            style: const TextStyle(color: Colors.black54, fontSize: 14),
            items: pilihan
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String label,
    required bool nilai,
    required void Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EFE6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: coklat, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Switch(
            value: nilai,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF4CAF50),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  String _kapital(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
