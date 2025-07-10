import 'package:flutter/material.dart';

class FeaturedStyleCard extends StatelessWidget {
  final String imageUrl;

  const FeaturedStyleCard({
    super.key,
    required this.imageUrl,
  });

  void _showFullImage(BuildContext context) {
    final halfScreenHeight = MediaQuery.of(context).size.height / 2;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: InteractiveViewer(
            panEnabled: true,
            scaleEnabled: true,
            minScale: 0.5,
            alignment: Alignment.center,
            child: SizedBox(
              height: halfScreenHeight,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, _) => Container(
                  height: halfScreenHeight,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.90;

    return GestureDetector(
      onTap: () => _showFullImage(context),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12, right: 8),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                width: cardWidth,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, _) => Container(
                  width: cardWidth,
                  height: 180,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
