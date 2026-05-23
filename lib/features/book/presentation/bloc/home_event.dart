abstract class BookEvent {}

class BookGetBooksEvent extends BookEvent {
  BookGetBooksEvent({
    this.pageSize = 10,
  });

  final int pageSize;
}

class BookSearchBooksEvent extends BookEvent {
  BookSearchBooksEvent({
    required this.query,
    this.pageSize = 10,
  });

  final String query;
  final int pageSize;
}

class BookLoadMoreBooksEvent extends BookEvent {
  BookLoadMoreBooksEvent({
    this.pageSize = 10,
  });

  final int pageSize;
}

class BookRefreshBooksEvent extends BookEvent {
  BookRefreshBooksEvent({
    this.pageSize = 10,
  });

  final int pageSize;
}