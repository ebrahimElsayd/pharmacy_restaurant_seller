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
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      category: map['category'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (map['discount_amount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'Available',
      views: map['views'] ?? 0,
      likes: map['likes'] ?? 0,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'category': category,
      'amount': amount,
      'discount_amount': discountAmount,
      'status': status,
      'views': views,
      'likes': likes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
