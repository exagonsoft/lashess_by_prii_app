import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/widgets/featured_look_card.dart';
import 'package:provider/provider.dart';
import '../../controllers/main_controller.dart';
import '../../widgets/trending_card.dart';
import '../../widgets/event_card.dart';
import '../../widgets/offer_card.dart';
import '../../widgets/call_to_action_card.dart';
import '../../widgets/section_header.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<MainController>(context, listen: false).loadData());
  }

  Future<void> _onRefresh() async {
    await Provider.of<MainController>(context, listen: false)
        .loadData(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MainController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenida')),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  if (controller.styles.isNotEmpty) ...[
                    const SectionHeader(title: "🔥 Trending Styles"),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.styles.length,
                        itemBuilder: (context, index) {
                          final style = controller.styles[index];
                          return TrendingCard(
                            title: style.name,
                            imageUrl: style.imageUrl,
                          );
                        },
                      ),
                    ),
                  ],
                  if (controller.events.isNotEmpty) ...[
                    const SectionHeader(title: "🎉 Upcoming Events"),
                    for (var event in controller.events)
                      EventCard(
                        title: event.title,
                        date: event.date.toLocal().toString().split(" ")[0],
                        imageUrl: event.imageUrl,
                        url: event.url,
                      ),
                  ],
                  if (controller.offers.isNotEmpty) ...[
                    const SectionHeader(title: "💰 Special Offers"),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.offers.length,
                        itemBuilder: (context, index) {
                          final offer = controller.offers[index];
                          return OfferCard(
                            title: offer.title,
                            subtitle: offer.subtitle,
                            imageUrl: offer.imageUrl,
                          );
                        },
                      ),
                    ),
                  ],
                  const SectionHeader(title: "💅 Featured Looks"),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: controller.styles.take(3).length,
                      itemBuilder: (context, index) {
                        final style = controller.styles[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: FeaturedStyleCard(
                            imageUrl: style.imageUrl,
                          ),
                        );
                      },
                    ),
                  ),
                  CallToActionCard(
                    text: '📅 Book your appointment now!',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Booking screen coming soon!')),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
