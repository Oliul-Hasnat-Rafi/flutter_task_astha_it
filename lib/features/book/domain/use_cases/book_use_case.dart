import 'package:dartz/dartz.dart';
import '../entities/book_list_entity.dart';
import '../repositories/book_repositories.dart';

class BookUseCase {
  BookRepository bookRepository;
  BookUseCase({required this.bookRepository});

  Future<Either<String, BookListEntity>> getBooks({
    required String query,
    required int pageSize,
    required int pageNumber,
    
  }) async {
    return await bookRepository.getBooks(
      query: query,
      pageSize: pageSize,
      pageNumber: pageNumber,
      
    );
  }

  Future<dynamic> getBookDetail({required int bookId}) async {
    return await bookRepository.getBookDetail(bookId: bookId);
  }
}
