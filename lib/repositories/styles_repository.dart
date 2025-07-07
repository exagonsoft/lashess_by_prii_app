import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/style.dart';

class StylesRepository {
  final String apiUrl;
  List<Style> _cachedStyles = [];

  StylesRepository({this.apiUrl = 'http://localhost:3000'});

  Future<List<Style>> getTrendingStyles({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedStyles.isNotEmpty) {
      return _cachedStyles;
    }

    if (!await _isApiHealthy()) {
      _cachedStyles = _mockStyles();
      return _cachedStyles;
    }

    try {
      final response = await http.get(Uri.parse('$apiUrl/styles'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _cachedStyles = data
            .map((s) => Style(
                  id: s['id'],
                  name: s['name'],
                  imageUrl: s['imageUrl'],
                  isTrending: s['isTrending'],
                ))
            .toList();
        return _cachedStyles;
      } else {
        _cachedStyles = _mockStyles();
        return _cachedStyles;
      }
    } catch (e) {
      _cachedStyles = _mockStyles();
      return _cachedStyles;
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

  List<Style> _mockStyles() => [
        Style(
          id: 'style1',
          name: 'Wispy Volume',
          imageUrl: 'https://picsum.photos/400/200?random=1',
          isTrending: true,
        ),
        Style(
          id: 'style2',
          name: 'Hybrid Lashes',
          imageUrl: 'https://picsum.photos/400/200?random=1',
          isTrending: true,
        ),
        Style(
          id: 'style3',
          name: 'Mega Volume',
          imageUrl: 'https://picsum.photos/400/200?random=1',
          isTrending: true,
        ),
      ];
}
