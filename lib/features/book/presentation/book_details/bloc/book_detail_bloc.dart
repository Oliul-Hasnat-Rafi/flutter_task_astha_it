import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/book_detail_use_case.dart';
import 'book_detail_event.dart';
import 'book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  BookDetailBloc({required this.getBookDetailUseCase})
      : super(BookDetailInitial()) {
    on<BookDetailFetchEvent>(_onFetch);
  }

  final GetBookDetailUseCase getBookDetailUseCase;

  Future<void> _onFetch(
    BookDetailFetchEvent event,
    Emitter<BookDetailState> emit,
  ) async {
    emit(BookDetailLoading());
    final result =
        await getBookDetailUseCase.getBookDetail(bookId: event.bookId);
    result.fold(
      (error) => emit(BookDetailError(message: error)),
      (book) => emit(BookDetailLoaded(book: book)),
    );
  }
}
