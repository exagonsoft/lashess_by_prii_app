// lib/controllers/main_controller.dart
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/offer.dart';
import '../models/style.dart';
import '../repositories/events_repository.dart';
import '../repositories/offers_repository.dart';
import '../repositories/styles_repository.dart';

class MainController extends ChangeNotifier {
  final EventsRepository eventsRepository;
  final OffersRepository offersRepository;
  final StylesRepository stylesRepository;

  List<Event> events = [];
  List<Offer> offers = [];
  List<Style> styles = [];

  bool isLoading = false;

  MainController({
    required this.eventsRepository,
    required this.offersRepository,
    required this.stylesRepository,
  });

  Future<void> loadData({bool forceRefresh = false}) async {
    isLoading = true;
    notifyListeners();

    final futures = await Future.wait([
      eventsRepository.getUpcomingEvents(forceRefresh: forceRefresh),
      offersRepository.getActiveOffers(forceRefresh: forceRefresh),
      stylesRepository.getTrendingStyles(forceRefresh: forceRefresh),
    ]);

    events = futures[0] as List<Event>;
    offers = futures[1] as List<Offer>;
    styles = futures[2] as List<Style>;

    isLoading = false;
    notifyListeners();
  }
}

