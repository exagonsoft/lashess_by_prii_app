import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String imageUrl;
  final String url;
  final VoidCallback? onTap;

  const EventCard({
    required this.title,
    required this.date,
    required this.imageUrl,
    required this.url,
    this.onTap,
    super.key,
  });

  Future<void> _launchURL(BuildContext context) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open event URL.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 20, 20, 20).withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(1, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.event, size: 20, color: Colors.pink.shade300),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
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
