class Offer {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final bool active;
  final int order;
  final String type; // "generic" | "discount" | "date"
  final int? discount;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.active,
    required this.order,
    required this.type,
    this.discount,
    this.startsAt,
    this.endsAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] ?? json['_id'],
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
      active: json['active'] ?? false,
      order: json['order'] ?? 0,
      type: json['type'] ?? "generic",
      discount: json['discount'],
      startsAt: json['startsAt'] != null ? DateTime.parse(json['startsAt']) : null,
      endsAt: json['endsAt'] != null ? DateTime.parse(json['endsAt']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "imageUrl": imageUrl,
      "active": active,
      "order": order,
      "type": type,
      "discount": discount,
      "startsAt": startsAt?.toIso8601String(),
      "endsAt": endsAt?.toIso8601String(),
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}
