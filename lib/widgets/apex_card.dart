import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';

class ApexCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  final BorderRadius? radius;
  final bool isHighlighted;

  const ApexCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.radius,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = radius ?? BorderRadius.circular(16);
    final backgroundColor = color ?? AppColors.surfaceVariant;

    Widget card = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: isHighlighted
            ? const Border(
                left: BorderSide(color: AppColors.accentGold, width: 3),
              )
            : Border.all(color: AppColors.surfaceBright, width: 0.5),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: card,
        ),
      );
    }

    return card;
  }
}
