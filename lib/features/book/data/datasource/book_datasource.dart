import 'package:dio/dio.dart';

abstract class BookDatasource {
  Future<Response> getBooks({
    required String query,
    required int pageSize,
    required int pageNumber,
  });

  Future<Response> getBookDetail({required String bookId});
}
