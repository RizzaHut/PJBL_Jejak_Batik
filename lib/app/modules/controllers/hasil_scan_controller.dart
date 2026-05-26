import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/batik_model.dart';
import '../../routes/app_routes.dart';

class HasilScanController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var isLoading = true.obs;
  var errorMsg = ''.obs;
  var currentBatik = Rxn<HasilScanModel>();
  final Map<String, HasilScanModel> _cache = {};

  @override
  void onInit() {
    super.onInit();
    final docId = Get.arguments as String? ?? 'btk1';
    _loadBatik(docId);
  }

  Future<void> _loadBatik(String docId) async {
    if (_cache.containsKey(docId)) {
      currentBatik.value = _cache[docId];
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    errorMsg.value = '';

    try {
      final doc = await _db.collection('batik').doc(docId).get();
      if (!doc.exists) {
        errorMsg.value = 'Data batik tidak ditemukan';
        return;
      }

      final data = doc.data()!;
      final daerah = data['daerah'] as String? ?? '';
      final terkaitList = await _fetchTerkaitByDaerah(
        daerah: daerah,
        excludeDocId: docId,
      );
      final batik = HasilScanModel.fromFirestore(docId, data, terkaitList);
      _cache[docId] = batik;
      currentBatik.value = batik;
    } on FirebaseException catch (e) {
      errorMsg.value = 'Firebase error: ${e.message}';
      debugPrint('FirebaseException: ${e.code} — ${e.message}');
    } catch (e) {
      errorMsg.value = 'Terjadi kesalahan';
      debugPrint('HasilScanController error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<BatikModel>> _fetchTerkaitByDaerah({
    required String daerah,
    required String excludeDocId,
  }) async {
    if (daerah.isEmpty) return [];

    try {
      final snap = await _db
          .collection('batik')
          .where('daerah', isEqualTo: daerah)
          .limit(6) // ambil lebih, nanti filter exclude
          .get();

      return snap.docs
          .where((doc) => doc.id != excludeDocId) // exclude diri sendiri
          .take(4) // max 4 batik terkait
          .map((doc) {
            final d = doc.data();
            return BatikModel(
              docId: doc.id,
              nama: d['nama'] as String? ?? '',
              daerah: d['daerah'] as String? ?? '',
              imagePath: d['imagePath'] as String? ?? '',
              deskripsi: '',
              route: BatikModel.docIdToRoute[doc.id] ?? Routes.hasilKawung,
            );
          })
          .toList();
    } catch (e) {
      debugPrint('_fetchTerkaitByDaerah error: $e');
      return [];
    }
  }
}
