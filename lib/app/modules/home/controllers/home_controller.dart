import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/batik_model.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxString nama = ''.obs;
  final RxString photoUrl = ''.obs;
  final RxList<BatikModel> terakhirMemindai = <BatikModel>[].obs;
  final RxBool isLoadingRiwayat = true.obs;
  final Rxn<BatikModel> batikPilihan = Rxn<BatikModel>();
  final RxBool isLoadingPilihan = true.obs;

  static const Map<String, String> _docIdToRoute = {
    'kawung': Routes.hasilKawung,
    'parang': Routes.hasilParang,
    'mega_mendung': Routes.hasilMegaMendung,
    'sogan': Routes.hasilSogan,
    'sekar_jagad': Routes.hasilSekarJagad,
  };

  @override
  void onInit() {
    super.onInit();
    _streamUser();
    _fetchRiwayatScan();
    _fetchBatikPilihan();
  }

  void _streamUser() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _db.collection('users').doc(uid).snapshots().listen((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        nama.value = data['name'] as String? ?? '';
        photoUrl.value = data['photoUrl'] as String? ?? '';
      }
    });
  }

  Future<void> _fetchRiwayatScan() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      isLoadingRiwayat.value = false;
      return;
    }
    try {
      final snap = await _db
          .collection('users')
          .doc(uid)
          .collection('scan_history')
          .orderBy('scannedAt', descending: true)
          .limit(5)
          .get();

      final List<BatikModel> hasil = [];
      for (final doc in snap.docs) {
        final batikId = doc.data()['batikId'] as String? ?? '';
        if (batikId.isEmpty) continue;
        try {
          final batikDoc = await _db.collection('batik').doc(batikId).get();
          if (!batikDoc.exists) continue;
          final bd = batikDoc.data()!;
          hasil.add(
            BatikModel(
              nama: bd['nama'] as String? ?? '',
              asal: bd['asal'] as String? ?? '',
              imagePath:
                  bd['imagePath'] as String? ?? 'assets/home/$batikId.png',
              deskripsi: bd['deskripsi'] as String? ?? '',
              route: _docIdToRoute[batikId] ?? Routes.hasilKawung,
            ),
          );
        } catch (_) {}
      }
      terakhirMemindai.assignAll(hasil);
    } catch (_) {
      terakhirMemindai.clear();
    } finally {
      isLoadingRiwayat.value = false;
    }
  }

  Future<void> _fetchBatikPilihan() async {
    try {
      final configDoc = await _db
          .collection('config')
          .doc('pilihan_minggu_ini')
          .get();

      // Fallback ke mega_mendung jika dokumen belum ada
      final batikId = configDoc.data()?['batikId'] as String? ?? 'mega_mendung';

      final batikDoc = await _db.collection('batik').doc(batikId).get();
      if (batikDoc.exists) {
        final bd = batikDoc.data()!;
        batikPilihan.value = BatikModel(
          nama: bd['nama'] as String? ?? '',
          asal: bd['asal'] as String? ?? '',
          imagePath: bd['imagePath'] as String? ?? 'assets/home/$batikId.png',
          deskripsi: bd['deskripsi'] as String? ?? '',
          route: _docIdToRoute[batikId] ?? Routes.hasilKawung,
        );
      }
    } catch (_) {
      batikPilihan.value = null;
    } finally {
      isLoadingPilihan.value = false;
    }
  }

  Future<void> refresh() async {
    isLoadingRiwayat.value = true;
    isLoadingPilihan.value = true;
    await Future.wait([_fetchRiwayatScan(), _fetchBatikPilihan()]);
  }
}
