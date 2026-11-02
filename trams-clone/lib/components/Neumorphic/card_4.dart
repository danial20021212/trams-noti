import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicCard4 extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  const NeumorphicCard4(
    this.child, {
    super.key,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(15),
        ),
      ),
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: padding ??
                const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  top: 20,
                ),
            color: color,
            child: child,
          ),
        ],
      ),
    );
  }
}
