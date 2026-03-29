import 'package:flutter/material.dart';
import 'package:lighthouse/themes.dart';

class DefaultContainer extends StatelessWidget {
  final Color? color;
  final double? margin;
  final Widget? child;
  final bool expandHorizontal;
  final bool expandVertical;

  const DefaultContainer({
    super.key,
    this.color,
    this.margin,
    this.child,
    this.expandHorizontal = false,
    this.expandVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: expandVertical ? double.infinity : null,
      width: expandHorizontal ? double.infinity : null,
      padding: EdgeInsets.all(margin ?? 10),
      decoration: BoxDecoration(
        color: color ?? context.colors.container,
        borderRadius: BorderRadius.circular(margin ?? 10),
      ),
      child: child,
    );
  }
}
