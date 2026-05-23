import 'package:flutter/material.dart';
import '../../../../core/base/widgets/picture.dart';
import '../../../../core/base/widgets/text.dart';
import '../../../../core/values/app_values.dart';
import '../widget/card.dart';

class BookCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final Future<bool?>? Function()? onTap;
  final String? heroTag;

  const BookCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorstheme = Theme.of(context).colorScheme;
    return CustomCard(
      
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
     //    mainAxisSize: MainAxisSize.min,
        children: [
          _Cover(
            imageUrl: imageUrl,
            heroTag: heroTag,
            colorScheme: colorstheme,
          ),
          _Info(title: title, author: subtitle, colorScheme: colorstheme),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;
  final ColorScheme colorScheme;

  const _Cover({
    required this.imageUrl,
    required this.colorScheme,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3/3.5,
      child: Hero(
        tag: heroTag ?? imageUrl,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppValues.radius),
          ),
          child: PictureFromLink(
            imageLink: imageUrl,
            fit: BoxFit.cover,
            onErrorWidget: ColoredBox(
              color: colorScheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 36,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String title;
  final String author;
  final ColorScheme colorScheme;

  const _Info({
    required this.title,
    required this.author,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppValues.halfPadding),
       
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: AppValues.padding_3,
        children: [
          CustomTextBody.S(text: title, isBold: true, maxLine: 2),
      
          CustomTextBody.S(
            text: author,
            maxLine: 1,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}