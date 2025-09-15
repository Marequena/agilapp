class Sale {
  final String? id;
  final Map<String, dynamic> raw;

  Sale({this.id, required this.raw});

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(id: json['id']?.toString(), raw: json);
  }

  Map<String, dynamic> toJson() => raw;
}
