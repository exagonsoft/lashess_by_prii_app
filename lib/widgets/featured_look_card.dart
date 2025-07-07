import 'package:flutter/material.dart';

class FeaturedStyleCard extends StatelessWidget {
  final String imageUrl;

  const FeaturedStyleCard({
    super.key,
    required this.imageUrl,
  });

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, _) => Container(
                height: 300,
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image, size: 48),
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
    final cardWidth = screenWidth * 0.6;

    return GestureDetector(
      onTap: () => _showFullImage(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
            width: screenWidth,
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
    );
  }
}
