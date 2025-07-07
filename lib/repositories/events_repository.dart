import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class EventsRepository {
  final String apiUrl;
  List<Event> _cachedEvents = [];

  EventsRepository({this.apiUrl = 'http://localhost:3000'});

  Future<List<Event>> getUpcomingEvents({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedEvents.isNotEmpty) {
      return _cachedEvents;
    }

    if (!await _isApiHealthy()) {
      _cachedEvents = _mockEvents();
      return _cachedEvents;
    }

    try {
      final response = await http.get(Uri.parse('$apiUrl/events'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _cachedEvents = data
            .map((e) => Event(
                  id: e['id'],
                  title: e['title'],
                  description: e['description'],
                  imageUrl: e['imageUrl'],
                  date: DateTime.parse(e['date']),
                  url: e['url'],
                ))
            .toList();
        return _cachedEvents;
      } else {
        _cachedEvents = _mockEvents();
        return _cachedEvents;
      }
    } catch (_) {
      _cachedEvents = _mockEvents();
      return _cachedEvents;
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

  List<Event> _mockEvents() => [
        Event(
          id: 'event1',
          title: 'Summer Glam Night',
          description: 'Join us for a night of glam and style.',
          imageUrl: 'https://picsum.photos/400/200?random=1',
          date: DateTime.now().add(const Duration(days: 7)),
          url: 'https://lashess-by-prii.com/events/summer-glam-night',
        ),
        Event(
          id: 'event2',
          title: 'Client Appreciation Day',
          description: 'Celebrate our amazing clients with exclusive gifts.',
          imageUrl: 'https://picsum.photos/400/200?random=2',
          date: DateTime.now().add(const Duration(days: 14)),
          url: 'https://lashess-by-prii.com/events/summer-glam-night',
        ),
      ];
}

