// lib/widgets/trending_style_detail_modal.dart
import 'package:flutter/material.dart';

class TrendingStyleDetailModal extends StatelessWidget {
  final String imageUrl;
  final String title;

  const TrendingStyleDetailModal({
    super.key,
    required this.imageUrl,
    required this.title,
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
              Text(title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl),
              ),
              const SizedBox(height: 16),
              Text("This is a trending style. You can book this look with your stylist.",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check_circle),
                label: const Text("Got it"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
