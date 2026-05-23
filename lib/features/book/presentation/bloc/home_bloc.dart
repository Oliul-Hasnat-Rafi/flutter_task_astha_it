import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/book_use_case.dart';
import 'home_event.dart';
import 'home_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc({
    required this.bookUseCase,
  }) : super(BookInitial()) {
    on<BookGetBooksEvent>(_onGetBooks);
    on<BookSearchBooksEvent>(_onSearchBooks);
    on<BookLoadMoreBooksEvent>(_onLoadMoreBooks);
    on<BookRefreshBooksEvent>(_onRefreshBooks);
  }

  final BookUseCase bookUseCase;

  bool _hasReachedMax(int fetchedCount, int pageSize) {
    return fetchedCount < pageSize;
  }

  Future<void> _onGetBooks(
    BookGetBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());

    final result = await bookUseCase.getBooks(
      query: 'bestseller',
      pageSize: event.pageSize,
      pageNumber: 0,
    );

    result.fold(
      (error) => emit(
        BookError(message: error),
      ),
      (books) {
        emit(
          BookLoaded(
            books: books.products,
            currentPage: 0,
            hasReachedMax: _hasReachedMax(
              books.products.length,
              event.pageSize,
            ),
            currentQuery: 'bestseller',
          ),
        );
      },
    );
  }

  Future<void> _onSearchBooks(
    BookSearchBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());

    final result = await bookUseCase.getBooks(
      query: event.query,
      pageSize: event.pageSize,
      pageNumber: 0,
    );

    result.fold(
      (error) => emit(
        BookError(message: error),
      ),
      (books) {
        emit(
          BookLoaded(
            books: books.products,
            currentPage: 0,
            hasReachedMax: _hasReachedMax(
              books.products.length,
              event.pageSize,
            ),
            currentQuery: event.query,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMoreBooks(
    BookLoadMoreBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    final currentState = state;

    if (currentState is! BookLoaded ||
        currentState.hasReachedMax) {
      return;
    }

    emit(
      BookLoadingMore(
        books: currentState.books,
        currentQuery: currentState.currentQuery,
      ),
    );

    final nextPage = currentState.currentPage + 1;

    final result = await bookUseCase.getBooks(
      query: currentState.currentQuery,
      pageSize: event.pageSize,
      pageNumber: nextPage,
    );

    result.fold(
      (error) => emit(
        BookError(message: error),
      ),
      (newBooks) {
        final allBooks = [
          ...currentState.books,
          ...newBooks.products,
        ];

        emit(
          BookLoaded(
            books: allBooks,
            currentPage: nextPage,
            hasReachedMax: _hasReachedMax(
              newBooks.products.length,
              event.pageSize,
            ),
            currentQuery: currentState.currentQuery,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshBooks(
    BookRefreshBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    final currentState = state;
    final currentQuery = currentState is BookLoaded
        ? currentState.currentQuery
        : 'bestseller';

    final result = await bookUseCase.getBooks(
      query: currentQuery,
      pageSize: event.pageSize,
      pageNumber: 0,
    );

    result.fold(
      (error) => emit(
        BookError(message: error),
      ),
      (books) {
        emit(
          BookLoaded(
            books: books.products,
            currentPage: 0,
            hasReachedMax: _hasReachedMax(
              books.products.length,
              event.pageSize,
            ),
            currentQuery: currentQuery,
          ),
        );
      },
    );
  }
}