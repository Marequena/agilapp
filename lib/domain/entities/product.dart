class Product {
  final String id;
  final String? sku;
  final String? name;
  final String? description;
  final String? categoryId;
  final String? price;
  final String? stock;

  Product({required this.id, this.sku, this.name, this.description, this.categoryId, this.price, this.stock});

  factory Product.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Product(id: '');
    String? parseCategory(dynamic v) {
      if (v == null) return null;
      return v.toString();
    }

    return Product(
      id: json['id']?.toString() ?? '',
      sku: json['sku']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      categoryId: parseCategory(json['category_id'] ?? json['categoryId'] ?? json['category']),
      price: json['price']?.toString(),
      stock: json['stock']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (sku != null) 'sku': sku,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (categoryId != null) 'category_id': categoryId,
      if (price != null) 'price': price,
      if (stock != null) 'stock': stock,
    };
  }
}
