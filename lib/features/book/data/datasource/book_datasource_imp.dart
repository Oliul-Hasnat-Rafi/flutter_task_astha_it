import 'package:dio/dio.dart';
import 'package:flutter_task_astha_it/features/book/data/datasource/book_datasource.dart';
import '../../../../core/network/api_end_points.dart' show ApiEndPoints;
import '../../../../core/network/rest_client.dart';
import '../../../../flavors/build_config.dart';

class BookDatasourceImp implements BookDatasource {
  const BookDatasourceImp({
    required this.restClient,
  });

  final RestClient restClient;

  @override
  Future<Response> getBooks({
    required String query,
    required int pageSize,
    required int pageNumber,
    
  }) async {
    final apiKey = BuildConfig.instance.config.googleBooksApiKey;
    
    final searchQuery = query.isEmpty ? 'bestseller' : query;
  
    final startIndex = pageNumber * pageSize;

    final Map<String, dynamic> queryParams = {
      'q': searchQuery,
      'startIndex': startIndex,
      'maxResults': pageSize,
      'key': apiKey,
    };

   

    final response = await restClient.get(
      APIType.PUBLIC,
      ApiEndPoints.booklist,
      data: queryParams,
    );

    return response;
  }

  @override
  Future<Response> getBookDetail({
    required int bookId,
  }) async {
    final apiKey = BuildConfig.instance.config.googleBooksApiKey;
    
    final response = await restClient.get(
      APIType.PUBLIC,
      '${ApiEndPoints.booklist}/$bookId',
      data: {'key': apiKey},
    );

    return response;
  }
}
