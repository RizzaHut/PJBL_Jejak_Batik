import 'package:cloud_firestore/cloud_firestore.dart';

class RiwayatScanItem {
  final String scanId;
  final String batikId;
  final String nama;
  final String daerah;
  final String deskripsi;
  final String imagePath;
  final String route;
  final DateTime scannedAt;

  const RiwayatScanItem({
    required this.scanId,
    required this.batikId,
    required this.nama,
    required this.daerah,
    required this.deskripsi,
    required this.imagePath,
    required this.route,
    required this.scannedAt,
  });
}

class GaleriStats {
  final String terakhirDitambahkan; 
  final String motifTerbanyak;
  final String asalDominan;

  const GaleriStats({
    required this.terakhirDitambahkan,
    required this.motifTerbanyak,
    required this.asalDominan,
  });

  factory GaleriStats.empty() => const GaleriStats(
        terakhirDitambahkan: '-',
        motifTerbanyak: '-',
        asalDominan: '-',
      );
}
