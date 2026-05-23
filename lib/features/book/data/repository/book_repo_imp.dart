import 'package:dartz/dartz.dart';
import '../../../../core/utils/logger.dart';
import '../../data/model/res_model/book_model.dart';
import '../../domain/entities/book_list_entity.dart';
import '../../domain/repositories/book_repositories.dart';
import '../datasource/book_datasource.dart';

class BookRepoImp implements BookRepository {
  BookDatasource bookDatasource;
  BookRepoImp({required this.bookDatasource});

  @override
  Future<Either<String, BookListEntity>> getBooks({
    required String query,
    required int pageSize,
    required int pageNumber,
  }) async {
    try {
      final response = await bookDatasource.getBooks(
        query: query,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );
      if (response.statusCode == 200) {
        return Right(BookListEntity.fromJson(response.data));
      } else {
        return Left('Error: ${response.statusCode}');
      }
    } on Exception catch (e) {
      Log.info(e.toString());
      return Left('Error: $e');
    } catch (e) {
      Log.info(e.toString());
      return Left('Error: $e');
    }
  }

  @override
  Future<Either<String, BookModel>> getBookDetail({required String bookId}) async {
    try {
      final response = await bookDatasource.getBookDetail(bookId: bookId);
      if (response.statusCode == 200) {
        return Right(BookModel.fromJson(response.data as Map<String, dynamic>));
      } else {
        return Left('Error: ${response.statusCode}');
      }
    } on Exception catch (e) {
      Log.info(e.toString());
      return Left('Error: $e');
    } catch (e) {
      Log.info(e.toString());
      return Left('Error: $e');
    }
  }
}
