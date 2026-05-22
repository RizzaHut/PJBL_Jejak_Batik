import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profil_controller.dart';

class EditProfilView extends GetView<EditProfilController> {
  const EditProfilView({super.key});

  static const Color coklat = Color(0xFF6D4C41);

  @override
  Widget build(BuildContext context) {
    final url = controller.photoUrl.value;
    final isBase64 = url.startsWith('data:image');
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
          'Edit Profil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Obx(
                () => GestureDetector(
                  onTap: controller.pickAndUploadFoto,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: isBase64
                            ? MemoryImage(base64Decode(url.split(',').last))
                            : url.isNotEmpty
                            ? MemoryImage(base64Decode(url.split(',').last))
                            : null,
                        child: url.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 46,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      if (controller.isUploadingPhoto.value)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Badge kamera
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: coklat,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ── [2] Section Personal ─────────────────────────────────
            const Text(
              'Personal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Field Nama
            _buildLabel('Nama Lengkap'),
            const SizedBox(height: 8),
            _buildInput(
              controller: controller.namaC,
              hint: 'Masukkan nama lengkap',
              fillColor: Colors.grey[100],
            ),

            const SizedBox(height: 30),

            // ── [3] Section Email & Password ─────────────────────────
            const Text(
              'Email & Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Field Email (read-only — email dikelola Firebase Auth)
            _buildLabel('Email'),
            const SizedBox(height: 8),
            _buildInput(
              controller: controller.emailC,
              hint: 'email@contoh.com',
              readOnly: true,
              fillColor: Colors.grey[200],
            ),
            const SizedBox(height: 4),
            const Text(
              'Email tidak dapat diubah',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // Field Password baru (opsional)
            _buildLabel('Password Baru (opsional)'),
            const SizedBox(height: 8),
            Obx(
              () => _buildInput(
                controller: controller.passwordC,
                hint: 'Kosongkan jika tidak ingin ganti',
                obscureText: controller.isObscurePassword.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isObscurePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: controller.toggleObscurePassword,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Field Konfirmasi Password
            _buildLabel('Konfirmasi Password Baru'),
            const SizedBox(height: 8),
            Obx(
              () => _buildInput(
                controller: controller.konfirmasiPasswordC,
                hint: 'Ulangi password baru',
                obscureText: controller.isObscureKonfirmasi.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isObscureKonfirmasi.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: controller.toggleObscureKonfirmasi,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ── [4] Tombol Simpan ─────────────────────────────────────
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.isSaving.value
                      ? null
                      : controller.simpanPerubahan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: coklat,
                    disabledBackgroundColor: coklat.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isSaving.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: Colors.black87,
    ),
  );

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    bool readOnly = false,
    Widget? suffixIcon,
    Color? fillColor,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: fillColor ?? Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: coklat),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
