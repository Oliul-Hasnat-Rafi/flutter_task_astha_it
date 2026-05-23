import 'package:dartz/dartz.dart';
import '../../data/model/res_model/book_model.dart';
import '../entities/book_list_entity.dart';

abstract class BookRepository {
  Future<Either<String, BookListEntity>> getBooks({
    required String query,
    required int pageSize,
    required int pageNumber,
  });

  Future<Either<String, BookModel>> getBookDetail({required String bookId});
}
