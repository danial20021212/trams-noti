import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final Color color;
  final IconData icon;
  final EdgeInsets padding;
  final double width;
  final double height;
  const CircleIcon({
    super.key,
    this.width = 40,
    this.height = 100,
    this.padding = EdgeInsets.zero,
    this.color = Colors.orange,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Container(
        padding: const EdgeInsets.all(5),
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color),
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}
