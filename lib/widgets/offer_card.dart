import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';

class OfferCard extends StatelessWidget {
  final String slogan;
  final String title;
  final String subtitle;
  final String imagePath;

  const OfferCard({
    required this.slogan,
    super.key,
    required this.title,
    required this.subtitle,
    this.imagePath = "assets/images/offer_bg.png",
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final theme = Theme.of(context);

    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
            isLight
                ? Colors.white.withOpacity(0.1)
                : AppColors.darkBackground.withOpacity(0.3),
            BlendMode.dstATop,
          ),
        ),
        color: isLight ? AppColors.lightCard : AppColors.darkCard,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(slogan,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isLight
                        ? AppColors.lightTextPrimary
                        : AppColors.darkTextPrimary,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isLight
                        ? AppColors.lightTextSecondary
                        : AppColors.darkTextSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
