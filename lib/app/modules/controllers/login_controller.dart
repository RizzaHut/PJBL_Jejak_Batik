import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isObscure = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void toggleObscure() => isObscure.value = !isObscure.value;

  Future<void> login() async {
    final email = emailC.text.trim();
    final password = passwordC.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar('Error', 'Email dan password harus diisi', isError: true);
      return;
    }

    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed(Routes.home);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Akun tidak ditemukan';
          break;
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Email atau password salah';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        case 'user-disabled':
          message = 'Akun ini telah dinonaktifkan';
          break;
        case 'too-many-requests':
          message = 'Terlalu banyak percobaan. Coba lagi nanti';
          break;
        default:
          message = 'Terjadi kesalahan: ${e.code}';
      }
      _showSnackbar('Login Gagal', message, isError: true);
    } catch (e) {
      _showSnackbar('Error', 'Terjadi kesalahan: $e', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError
          ? const Color(0xFFD00E0E)
          : const Color(0xFF16AE26),
      colorText: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
