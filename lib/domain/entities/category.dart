class Category {
  final String id;
  final String? name;
  final String? color; // hex without #, e.g. 'FF0000'
  final String? type;

  Category({required this.id, this.name, this.color, this.type});

  factory Category.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Category(id: '');
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString(),
      color: json['color']?.toString(),
      type: json['type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (type != null) 'type': type,
    };
  }
}
