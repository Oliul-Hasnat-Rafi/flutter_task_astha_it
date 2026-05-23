import 'package:flutter/material.dart';

import '../../values/app_values.dart';

/// A custom widget that provides flexible sizing and alignment capabilities
/// for its child widget.
///
/// The [CustomSizeBuilder] uses [LayoutBuilder] to adapt to available space
/// and applies custom constraints while maintaining the child's aspect ratio
/// through [FittedBox]. It's particularly useful when you need to control
/// the maximum size of a widget while keeping it centered or aligned
/// within the available space.
///
/// Example usage:
/// ```dart
/// CustomSizeBuilder(
///   maxSize: 100.0,
///   alignment: Alignment.topLeft,
///   child: Icon(Icons.star),
/// )
/// ```
class CustomSizeBuilder extends StatelessWidget {
  /// Creates a [CustomSizeBuilder].
  ///
  /// The [child] parameter is required and represents the widget to be
  /// sized and aligned.
  ///
  /// [constraints] - Custom box constraints to apply to the child. If null,
  /// default constraints using [maxSize] or [defaultPadding] will be used.
  ///
  /// [alignment] - How to align the child within the available space.
  /// Defaults to [Alignment.center].
  ///
  /// [maxSize] - The maximum width and height for the child widget.
  /// If null, [defaultPadding] will be used as the maximum size.
  /// This parameter is ignored if [constraints] is provided.
  const CustomSizeBuilder({
    super.key,
    required this.child,
    this.constraints,
    this.alignment = Alignment.center,
    this.maxSize,
  });

  /// The widget to be sized and aligned within this container.
  ///
  /// This child will be wrapped in a [FittedBox] to maintain its aspect
  /// ratio while fitting within the specified constraints.
  final Widget child;

  /// Custom box constraints to apply to the child widget.
  ///
  /// If provided, this takes precedence over [maxSize]. If null,
  /// constraints will be generated using [maxSize] or [defaultPadding]
  /// as both maximum width and height.
  final BoxConstraints? constraints;

  /// How to align the child widget within the available space.
  ///
  /// Defaults to [Alignment.center]. This determines the positioning
  /// of the constrained child within the container that fills the
  /// available layout space.
  final AlignmentGeometry? alignment;

  /// The maximum size (width and height) for the child widget.
  ///
  /// This value is used to create square constraints where both
  /// maxWidth and maxHeight are set to this value. If null,
  /// [defaultPadding] will be used instead.
  ///
  /// This parameter is ignored if [constraints] is explicitly provided.
  final double? maxSize;

  /// Builds the custom size builder widget.
  ///
  /// Creates a responsive layout that:
  /// 1. Uses [LayoutBuilder] to get available space constraints
  /// 2. Creates an outer container that fills available space with specified
  /// 3. Creates an inner container with custom constraints
  /// 4. Wraps the child in [FittedBox] to maintain aspect ratio
  ///
  /// The widget adapts to the parent's constraints while ensuring the child
  /// respects the maximum size limitations and maintains proper alignment.
  ///
  /// Returns a [Widget] tree starting with [LayoutBuilder].
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) => Container(
        alignment: alignment,
        child: Container(
          height: box.maxHeight,
          width: box.maxWidth,
          constraints: constraints ??
              BoxConstraints(
                maxHeight: maxSize ?? AppValues.padding_4*3,
                maxWidth: maxSize ?? AppValues.padding_4*3,
              ),
          child: FittedBox(child: child),
        ),
      ),
    );
  }
}
