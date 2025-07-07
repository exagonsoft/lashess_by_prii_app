// lib/widgets/offer_detail_modal.dart
import 'package:flutter/material.dart';

class OfferDetailModal extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const OfferDetailModal({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (_, controller) => SingleChildScrollView(
        controller: controller,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl),
              ),
              const SizedBox(height: 16),
              Text("Take advantage of this offer while it lasts!",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Claim Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
