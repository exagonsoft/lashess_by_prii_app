import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/views/base_screen_scafold.dart';
import 'package:lashess_by_prii_app/widgets/offer_card_slider.dart';
import 'package:lashess_by_prii_app/widgets/services_skeleton_loader.dart';
import 'package:lashess_by_prii_app/widgets/testimonial_form.dart';
import 'package:provider/provider.dart';
import 'package:lashess_by_prii_app/controllers/main_controller.dart';
import 'package:lashess_by_prii_app/l10n/app_localizations.dart';
import 'package:lashess_by_prii_app/widgets/service_card.dart';
import 'package:lashess_by_prii_app/widgets/booking_button.dart';
import 'package:lashess_by_prii_app/widgets/testimonial_card.dart';
import 'package:lashess_by_prii_app/widgets/stylist_card.dart';

/// ✅ Reusable Section Header
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MainController>();
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BaseScaffold(
      currentIndex: 0,
      showBack: false,
      body: RefreshIndicator(
        onRefresh: () => controller.loadData(forceRefresh: true),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ✅ Welcome
            Text(
              "${t.welcome} to ${t.appTitle}",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Hero image
            controller.isLoading
                ? const SkeletonBox(height: 180, borderRadius: 16)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      "assets/images/salon_banner.jpg",
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                    ),
                  ),
            const SizedBox(height: 24),

            // ✅ Services
            SectionHeader(icon: Icons.design_services, title: t.servicesAndPrices),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: controller.isLoading
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, __) =>
                          const SkeletonBox(width: 120, height: 150, borderRadius: 16),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.services.length,
                      itemBuilder: (context, index) {
                        final service = controller.services[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ServiceCard(
                            label: service.name,
                            imagePath: service.imageUrl,
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 28),

            // ✅ Special Offers + Stylists
            SectionHeader(icon: Icons.local_offer, title: t.specialOffers),
            const SizedBox(height: 12),
            controller.isLoading
                ? const SkeletonBox(height: 260, borderRadius: 16)
                : Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 👉 Offer slider
                        SizedBox(
                          height: 180,
                          child: OfferSlider(offers: controller.offers),
                        ),
                        const SizedBox(height: 20),

                        // 👉 Stylists row
                        Text(
                          t.meetOurStylists,
                          style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 110,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              StylistCard(
                                name: "Emma",
                                image: "assets/images/stylist1.png",
                              ),
                              SizedBox(width: 16),
                              StylistCard(
                                name: "Sophia",
                                image: "assets/images/stylist2.png",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 28),

            // ✅ Quick Booking
            SectionHeader(icon: Icons.access_time, title: t.quickBooking),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: controller.isLoading
                  ? const [
                      SkeletonBox(width: 80, height: 40, borderRadius: 20),
                      SkeletonBox(width: 80, height: 40, borderRadius: 20),
                      SkeletonBox(width: 80, height: 40, borderRadius: 20),
                    ]
                  : const [
                      BookingButton("10:00 AM"),
                      BookingButton("11:00 AM"),
                      BookingButton("12:00 PM"),
                    ],
            ),
            const SizedBox(height: 28),

            // ✅ Testimonials
            SectionHeader(icon: Icons.favorite, title: t.whatClientsSay),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: controller.isLoading
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, __) =>
                          const SkeletonBox(width: 200, height: 120, borderRadius: 16),
                    )
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        TestimonialCard(
                          text: "Amazing service, I love my lashes! 🤍",
                          author: "Maria",
                        ),
                        TestimonialCard(
                          text: "Best salon experience ever! ⭐⭐⭐⭐⭐",
                          author: "Ana",
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),

            // ✅ Testimonial form
            if (!controller.isLoading)
              TestimonialForm(
                onSubmit: (text, author) {
                  debugPrint("📢 New testimonial: $text by $author");
                },
              ),
          ],
        ),
      ),
    );
  }
}
