import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CustomNeumorphicBackground extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color backendColor;
  final Color? color;
  final BorderRadius? borderRadius;

  const CustomNeumorphicBackground({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.backendColor = const Color(0xFF000000),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: margin,
      color: backendColor,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(0),
        child: AnimatedContainer(
          color: color ?? NeumorphicTheme.baseColor(context),
          padding: padding,
          duration: const Duration(milliseconds: 100),
          child: child,
        ),
      ),
    );
  }
}
