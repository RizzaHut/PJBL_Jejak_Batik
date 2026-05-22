import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/batik_model.dart';

class ScanHistoryRow extends StatelessWidget {
  final List<BatikModel> items;

  const ScanHistoryRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Terakhir Pemindaian',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Lihat Semua',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 15),

        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 15),
            itemBuilder: (_, i) => _ScanHistoryCard(batik: items[i]),
          ),
        ),
      ],
    );
  }
}

class _ScanHistoryCard extends StatelessWidget {
  final BatikModel batik;

  const _ScanHistoryCard({required this.batik});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(batik.route, arguments: batik.docId),
      child: Container(
        width: 125,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(batik.imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                batik.nama,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
