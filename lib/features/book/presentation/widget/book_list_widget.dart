
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_astha_it/features/book/presentation/widget/book_card_widget.dart';
import 'package:flutter_task_astha_it/features/book/presentation/widget/empty_widget.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/values/app_values.dart';
import '../bloc/book_bloc.dart';
import '../bloc/book_event.dart';

class BooksGrid extends StatelessWidget {
  final List<dynamic> books;
  final ScrollController scrollController;
    final String currentQuery; 


  const BooksGrid({required this.books, required this.scrollController ,required this.currentQuery});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return EmptyView(query: currentQuery);
    }

    return GridView.builder(
      controller: scrollController,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppValues.halfPadding,
        mainAxisSpacing: AppValues.halfPadding,
        childAspectRatio: 0.57,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookCardWidget(
          key: ValueKey(book.id),
          imageUrl: book.image,
          title: book.title,
          subtitle: book.authors,
          onTap: () async {
            context
                .read<BookBloc>()
                .add(BookOpenDetailEvent(bookId: book.id));
            context.goNamed(
              Routes.bookDetails,
              pathParameters: {'bookId': book.id.toString()},
              extra: book,
            );
          },
        );
      },
    );
  }
}