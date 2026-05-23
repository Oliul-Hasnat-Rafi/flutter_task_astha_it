import '../../../data/model/res_model/book_model.dart';

abstract class BookDetailState {}

class BookDetailInitial extends BookDetailState {}

class BookDetailLoading extends BookDetailState {}

class BookDetailLoaded extends BookDetailState {
  final BookModel book;
  BookDetailLoaded({required this.book});
}

class BookDetailError extends BookDetailState {
  final String message;
  BookDetailError({required this.message});
}
