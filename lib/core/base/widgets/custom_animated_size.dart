import 'package:flutter/material.dart';

import '../../values/app_values.dart';

class CustomAnimatedSize extends StatelessWidget {
  const CustomAnimatedSize({super.key, this.child, this.alignment = Alignment.center, this.widthFactor, this.heightFactor});
  final Widget? child;
  final AlignmentGeometry alignment;
  final double? widthFactor;
  final double? heightFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: AnimatedSize(
        alignment: alignment,
        duration: const Duration(milliseconds: AppValues.defaultAnimationDuration),
        child: child ?? const SizedBox(),
      ),
    );
  }
}
