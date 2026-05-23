abstract class BookDetailEvent {}

class BookDetailFetchEvent extends BookDetailEvent {
  final String bookId;
  BookDetailFetchEvent({required this.bookId});
}
