import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/offer.dart';

class OffersRepository {
  final String apiUrl;
  List<Offer> _cachedOffers = [];
  static const _cacheKey = "offers_cache";

  OffersRepository({
    this.apiUrl = 'https://www.lashees-by-prii.exagon-soft.com/api/v1/public',
  });

  /// Load cache from SharedPreferences into memory
  Future<void> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKey);
    if (cached != null) {
      final List data = json.decode(cached);
      _cachedOffers = data.map((o) => Offer.fromJson(o)).toList();
    }
  }

  /// Save cache to SharedPreferences
  Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_cachedOffers.map((o) => o.toJson()).toList());
    await prefs.setString(_cacheKey, encoded);
  }

  Future<List<Offer>> getActiveOffers({bool forceRefresh = false}) async {
    // ✅ Ensure we load cache from storage if memory is empty
    if (_cachedOffers.isEmpty) {
      await _loadCache();
    }

    if (!forceRefresh && _cachedOffers.isNotEmpty) {
      return _cachedOffers.where((o) => o.active == true).toList();
    }

    try {
      final response = await http.get(Uri.parse('$apiUrl/offers'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _cachedOffers = data.map((o) => Offer.fromJson(o)).toList();
        await _saveCache(); // ✅ persist after fetch
      } else {
        _cachedOffers = _mockOffers();
        await _saveCache();
      }
    } catch (_) {
      _cachedOffers = _mockOffers();
      await _saveCache();
    }

    return _cachedOffers.where((o) => o.active == true).toList();
  }

  Future<Offer?> getOfferById(String id) async {
    if (_cachedOffers.isEmpty) {
      await _loadCache();
    }
    try {
      return _cachedOffers.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Offer> _mockOffers() => [
        Offer(
          id: 'offer1',
          title: '10% OFF All Bookings',
          description: 'Valid until Friday',
          imageUrl: 'https://picsum.photos/400/200?random=1',
          active: true,
          order: 0,
          type: "discount",
          discount: 10,
          startsAt: DateTime.now(),
          endsAt: DateTime.now().add(const Duration(days: 3)),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Offer(
          id: 'offer2',
          title: 'Free Touch-up',
          description: 'With full set purchase',
          imageUrl: 'https://picsum.photos/400/200?random=2',
          active: true,
          order: 1,
          type: "generic",
          discount: null,
          startsAt: DateTime.now(),
          endsAt: DateTime.now().add(const Duration(days: 5)),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
}
