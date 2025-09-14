import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/repositories/offers_repository.dart';
import 'package:lashess_by_prii_app/views/offer_details_screen.dart';
import '../models/offer.dart';

class OfferDetailsLoader extends StatelessWidget {
  final String id;

  const OfferDetailsLoader({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Offer?>(
      future: OffersRepository().getOfferById(id), // implement in repo
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("❌ Error: ${snapshot.error}")),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("⚠️ Oferta no encontrada")),
          );
        }

        return OfferDetailsScreen(offer: snapshot.data!);
      },
    );
  }
}
