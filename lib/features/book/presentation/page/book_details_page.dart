import 'package:flutter/material.dart';
import '../../data/model/res_model/book_model.dart';
import '../../../../core/values/app_values.dart';

class BookDetailsPage extends StatelessWidget {
  final BookModel book;

  BookDetailsPage({
    super.key,
    required this.book,
  });

  String? _getPublishedYear() {
    if (book.publishedDate == null || book.publishedDate!.isEmpty) {
      return null;
    }
    final parts = book.publishedDate!.split('-');
    return parts.isNotEmpty ? parts[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    final publishedYear = _getPublishedYear();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: _buildContent(context, publishedYear),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        background: Hero(
          tag: 'book-image-${book.id}',
          child: _buildBookImage(context),
        ),
      ),
    );
  }

  Widget _buildBookImage(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          book.image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withAlpha(179),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, String? publishedYear) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppValues.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                book.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppValues.halfPadding),

              // Authors
              Text(
                'by ${book.authors}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppValues.halfPadding),

              // Published Year
              if (publishedYear != null)
                Text(
                  'Published: $publishedYear',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

              const SizedBox(height: AppValues.padding),
              const Divider(),
              const SizedBox(height: AppValues.padding),

              // Description Section
              Text(
                'Description',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppValues.halfPadding),
              Text(
                book.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
