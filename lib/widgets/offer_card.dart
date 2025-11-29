import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lashess_by_prii_app/styles/app_colors.dart';
import '../models/offer.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;

  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'offer-details',
          pathParameters: {'id': offer.id},
        );
      },
      child: Card(
        elevation: 4, // ✅ shadow depth
        shadowColor: Colors.black.withOpacity(0.4), // ✅ softer shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias, // ✅ ensures rounded corners apply to image
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.appleBlack, // ✅ fallback background
            image: offer.imageUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(offer.imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      AppColors.appleBlack.withOpacity(0.5), // ✅ dark overlay
                      BlendMode.darken,
                    ),
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  offer.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightCard, // ✅ white text
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  offer.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightBackground.withOpacity(0.9), // ✅ softer white
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
