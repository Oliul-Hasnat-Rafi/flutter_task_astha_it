import 'package:dartz/dartz.dart';

import '../../data/model/res_model/book_model.dart';
import '../repositories/book_repositories.dart';

class GetBookDetailUseCase {
  GetBookDetailUseCase({required this.repository});
  final BookRepository repository;

  Future<Either<String, BookModel>> getBookDetail({required String bookId}) =>
      repository.getBookDetail(bookId: bookId);
}