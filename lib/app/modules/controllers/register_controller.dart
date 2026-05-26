import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isObscure = true.obs;
  final RxBool isObscureConfirm = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void toggleObscure() => isObscure.value = !isObscure.value;
  void toggleObscureConfirm() =>
      isObscureConfirm.value = !isObscureConfirm.value;

  Future<void> register() async {
    final name = nameC.text.trim();
    final email = emailC.text.trim();
    final password = passwordC.text;
    final confirmPassword = confirmPasswordC.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackbar('Error', 'Semua field harus diisi', isError: true);
      return;
    }

    if (password.length < 6) {
      _showSnackbar('Error', 'Password minimal 6 karakter', isError: true);
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar('Error', 'Password dan konfirmasi password tidak sama',
          isError: true);
      return;
    }

    isLoading.value = true;
    try {
      
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final String uid = credential.user!.uid;

   
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'name': name,
          'email': email,
          'photoUrl': '',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        _showSnackbar('Registrasi Berhasil', 'Selamat Datang di Jejak Batik');

        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(Routes.home);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email sudah terdaftar, gunakan email lain';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        case 'weak-password':
          message = 'Password terlalu lemah, gunakan minimal 6 karakter';
          break;
        case 'operation-not-allowed':
          message = 'Registrasi dengan email tidak diaktifkan';
          break;
        default:
          message = 'Terjadi kesalahan: ${e.code}';
      }
      _showSnackbar('Registrasi Gagal', message, isError: true);
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
          ? Colors.red
          : Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    nameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }
}
