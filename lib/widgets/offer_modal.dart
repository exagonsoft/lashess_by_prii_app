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
    final ThemeData theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      builder: (_, controller) => SingleChildScrollView(
        controller: controller,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text(subtitle, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl),
              ),
              const SizedBox(height: 16),
              Text("Take advantage of this offer while it lasts!",
                  style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  "Entendido",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
