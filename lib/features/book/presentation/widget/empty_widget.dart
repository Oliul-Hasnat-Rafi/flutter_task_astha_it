import 'package:flutter/material.dart';

import '../../../../core/base/widgets/text.dart';
import '../../../../core/values/app_values.dart';

class EmptyView extends StatelessWidget {
  final String query;
  const EmptyView({super.key, required this.query});

  bool get _isSearching => query != 'bestseller' && query.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorstheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.padding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isSearching ? Icons.search_off_rounded : Icons.menu_book_rounded,
              size: 64,
              color: colorstheme.outlineVariant,
            ),
            const SizedBox(height: AppValues.padding),
            CustomTextBody.L(
              text: _isSearching ? 'No results found' : 'No books available',
              isBold: true,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppValues.halfPadding),
            CustomTextBody.S(
              text: _isSearching
                  ? 'No books matched "$query".\nTry a different keyword.'
                  : 'Check back later for new arrivals.',
              color: colorstheme.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}