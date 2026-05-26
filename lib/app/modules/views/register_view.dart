import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6D4A36),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol back
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),

            // Judul
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
              child: Text(
                'Buat Akun',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Daftar untuk memulai perjalananmu',
                style: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 32),

            // Panel putih
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Field Nama
                      _buildLabel('Nama Lengkap'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.nameC,
                        textCapitalization: TextCapitalization.words,
                        decoration: _inputDecoration('Masukkan nama lengkap'),
                      ),

                      const SizedBox(height: 20),

                      // Field Email
                      _buildLabel('Email'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.emailC,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('contoh@email.com'),
                      ),

                      const SizedBox(height: 20),

                      // Field Password
                      _buildLabel('Password'),
                      const SizedBox(height: 8),
                      Obx(
                        () => TextField(
                          controller: controller.passwordC,
                          obscureText: controller.isObscure.value,
                          decoration: _inputDecoration('Min. 6 karakter').copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isObscure.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: controller.toggleObscure,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Password minimal 6 karakter',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),

                      const SizedBox(height: 20),

                      // Field Konfirmasi Password
                      _buildLabel('Konfirmasi Password'),
                      const SizedBox(height: 8),
                      Obx(
                        () => TextField(
                          controller: controller.confirmPasswordC,
                          obscureText: controller.isObscureConfirm.value,
                          decoration: _inputDecoration('Ulangi password').copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isObscureConfirm.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: controller.toggleObscureConfirm,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Tombol Daftar
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6D4A36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Daftar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Link masuk
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sudah punya akun? ',
                            style: TextStyle(color: Colors.black54),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                color: Color(0xFF6D4A36),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
