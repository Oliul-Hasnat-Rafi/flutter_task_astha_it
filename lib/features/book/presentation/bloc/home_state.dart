import '../../data/model/res_model/book_model.dart';

abstract class BookState {}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  BookLoaded({
    required this.books,
    required this.currentPage,
    required this.hasReachedMax,
    this.currentQuery = 'bestseller',
  });

  final List<BookModel> books;
  final int currentPage;
  final bool hasReachedMax;
  final String currentQuery;
}

class BookLoadingMore extends BookState {
  BookLoadingMore({
    required this.books,
    this.currentQuery = 'bestseller',
  });

  final List<BookModel> books;
  final String currentQuery;
}

class BookError extends BookState {
  BookError({
    required this.message,
  });

  final String message;
}