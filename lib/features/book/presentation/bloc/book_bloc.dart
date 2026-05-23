import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/values/app_values.dart';
import '../../domain/use_cases/book_use_case.dart';
import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc({required this.bookUseCase}) : super(BookInitial()) {
    on<BookGetBooksEvent>(_onGetBooks);
    on<BookSearchBooksEvent>(_onSearchBooks, transformer: _debounce());
    on<BookLoadMoreBooksEvent>(_onLoadMoreBooks, transformer: droppable());
    on<BookRefreshBooksEvent>(_onRefreshBooks);
    on<BookOpenDetailEvent>(_onOpenDetail);
  }

  final BookUseCase bookUseCase;
  static const String _defaultQuery = 'bestseller';

  EventTransformer<T> _debounce<T>() {
    return (events, mapper) => events
        .debounceTime(const Duration(milliseconds: AppValues.defaultAnimationDuration))
        .switchMap(mapper);
  }

  bool _hasReachedMax(int fetchedCount, int pageSize) =>
      fetchedCount < pageSize;

  Future<void> _onGetBooks(
    BookGetBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());
    final result = await bookUseCase.getBooks(
      query: _defaultQuery,
      pageSize: event.pageSize,
      pageNumber: 0,
    );
    result.fold(
      (error) => emit(BookError(message: error)),
      (books) => emit(BookLoaded(
        books: books.products,
        currentPage: 0,
        hasReachedMax: _hasReachedMax(books.products.length, event.pageSize),
        currentQuery: _defaultQuery,
      )),
    );
  }

  Future<void> _onSearchBooks(
    BookSearchBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(BookGetBooksEvent(pageSize: event.pageSize));
      return;
    }
    emit(BookLoading());
    final result = await bookUseCase.getBooks(
      query: event.query,
      pageSize: event.pageSize,
      pageNumber: 0,
    );
    result.fold(
      (error) => emit(BookError(message: error)),
      (books) => emit(BookLoaded(
        books: books.products,
        currentPage: 0,
        hasReachedMax: _hasReachedMax(books.products.length, event.pageSize),
        currentQuery: event.query,
      )),
    );
  }

Future<void> _onLoadMoreBooks(
  BookLoadMoreBooksEvent event,
  Emitter<BookState> emit,
) async {
  final currentState = state;
  if (currentState is! BookLoaded || currentState.hasReachedMax) return;

  emit(BookLoadingMore(
    books: currentState.books,
    currentQuery: currentState.currentQuery,
  ));

  final nextPage = currentState.currentPage + 1;
  final result = await bookUseCase.getBooks(
    query: currentState.currentQuery,
    pageSize: event.pageSize,
    pageNumber: nextPage,
  );

  result.fold(
    (error) => emit(BookError(message: error)),
    (newBooks) {
      final existingIds = currentState.books.map((b) => b.id).toSet();
      final uniqueNew = newBooks.products
          .where((b) => !existingIds.contains(b.id))
          .toList();

      emit(BookLoaded(
        books: [...currentState.books, ...uniqueNew],
        currentPage: nextPage,
        hasReachedMax: _hasReachedMax(newBooks.products.length, event.pageSize),
        currentQuery: currentState.currentQuery,
      ));
    },
  );
}

  Future<void> _onRefreshBooks(
    BookRefreshBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    final currentQuery = state is BookLoaded
        ? (state as BookLoaded).currentQuery
        : _defaultQuery;

    final result = await bookUseCase.getBooks(
      query: currentQuery,
      pageSize: event.pageSize,
      pageNumber: 0,
    );
    result.fold(
      (error) => emit(BookError(message: error)),
      (books) => emit(BookLoaded(
        books: books.products,
        currentPage: 0,
        hasReachedMax: _hasReachedMax(books.products.length, event.pageSize),
        currentQuery: currentQuery,
      )),
    );
  }

  Future<void> _onOpenDetail(
    BookOpenDetailEvent event,
    Emitter<BookState> emit,
  ) async {
    /// get single book details 
     final result = await bookUseCase.getBookDetail(bookId: event.bookId);
      result.fold(
        (error) => emit(BookError(message: error)),
        (bookDetail) => emit(BookDetailLoaded(bookDetail: bookDetail)),
      );
  }


 
}