import 'package:flutter/material.dart';
import 'package:flutter_task_astha_it/features/book/presentation/widget/card.dart';
import '../../../../core/base/widgets/picture.dart';
import '../../../../core/theme/color.schema.dart';
import '../../../../core/values/app_values.dart';

class ProductCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final Future<bool?>? Function()? onTap;
  final String? heroTag;

  const ProductCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(colorScheme),
          _buildInfoSection(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildImageSection(ColorScheme colorScheme) {
    return Hero(
      tag: heroTag ?? imageUrl,
      child: PictureFromLink(
        imageLink: imageUrl,
        fit: BoxFit.cover,
        onErrorWidget: Container(
          color: colorScheme.surfaceVariant.withValues(alpha: 0.5),
          child: const Icon(Icons.broken_image, size: 40),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing:  AppValues.padding_4,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
       
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
