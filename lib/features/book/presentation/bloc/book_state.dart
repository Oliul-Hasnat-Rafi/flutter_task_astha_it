abstract class BookState {}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<dynamic> books;
  final int currentPage;
  final bool hasReachedMax;
  final String currentQuery;
  final String? navigateToBookId;  

  BookLoaded({
    required this.books,
    required this.currentPage,
    required this.hasReachedMax,
    required this.currentQuery,
    this.navigateToBookId,
  });

  BookLoaded copyWith({
    List<dynamic>? books,
    int? currentPage,
    bool? hasReachedMax,
    String? currentQuery,
    String? navigateToBookId,
  }) {
    return BookLoaded(
      books: books ?? this.books,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
      navigateToBookId: navigateToBookId,
    );
  }
}

class BookLoadingMore extends BookState {
  final List<dynamic> books;
  final String currentQuery;
  BookLoadingMore({required this.books, required this.currentQuery});
}

class BookError extends BookState {
  final String message;
  BookError({required this.message});
}


