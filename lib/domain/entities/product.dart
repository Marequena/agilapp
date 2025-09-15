class Product {
  final String id;
  final String? sku;
  final String? name;
  final String? description;
  final String? categoryId;
  final String? price;
  final String? stock;
  final List<dynamic>? prices;
  final String? image;

  Product({required this.id, this.sku, this.name, this.description, this.categoryId, this.price, this.stock, this.prices, this.image});

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
  // prefer 'quantity' if present for stock
  stock: (json['quantity'] ?? json['stock'])?.toString(),
  prices: (json['prices'] as List?)?.map((e) => e).toList(),
  image: json['image']?.toString() ?? json['image_url']?.toString(),
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
    if (prices != null) 'prices': prices,
    if (image != null) 'image': image,
    };
  }
}
