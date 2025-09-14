class LashesService {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final String price;

  LashesService({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
  });

  factory LashesService.fromJson(Map<String, dynamic> json) {
    return LashesService(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      price: json['price'].toString(),
    );
  }
}
