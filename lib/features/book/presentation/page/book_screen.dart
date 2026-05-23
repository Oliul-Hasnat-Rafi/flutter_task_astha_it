import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_astha_it/core/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base/widgets/custom_text_field_widget.dart';
import '../../../../core/values/app_values.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widget/product_card_widget.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final int _pageSize = 10;

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
    final currentScroll = _scrollController.offset;
    final isBottom = currentScroll >= maxScroll * 0.9;
    final currentState = context.read<BookBloc>().state;

    if (isBottom && currentState is BookLoaded && !currentState.hasReachedMax) {
      context.read<BookBloc>().add(BookLoadMoreBooksEvent(pageSize: _pageSize));
    }
  }

  Future<void> _onSearchChanged(String value) {
    return Future.delayed(const Duration(milliseconds: 500), () {
      if (value == _searchController.text) {
       if (value.isEmpty) {
      context.read<BookBloc>().add(BookGetBooksEvent(pageSize: _pageSize));
    } else {
      context.read<BookBloc>().add(
            BookSearchBooksEvent(query: value, pageSize: _pageSize),
          );
    }
      }
    });
    
  }

  Future<void> _onRefresh() async {
    context.read<BookBloc>().add(BookRefreshBooksEvent(pageSize: _pageSize));
  }

  Future<bool?> _openBookDetail(String bookId) async {
    final currentState = context.read<BookBloc>().state;
    if (currentState is BookLoaded) {
      final book = currentState.books.firstWhere(
        (b) => b.id == bookId,
        orElse: () => currentState.books.first,
      );
      context.pushNamed(Routes.bookDetails, extra: book);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        elevation: 0,
      ),
      body: Padding(
       padding: const EdgeInsets.all(AppValues.padding / 2),
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildBookList()),
          ],
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
      labelText: "Search books...",
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
      onChangedProcessing: _onSearchChanged,
    );
  }


  Widget _buildBookList() {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        return switch (state) {
          BookLoading() => const Center(child: CircularProgressIndicator()),
          BookLoaded() => _buildLoadedView(state),
          BookLoadingMore() => _buildLoadingMoreView(state),
          BookError() => _buildErrorView(state),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _buildLoadedView(BookLoaded state) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: _buildBooksGrid(state.books),
    );
  }

  Widget _buildLoadingMoreView(BookLoadingMore state) {
    return Stack(
      children: [
        _buildBooksGrid(state.books),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(AppValues.halfPadding),
            color: Colors.white.withAlpha(230),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BookError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error loading books',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppValues.halfPadding),
          Text(
            state.message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppValues.padding),
          ElevatedButton(
            onPressed: () {
              context
                  .read<BookBloc>()
                  .add(BookGetBooksEvent(pageSize: _pageSize));
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksGrid(List<dynamic> books) {
    if (books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book, size: 64, color: Colors.grey),
            const SizedBox(height: AppValues.halfPadding),
            Text(
              'No books found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding:  EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppValues.halfPadding,
        mainAxisSpacing: AppValues.halfPadding,
        childAspectRatio: 0.6,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ProductCardWidget(
          key: ValueKey(book.id),
          imageUrl: book.image,
          title: book.title,
          subtitle: book.authors,
          onTap: () => _openBookDetail(book.id),
        );
      },
    );
  }
}
