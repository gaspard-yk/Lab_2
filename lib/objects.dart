class Product {
  final String foodId;
  final String label;
  final String knownAs;
  final Map<String, double> nutrients;
  final String category;
  final String categoryLabel;
  final String image;

  Product({
    required this.foodId,
    required this.label,
    required this.knownAs,
    required this.nutrients,
    required this.category,
    required this.categoryLabel,
    required this.image,
  });

  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      foodId: json['foodId'],
      label: json['label'],
      knownAs: json['knownAs'],
      nutrients: Map<String, double>.from(json['nutrients']),
      category: json['category'],
      categoryLabel: json['categoryLabel'],
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'label': label,
      'knownAs': knownAs,
      'nutrients': nutrients,
      'category': category,
      'categoryLabel': categoryLabel,
      'image': image,
    };
  }
}
