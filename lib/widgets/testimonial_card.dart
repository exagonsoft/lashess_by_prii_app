import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';

class TestimonialCard extends StatelessWidget {
  final String text;
  final String author;

  const TestimonialCard({
    super.key,
    required this.text,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return SizedBox(
      // ✅ Force width/height for horizontal list
      width: 220,
      height: 140,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Card(
          margin: const EdgeInsets.only(right: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: isLight ? AppColors.lightCard : AppColors.darkCard,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "- $author",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
