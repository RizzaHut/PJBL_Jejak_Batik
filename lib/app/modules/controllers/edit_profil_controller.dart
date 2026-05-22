import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

//Janlup tambahain logika kalo password kosong, kurang dari 6 kata, sama enggak cocok
//

class EditProfilController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController namaC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController konfirmasiPasswordC = TextEditingController();

  final RxString photoUrl = ''.obs;
  final RxBool isObscurePassword = true.obs;
  final RxBool isObscureKonfirmasi = true.obs;
  final RxBool isSaving = false.obs;
  final RxBool isUploadingPhoto = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        namaC.text = data['name'] as String? ?? '';
        emailC.text = data['email'] as String? ?? '';
        photoUrl.value = data['photoUrl'] as String? ?? '';
      }
    } catch (e) {
      debugPrint('EditProfilController _loadUserData error: $e');
    }
  }

  void toggleObscurePassword() =>
      isObscurePassword.value = !isObscurePassword.value;

  void toggleObscureKonfirmasi() =>
      isObscureKonfirmasi.value = !isObscureKonfirmasi.value;

  Future<void> pickAndUploadFoto() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxWidth: 256,
    );
    if (picked == null) return;

    isUploadingPhoto.value = true;
    final bytes = await picked.readAsBytes();
    final base64Str = 'data:image/jpeg;base64,${base64Encode(bytes)}';

    final uid = _auth.currentUser?.uid;
    await _db.collection('users').doc(uid).update({
      'photoUrl': base64Str,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    photoUrl.value = base64Str;
    isUploadingPhoto.value = false;
  }

  Future<void> simpanPerubahan() async {
    final nama = namaC.text.trim();
    final password = passwordC.text;
    final konfirmasi = konfirmasiPasswordC.text;

    if (nama.isEmpty) {
      _showSnackbar('Error', 'Nama tidak boleh kosong', isError: true);
      return;
    }

    if (password.isNotEmpty) {
      if (password.length < 6) {
        _showSnackbar('Error', 'Password minimal 6 karakter', isError: true);
        return;
      }
      if (password != konfirmasi) {
        _showSnackbar(
          'Error',
          'Password dan konfirmasi tidak sama',
          isError: true,
        );
        return;
      }
    }

    isSaving.value = true;

    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;
      await _db.collection('users').doc(uid).update({
        'name': nama,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      if (password.isNotEmpty) {
        await _auth.currentUser!.updatePassword(password);
      }

      _showSnackbar('Berhasil', 'Profil berhasil diperbarui');

      await Future.delayed(const Duration(milliseconds: 800));
      Get.back();
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'requires-recent-login':
          msg = 'Sesi habis, silakan login ulang untuk ganti password';
          break;
        case 'weak-password':
          msg = 'Password terlalu lemah';
          break;
        default:
          msg = 'Firebase error: ${e.code}';
      }
      _showSnackbar('Gagal', msg, isError: true);
    } catch (e) {
      _showSnackbar('Gagal', 'Terjadi kesalahan: $e', isError: true);
    } finally {
      isSaving.value = false;
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
    namaC.dispose();
    emailC.dispose();
    passwordC.dispose();
    konfirmasiPasswordC.dispose();
    super.onClose();
  }
}
