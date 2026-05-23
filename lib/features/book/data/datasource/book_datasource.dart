import 'package:dio/dio.dart';

abstract class BookDatasource {
  Future<Response> getBooks({
    required String query, 
    required int pageSize, 
    required int pageNumber,
    String? sortBy,
    String? order,
  });

  Future<Response> getBookDetail({required int bookId});
}
