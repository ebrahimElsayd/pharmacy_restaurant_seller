class ProductModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final String category;
  final double amount;
  final double discountAmount;
  final String status;
  final int views;
  final int likes;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    required this.amount,
    required this.discountAmount,
    required this.status,
    required this.views,
    required this.likes,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],  // أضف هذا السطر
      title: map['title'],
      description: map['description'],
      image: map['image'],
      category: map['category'],
      amount: (map['amount'] as num).toDouble(),
      discountAmount: (map['discount_amount'] as num).toDouble(),
      status: map['status'],
      views: map['views'] ?? 0,
      likes: map['likes'] ?? 0,
    );
  }
}
