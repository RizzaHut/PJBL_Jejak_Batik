import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  final RxString nama = ''.obs;
  final RxString email = ''.obs;
  final RxString photoUrl = ''.obs;
  final RxBool isUploadingPhoto = false.obs;

  final int koleksiBatik = 13;
  final int totalScan = 18;
  final int daerahTerdeteksi = 4;

  @override
  void onInit() {
    super.onInit();
    _streamUser();
  }

  void _streamUser() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _db.collection('users').doc(uid).snapshots().listen((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        nama.value = data['name'] as String? ?? '';
        email.value = data['email'] as String? ?? '';
        photoUrl.value = data['photoUrl'] as String? ?? '';
      }
    });
  }

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

  Future<void> logout() async {
    await _auth.signOut();
  }
}
