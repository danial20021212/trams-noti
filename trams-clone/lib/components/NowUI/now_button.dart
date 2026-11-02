import 'package:flutter/material.dart';

import '../../constant/theme.dart';

class NowButton extends StatelessWidget {
  final Widget child;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color? shadowColor;
  final double width;
  final double height;
  final BorderSide? side;
  final EdgeInsets padding;
  final void Function()? onPressed;
  final MaterialStateProperty<OutlinedBorder?>? shape;

  const NowButton({
    super.key,
    required this.child,
    this.textStyle = const TextStyle(
      color: NowUIColors.white,
    ),
    this.backgroundColor = NowUIColors.primary,
    this.padding = const EdgeInsets.only(
      left: 10.0,
      right: 10.0,
      top: 12,
      bottom: 12,
    ),
    this.onPressed,
    this.shape,
    this.width = 150.0,
    this.height = 100.0,
    this.shadowColor,
    this.side,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all<Color?>(
            shadowColor,
          ),
          side: MaterialStateProperty.all<BorderSide?>(
            side,
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            padding,
          ),
          shape: shape,
          backgroundColor: MaterialStateProperty.all<Color>(
            backgroundColor,
          ),
          textStyle: MaterialStateProperty.all<TextStyle>(
            textStyle,
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
