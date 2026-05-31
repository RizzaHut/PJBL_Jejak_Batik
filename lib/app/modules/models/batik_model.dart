import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class BatikModel {
  final String docId;
  final String nama;
  final String daerah;
  final String imagePath;
  final String deskripsi;
  final String route;

  const BatikModel({
    required this.docId,
    required this.nama,
    required this.daerah,
    required this.imagePath,
    required this.deskripsi,
    required this.route,
  });

  static const Map<String, String> docIdToRoute = {
    'btk1': Routes.hasilKawung,
    'btk2': Routes.hasilParang,
    'btk3': Routes.hasilMegaMendung,
    'btk4': Routes.hasilSogan,
    'btk5': Routes.hasilSekarJagad,
    'btk6': Routes.hasilBali,
    'btk7': Routes.hasilBetawi,
    'btk8': Routes.hasilCelup,
    'btk9': Routes.hasilCendrawasih,
    'btk10': Routes.hasilCeplok,
    'btk11': Routes.hasilCiamis,
    'btk12': Routes.hasilGarutan,
    'btk13': Routes.hasilGentongan,
    'btk14': Routes.hasilKeraton,
    'btk15': Routes.hasilLasem,
    'btk16': Routes.hasilPekalongan,
    'btk17': Routes.hasilPriangan,
  };
}

class DetailBatik {
  final String title;
  final String content;

  const DetailBatik({required this.title, required this.content});

  factory DetailBatik.fromMap(Map<String, dynamic> map) {
    return DetailBatik(
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
    );
  }
}

class HasilScanModel {
  final String docId;
  final String nama;
  final String daerah;
  final String imagePath;
  final List<DetailBatik> detail;
  final List<BatikModel> terkait;
  final String route;

  const HasilScanModel({
    required this.docId,
    required this.nama,
    required this.daerah,
    required this.imagePath,
    required this.detail,
    required this.terkait,
    required this.route,
  });

  factory HasilScanModel.fromFirestore(
    String docId,
    Map<String, dynamic> data,
    List<BatikModel> terkaitList,
  ) {
    return HasilScanModel(
      docId: docId,
      nama: data['nama'] as String? ?? '',
      daerah: data['daerah'] as String? ?? '',
      imagePath: data['imagePath'] as String? ?? '',
      detail: (data['detail'] as List<dynamic>? ?? [])
          .map((d) => DetailBatik.fromMap(d as Map<String, dynamic>))
          .toList(),
      terkait: terkaitList,
      route: BatikModel.docIdToRoute[docId] ?? '',
    );
  }
}
