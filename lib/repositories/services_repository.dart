import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lashess_by_prii_app/models/lashee_service.dart';

class ServicesRepository {
  final String apiUrl;
  List<LashesService> _cache = [];

  ServicesRepository({this.apiUrl = 'http://localhost:3000'});

  Future<List<LashesService>> getServices({bool forceRefresh = false}) async {
    if (!forceRefresh && _cache.isNotEmpty) {
      return _cache;
    }

    if (!await _isApiHealthy()) {
      _cache = _mockServices();
      return _cache;
    }

    try {
      final response = await http.get(Uri.parse('$apiUrl/services'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _cache = data
            .map((s) => LashesService.fromJson(s as Map<String, dynamic>))
            .toList();
      } else {
        _cache = _mockServices();
      }
    } catch (_) {
      _cache = _mockServices();
    }

    return _cache;
  }

  Future<bool> _isApiHealthy() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/health'));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  List<LashesService> _mockServices() => [
        LashesService(
          id: 'srv1',
          name: 'Classic Lashes',
          imageUrl:
              'https://www.limitlessbeautysalon.com/cdn/shop/products/image_fb94b25e-d333-4da2-ad34-cc362750f45a_1080x.png?v=1641146122',
          description: 'Natural look with individual lash extensions.',
          price: '\$40',
        ),
        LashesService(
          id: 'srv2',
          name: 'Volume Lashes',
          imageUrl:
              'https://minkys.com/cdn/shop/products/volume-lashes-003-variety-trays-497154.jpg?v=1690915762&width=1000',
          description: 'Fuller and more dramatic lash appearance.',
          price: '\$60',
        ),
        LashesService(
          id: 'srv3',
          name: 'Lash Lift',
          imageUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEdvVVoJhuGDVtvWESo-3ypgay15wdsJ07TA&s',
          description: 'Enhances your natural lashes with a lifting effect.',
          price: '\$35',
        ),
      ];
}
