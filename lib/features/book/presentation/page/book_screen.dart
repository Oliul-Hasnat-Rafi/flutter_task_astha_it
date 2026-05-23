import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_astha_it/core/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base/widgets/base_setting_row.dart';
import '../../../../core/base/widgets/custom_text_field_widget.dart';
import '../../../../core/values/app_values.dart';
import '../bloc/book_bloc.dart';
import '../bloc/book_event.dart';
import '../bloc/book_state.dart';
import '../widget/book_list_widget.dart';
import '../widget/error_widget.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(BookGetBooksEvent(pageSize: _pageSize));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
  if (!_scrollController.hasClients) return;
  final maxScroll = _scrollController.position.maxScrollExtent;
  final isBottom = _scrollController.offset >= maxScroll * 0.9;
  if (!isBottom) return;

  final currentState = context.read<BookBloc>().state;
  if (currentState is BookLoaded && !currentState.hasReachedMax) {
    context.read<BookBloc>().add(BookLoadMoreBooksEvent(pageSize: _pageSize));
  }
}
  Future<void> _onSearchChanged(String value) async {
    context.read<BookBloc>().add(
          BookSearchBooksEvent(query: value, pageSize: _pageSize),
        );
  }

  void _navigateToDetail(BookLoaded state, String bookId) {
    final book = state.books.firstWhere(
      (b) => b.id == bookId,
      orElse: () => state.books.first,
    );
    context.pushNamed(Routes.bookDetails, extra: book);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookBloc, BookState>(
      listenWhen: (_, current) =>
          current is BookLoaded && current.navigateToBookId != null,
      listener: (context, state) {
        if (state is BookLoaded && state.navigateToBookId != null) {
          _navigateToDetail(state, state.navigateToBookId!);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Books'), elevation: 0, actions: const [
           ChangeSetting(),
        ],),
        body: Padding(
          padding: const EdgeInsets.all(AppValues.padding / 2),
          child: Column(
            spacing: AppValues.padding / 2,
            children: [
              _buildSearchBar(),
              Expanded(child: _buildBookList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return CustomTextFormField(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: AppValues.padding / 4,
      ),
      labelText: 'Search books...',
      textEditingController: _searchController,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: _searchController.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            )
          : null,
      onChangedProcessing: (_) => _onSearchChanged(_searchController.text),
    );
  }

  Widget _buildBookList() {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) => switch (state) {
        BookLoading() => const Center(child: CircularProgressIndicator()),
        BookLoaded() => _LoadedView(
            state: state,
            scrollController: _scrollController,
            pageSize: _pageSize,
          ),
          
        BookLoadingMore() => _LoadingMoreView(
            state: state,
            scrollController: _scrollController,
          ),
        BookError() => ErrorView(state: state, pageSize: _pageSize),
        _ => const SizedBox.shrink(),
      },
    );
  }
}


class _LoadedView extends StatelessWidget {
  final BookLoaded state;
  final ScrollController scrollController;
  final int pageSize;

  const _LoadedView({
    required this.state,
    required this.scrollController,
    required this.pageSize,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<BookBloc>().add(BookRefreshBooksEvent(pageSize: pageSize)),
      child: BooksGrid(books: state.books, scrollController: scrollController, currentQuery: state.currentQuery),
    );
  }
}

class _LoadingMoreView extends StatelessWidget {
  final BookLoadingMore state;
  final ScrollController scrollController;

  const _LoadingMoreView({
    required this.state,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BooksGrid(books: state.books, scrollController: scrollController, currentQuery: state.currentQuery),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
            child: const Padding(
              padding: EdgeInsets.all(AppValues.halfPadding),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ],
    );
  }
}


