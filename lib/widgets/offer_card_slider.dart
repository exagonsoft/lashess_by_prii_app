import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/models/offer.dart';
import 'offer_card.dart';

class OfferSlider extends StatefulWidget {
  final List<Offer> offers;

  const OfferSlider({super.key, required this.offers});

  @override
  State<OfferSlider> createState() => _OfferSliderState();
}

class _OfferSliderState extends State<OfferSlider> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Auto-slide every 60 seconds
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_currentPage < widget.offers.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // loop back
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.offers.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          final offer = widget.offers[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: OfferCard(offer: offer), // ✅ Pass whole offer
          );
        },
      ),
    );
  }
}
