import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/widgets/trending_modal.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const OfferCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => TrendingStyleDetailModal(
          imageUrl: imageUrl,
          title: title,
        ),
      ),
      child:Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(imageUrl, height: 140, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            )
          ],
        ),
      ),
      ),
    );
  }
}