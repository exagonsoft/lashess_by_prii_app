import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/views/base_screen_scafold.dart';
import 'package:lashess_by_prii_app/widgets/offer_card_slider.dart';
import 'package:lashess_by_prii_app/widgets/services_skeleton_loader.dart';
import 'package:lashess_by_prii_app/widgets/testimonial_form.dart';
import 'package:provider/provider.dart';
import 'package:lashess_by_prii_app/controllers/main_controller.dart';
import 'package:lashess_by_prii_app/l10n/app_localizations.dart';
import 'package:lashess_by_prii_app/widgets/service_card.dart';
import 'package:lashess_by_prii_app/widgets/stylist_card.dart';
import 'package:lashess_by_prii_app/widgets/booking_button.dart';
import 'package:lashess_by_prii_app/widgets/testimonial_card.dart';

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

            // ✅ Hero image (skeleton while loading)
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
            Text(
              t.servicesAndPrices,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
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

            // ✅ Special Offer + Stylists
            controller.isLoading
                ? Row(
                    children: const [
                      Expanded(child: SkeletonBox(height: 160, borderRadius: 16)),
                      SizedBox(width: 16),
                      SkeletonBox(width: 100, height: 160, borderRadius: 16),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: OfferSlider(offers: controller.offers),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: const [
                            StylistCard(
                                name: "Emma",
                                image: "assets/images/stylist1.png"),
                            SizedBox(height: 16),
                            StylistCard(
                                name: "Sophia",
                                image: "assets/images/stylist2.png"),
                          ],
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 28),

            // ✅ Quick Booking
            Row(
              children: [
                const Icon(Icons.access_time, size: 20),
                const SizedBox(width: 8),
                Text(t.quickBooking,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
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
            Row(
              children: [
                Icon(Icons.favorite, size: 20, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  t.whatClientsSay,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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

            // ✅ Submit testimonial form
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
