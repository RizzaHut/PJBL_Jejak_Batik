import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PengaturanController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool notifScanBerhasil = true.obs;
  final RxBool notifBatikPopuler = true.obs;
  final RxBool isLoadingNotif = true.obs;
  double get textScaleFactor => _skala[ukuranTeks.value] ?? 1.0;
  final RxString tema = 'terang'.obs;
  final RxString ukuranTeks = 'sedang'.obs;

  static const Map<String, double> _skala = {
    'kecil': 0.5,
    'sedang': 1.0,
    'besar': 2.0,
  };

  @override
  void onInit() {
    super.onInit();
    _loadNotifikasi();
    _loadPreferensi();
  }

  Future<void> _loadPreferensi() async {
    final prefs = await SharedPreferences.getInstance();
    tema.value = prefs.getString('tema') ?? 'terang';
    ukuranTeks.value = prefs.getString('ukuran_teks') ?? 'sedang';
    Get.changeTheme(
      tema.value == 'gelap' ? ThemeData.dark() : ThemeData.light(),
    );
  }

  Future<void> gantiTema(String nilai) async {
    tema.value = nilai;
    Get.changeTheme(nilai == 'gelap' ? ThemeData.dark() : ThemeData.light());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tema', nilai);
  }

  Future<void> gantiUkuranTeks(String nilai) async {
    ukuranTeks.value = nilai;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ukuran_teks', nilai);
  }

  Future<void> _loadNotifikasi() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      isLoadingNotif.value = false;
      return;
    }
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        final notif = data['notifikasi'] as Map<String, dynamic>?;
        if (notif != null) {
          notifScanBerhasil.value = notif['scanBerhasil'] as bool? ?? true;
          notifBatikPopuler.value = notif['batikPopuler'] as bool? ?? true;
        }
      }
    } catch (_) {
    } finally {
      isLoadingNotif.value = false;
    }
  }

  Future<void> toggleScanBerhasil(bool nilai) async {
    notifScanBerhasil.value = nilai;
    await _simpanNotifikasi();
  }

  Future<void> toggleBatikPopuler(bool nilai) async {
    notifBatikPopuler.value = nilai;
    await _simpanNotifikasi();
  }

  Future<void> _simpanNotifikasi() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      await _db.collection('users').doc(uid).update({
        'notifikasi': {
          'scanBerhasil': notifScanBerhasil.value,
          'batikPopuler': notifBatikPopuler.value,
        },
      });
    } catch (_) {}
  }
}
