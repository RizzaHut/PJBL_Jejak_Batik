import 'package:flutter/material.dart';
import '../models/batik_model.dart';

class BatikAccordion extends StatelessWidget {
  final DetailBatik detail;
  final bool initiallyExpanded;

  const BatikAccordion({
    super.key,
    required this.detail,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: EdgeInsets.zero,
          title: Text(
            detail.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                detail.content,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BatikAccordionList extends StatelessWidget {
  final List<DetailBatik> items;

  const BatikAccordionList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((d) => BatikAccordion(detail: d)).toList(),
    );
  }
}
