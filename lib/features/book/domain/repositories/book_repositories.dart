import 'package:dartz/dartz.dart';
import '../entities/book_list_entity.dart';

abstract class BookRepository {
  Future<
    Either<
      String,
      BookListEntity
    >
  >
  getBooks({
    required String query,
    required int pageSize,
    required int pageNumber,
    String? sortBy,
    String? order,
  });

  Future<dynamic> getBookDetail({required int bookId});
}
