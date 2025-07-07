// lib/widgets/event_detail_modal.dart
import 'package:flutter/material.dart';

class EventDetailModal extends StatelessWidget {
  final String title;
  final String date;
  final String imageUrl;

  const EventDetailModal({
    super.key,
    required this.title,
    required this.date,
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
              Text("Event Date: $date", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl),
              ),
              const SizedBox(height: 16),
              Text("Don't miss this amazing event hosted at the salon!",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
                label: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
