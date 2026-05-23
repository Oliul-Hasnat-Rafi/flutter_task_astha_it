import 'package:flutter/material.dart';
import 'package:flutter_task_astha_it/core/values/app_values.dart';
import 'package:on_process_button_widget/on_process_button_widget.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.child,
    this.onTap,
    this.alignment = Alignment.center,
    this.animationAlignment = Alignment.topCenter,
    this.onLongPress,
    this.width,
    this.margin,
    this.contentPadding,
    this.isActive = true,
    this.constraints,
    this.backgroundColor,
    this.boxShadow,
    this.onDone,
    this.fontColor,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });
  final Widget? child;
  final Future<bool?>? Function()? onTap;
  final Function()? onLongPress;
  final AlignmentGeometry alignment;
  final AlignmentGeometry animationAlignment;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;
  final bool isActive;
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final dynamic Function(bool? _)? onDone;
  final Color? fontColor;
  final BorderRadius borderRadius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.onBackground;
    return OnProcessButtonWidget(
      borderRadius: borderRadius,
      border: border,
      fontColor: c,
      boxShadow: boxShadow ?? [],
      animationAlignment: animationAlignment,
      alignment: alignment,
      expandedIcon: true,
      iconColor: c,
      roundBorderWhenRunning: false,
      enable: onTap != null || onDone != null,
      width: width,
      constraints: constraints,
      contentPadding: contentPadding ?? const EdgeInsets.all(AppValues.padding),
      backgroundColor: !isActive
          ? Colors.transparent
          : backgroundColor ?? c.withOpacity(0.05),
      margin: margin ?? const EdgeInsets.symmetric(vertical: AppValues.padding ),
      onTap: onTap,
      onDone: onDone,
      onLongPress: onLongPress,
      child: child,
    );
  }
}
