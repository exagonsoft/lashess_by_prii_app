// lib/controllers/main_controller.dart
import 'package:flutter/material.dart';
import 'package:lashess_by_prii_app/models/lashee_service.dart';
import 'package:lashess_by_prii_app/repositories/services_repository.dart';
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
  final ServicesRepository servicesRepository;

  List<Event> events = [];
  List<Offer> offers = [];
  List<Style> styles = [];
  List<LashesService> services = [];

  bool isLoading = false;

  MainController({
    required this.eventsRepository,
    required this.offersRepository,
    required this.stylesRepository,
    required this.servicesRepository,
  });

  Future<void> loadData({bool forceRefresh = false}) async {
    isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        eventsRepository.getUpcomingEvents(forceRefresh: forceRefresh),
        offersRepository.getActiveOffers(forceRefresh: forceRefresh),
        stylesRepository.getTrendingStyles(forceRefresh: forceRefresh),
        servicesRepository.getServices(forceRefresh: forceRefresh),
      ]);

      events = results[0] as List<Event>;
      offers = results[1] as List<Offer>;
      styles = results[2] as List<Style>;
      services = results[3] as List<LashesService>;
    } catch (e) {
      print("⚠️ Error loading data: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
