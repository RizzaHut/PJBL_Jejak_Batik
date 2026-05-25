import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/galeri_model.dart';
import '../../routes/app_routes.dart';

class GaleriController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<RiwayatScanItem> semuaRiwayat = <RiwayatScanItem>[].obs;
  final RxList<RiwayatScanItem> riwayatTerfilter = <RiwayatScanItem>[].obs;
  final Rxn<GaleriStats> stats = Rxn<GaleriStats>();
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;

  static const Map<String, String> _docIdToRoute = {
    'btk1': Routes.hasilKawung,
    'btk2': Routes.hasilParang,
    'btk3': Routes.hasilMegaMendung,
    'btk4': Routes.hasilSekarJagad,
    'btk5': Routes.hasilSogan,
  };

  @override
  void onInit() {
    super.onInit();
    _fetchRiwayat();
    debounce(
      searchQuery,
      (_) => _filterRiwayat(),
      time: const Duration(milliseconds: 300),
    );
  }

  Future<void> _fetchRiwayat() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    try {
      final snap = await _db
          .collection('users')
          .doc(uid)
          .collection('riwayat_scan')
          .orderBy('scannedAt', descending: true)
          .get();

      final List<RiwayatScanItem> hasil = [];

      for (final doc in snap.docs) {
        final data = doc.data();
        final batikId = data['batikId'] as String? ?? '';
        if (batikId.isEmpty) continue;

        try {
          final batikDoc = await _db.collection('batik').doc(batikId).get();
          if (!batikDoc.exists) continue;

          final bd = batikDoc.data()!;
          final scannedAt =
              (data['scannedAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          hasil.add(
            RiwayatScanItem(
              scanId: doc.id,
              batikId: batikId,
              nama: bd['nama'] as String? ?? '',
              daerah: bd['daerah'] as String? ?? '',
              deskripsi: _getFirstDeskripsi(bd),
              imagePath: bd['imagePath'] as String? ?? '',
              route: _docIdToRoute[batikId] ?? Routes.hasilKawung,
              scannedAt: scannedAt,
            ),
          );
        } catch (_) {}
      }

      semuaRiwayat.assignAll(hasil);
      riwayatTerfilter.assignAll(hasil);
      _hitungStats(hasil);
    } catch (e) {
      debugPrint('GaleriController _fetchRiwayat error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Ambil deskripsi singkat dari field detail[0].content
  String _getFirstDeskripsi(Map<String, dynamic> bd) {
    try {
      final detail = bd['detail'] as List<dynamic>?;
      if (detail == null || detail.isEmpty) return '';
      final first = detail[0] as Map<String, dynamic>;
      return first['content'] as String? ?? '';
    } catch (_) {
      return '';
    }
  }

  void _hitungStats(List<RiwayatScanItem> data) {
    if (data.isEmpty) {
      stats.value = GaleriStats.empty();
      return;
    }
    final terakhir = _formatWaktu(data.first.scannedAt);
    final frekuensiNama = <String, int>{};
    for (final item in data) {
      frekuensiNama[item.nama] = (frekuensiNama[item.nama] ?? 0) + 1;
    }
    final motifTerbanyak = frekuensiNama.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key
        .replaceFirst('Batik ', '');

    // Asal dominan — hitung frekuensi daerah
    final frekuensiDaerah = <String, int>{};
    for (final item in data) {
      if (item.daerah.isEmpty) continue;
      frekuensiDaerah[item.daerah] = (frekuensiDaerah[item.daerah] ?? 0) + 1;
    }
    final asalDominan = frekuensiDaerah.isEmpty
        ? '-'
        : frekuensiDaerah.entries
              .reduce((a, b) => a.value >= b.value ? a : b)
              .key;

    stats.value = GaleriStats(
      terakhirDitambahkan: terakhir,
      motifTerbanyak: motifTerbanyak,
      asalDominan: asalDominan,
    );
  }

  // Format DateTime ke string relatif
  String _formatWaktu(DateTime waktu) {
    final selisih = DateTime.now().difference(waktu);
    if (selisih.inMinutes < 60) return '${selisih.inMinutes} menit lalu';
    if (selisih.inHours < 24) return '${selisih.inHours} jam lalu';
    if (selisih.inDays < 7) return '${selisih.inDays} hari lalu';
    return '${waktu.day}/${waktu.month}/${waktu.year}';
  }

  void onSearchChanged(String query) {
    searchQuery.value = query.toLowerCase();
  }

  void _filterRiwayat() {
    final q = searchQuery.value;
    if (q.isEmpty) {
      riwayatTerfilter.assignAll(semuaRiwayat);
    } else {
      riwayatTerfilter.assignAll(
        semuaRiwayat.where(
          (item) =>
              item.nama.toLowerCase().contains(q) ||
              item.daerah.toLowerCase().contains(q),
        ),
      );
    }
  }

  // Format tanggal untuk ditampilkan di card
  String formatTanggal(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';

  // Refresh data
  Future<void> refresh() => _fetchRiwayat();
}
