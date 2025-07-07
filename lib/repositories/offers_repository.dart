import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/offer.dart';

class OffersRepository {
  final String apiUrl;
  List<Offer> _cachedOffers = [];

  OffersRepository({this.apiUrl = 'http://localhost:3000'});

  Future<List<Offer>> getActiveOffers({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedOffers.isNotEmpty) {
      return _cachedOffers;
    }
    if (!await _isApiHealthy()) {
      _cachedOffers = _mockOffers();
      return _cachedOffers;
    }

    try {
      final response = await http.get(Uri.parse('$apiUrl/offers'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _cachedOffers = data
            .map((o) => Offer(
                  id: o['id'],
                  title: o['title'],
                  subtitle: o['subtitle'],
                  imageUrl: o['imageUrl'],
                  validUntil: DateTime.parse(o['validUntil']),
                ))
            .toList();
        return _cachedOffers;
      } else {
        _cachedOffers = _mockOffers();
        return _cachedOffers;
      }
    } catch (e) {
      _cachedOffers = _mockOffers();
      return _cachedOffers;
    }
  }

  Future<bool> _isApiHealthy() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/health'));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  List<Offer> _mockOffers() => [
        Offer(
          id: 'offer1',
          title: '10% OFF All Bookings',
          subtitle: 'Valid until Friday',
          imageUrl: 'https://picsum.photos/400/200?random=1',
          validUntil: DateTime.now().add(const Duration(days: 3)),
        ),
        Offer(
          id: 'offer2',
          title: 'Free Touch-up',
          subtitle: 'With full set purchase',
          imageUrl: 'https://picsum.photos/400/200?random=1',
          validUntil: DateTime.now().add(const Duration(days: 5)),
        ),
      ];
}
