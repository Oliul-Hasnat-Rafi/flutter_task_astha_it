import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_astha_it/core/base/widgets/size_builder.dart';
import 'package:flutter_task_astha_it/core/values/app_values.dart';

class PictureFromLink extends StatelessWidget {
  const PictureFromLink({
    super.key,
    required this.imageLink,
    this.placeholderIcon = Icons.no_photography,
    this.fit = BoxFit.cover,
    this.padding,
    this.onErrorWidget,
    this.scale = 1,
  });

  final String? imageLink;
  final IconData placeholderIcon;
  final BoxFit fit;
  final EdgeInsetsGeometry? padding;
  final Widget? onErrorWidget;
  final double scale;

  Widget _errorWidget(BuildContext context) {
    return onErrorWidget ??
        CustomSizeBuilder(
          child: Icon(
            placeholderIcon,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (imageLink == null || imageLink!.trim().isEmpty) {
      return _errorWidget(context);
    }

    Widget image = CachedNetworkImage(
      imageUrl: imageLink!,
      fit: fit,
  width: double.infinity, 
  height: double.infinity,  
  
      memCacheWidth: 800,
  
      placeholder: (context, url) {
        return LinearProgressIndicator(
          color: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.2),
        );
      },
      errorWidget: (context, url, error) => _errorWidget(context),
    );

    if (padding != null) {
      image = Padding(
        padding: padding!,
        child: image,
      );
    }

    return image;
  }
}