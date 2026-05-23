abstract class BookEvent {}

class BookGetBooksEvent extends BookEvent {
  final int pageSize;
  BookGetBooksEvent({required this.pageSize});
}

class BookSearchBooksEvent extends BookEvent {
  final String query;
  final int pageSize;
  BookSearchBooksEvent({required this.query, required this.pageSize});
}

class BookLoadMoreBooksEvent extends BookEvent {
  final int pageSize;
  BookLoadMoreBooksEvent({required this.pageSize});
}

class BookRefreshBooksEvent extends BookEvent {
  final int pageSize;
  BookRefreshBooksEvent({required this.pageSize});
}

class BookOpenDetailEvent extends BookEvent { 
  final String bookId;
  BookOpenDetailEvent({required this.bookId});
}

