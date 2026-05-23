import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_process_button_widget/on_process_button_widget.dart';
import '../../../../../core/base/widgets/text.dart';
import '../../../data/model/res_model/book_model.dart';
import '../../bloc/book_bloc.dart';
import '../../bloc/book_event.dart';
import '../../bloc/book_state.dart';
import '../../../../../core/base/widgets/picture.dart';
import '../../../../../core/values/app_values.dart';

class BookDetailsPage extends StatefulWidget {
  final String bookId;

  const BookDetailsPage({super.key, required this.bookId});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(BookOpenDetailEvent(bookId: widget.bookId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      buildWhen: (_, current) =>
          current is BookDetailLoading ||
          current is BookDetailLoaded ||
          current is BookDetailError,
      builder: (context, state) => switch (state) {
        BookDetailLoaded() => _BookDetailView(book: state.book),
        BookDetailError() => _ErrorView(
          message: state.message,
          onRetry: () async {
            await Future.delayed(const Duration(seconds: 2));
            try {
              context.read<BookBloc>().add(
                BookOpenDetailEvent(bookId: widget.bookId),
              );
            } catch (e) {
              debugPrint(e.toString());
            }
          },
        ),
        _ => _LoadingView(),
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<bool?> Function() onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorstheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.padding * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: colorstheme.error,
              ),
              const CustomTextBody.L(
                text: 'Failed to load book',
                isBold: true,
                textAlign: TextAlign.center,
              ),
              CustomTextBody.S(
                text: message,
                color: colorstheme.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),
              OnProcessButtonWidget(
                onTap: onRetry,
                child: const Row(
                  children: [
                    Icon(Icons.refresh_rounded),
                    CustomTextBody.S(text: 'Retry'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookDetailView extends StatelessWidget {
  final BookModel book;

  const _BookDetailView({required this.book});

  String? get _publishedYear {
    if (book.publishedDate == null || book.publishedDate!.isEmpty) return null;
    return book.publishedDate!.split('-').first;
  }

  bool get _hasDescription => book.description.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextBody.L(text: book.title, maxLine: 1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppValues.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppValues.halfPadding / 2,
          children: [
            _Cover(imageUrl: book.image, heroTag: book.image),
            _TitleSection(
              title: book.title,
              authors: book.authors,
              publishedYear: _publishedYear,
            ),
            const _Divider(),
            _DescriptionSection(
              description: _hasDescription ? book.description : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const _Cover({required this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorstheme = Theme.of(context).colorScheme;
    return Hero(
      tag: heroTag,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppValues.radius),
        child: AspectRatio(
          aspectRatio: 3 / 2,
          child: PictureFromLink(
            imageLink: imageUrl,
            fit: BoxFit.cover,
            onErrorWidget: ColoredBox(
              color: colorstheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 48,
                  color: colorstheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  final String title;
  final String authors;
  final String? publishedYear;

  const _TitleSection({
    required this.title,
    required this.authors,
    this.publishedYear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppValues.halfPadding / 2,
      children: [
        CustomTextBody.L(text: title, isBold: true, maxLine: 3),
        CustomTextBody.S(
          text: authors,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        if (publishedYear != null) ...[_MetaChip(label: publishedYear!)],
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  const _MetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorstheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.halfPadding,
        vertical: AppValues.padding_4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: colorstheme.outlineVariant),
        borderRadius: BorderRadius.circular(AppValues.radius),
      ),
      child: CustomTextBody.S(text: label, color: colorstheme.onSurfaceVariant),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppValues.padding),
      child: Divider(height: 1),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final String? description;
  const _DescriptionSection({this.description});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorstheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppValues.halfPadding / 2,
      children: [
        CustomTextBody.S(
          text: 'DESCRIPTION',
          isBold: true,
          color: colorstheme.onSurfaceVariant,
        ),
        description != null
            ? CustomTextBody.S(text: description!)
            : CustomTextBody.S(
                text: 'No description available for this book.',
                color: colorstheme.onSurfaceVariant,
              ),
      ],
    );
  }
}
