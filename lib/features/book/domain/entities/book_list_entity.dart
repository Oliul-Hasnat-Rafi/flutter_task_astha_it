import '../../data/model/res_model/book_model.dart';
class BookListEntity {
  final List<BookModel> products;

  BookListEntity({
    required this.products,
  });

  factory BookListEntity.fromJson(Map<String, dynamic> json) {
    // Handle both Google Books API response (items) and custom format (products)
    final items = json['items'] as List<dynamic>? ?? json['products'] as List<dynamic>? ?? [];
    return BookListEntity(
      products: items
          .map((item) => BookModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}