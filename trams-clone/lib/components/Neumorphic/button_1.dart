import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicButton1 extends StatelessWidget {
  final Widget? leading;
  final Widget? trailling;
  final Widget? title;
  final Widget? subtitle;
  final void Function()? onPressed;
  final Color? background;
  final double size;

  const NeumorphicButton1({
    super.key,
    this.leading,
    this.trailling,
    this.title,
    this.subtitle,
    this.onPressed,
    this.background,
    this.size = 4,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: onPressed,
      padding: EdgeInsets.only(
        left: 18,
        right: 9,
        top: size,
        bottom: size,
      ),
      margin: EdgeInsets.fromLTRB(
        18,
        9,
        18,
        9,
      ),
      style: NeumorphicStyle(
        color: background,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(5),
        ),
        shape: NeumorphicShape.flat,
        depth: 8,
      ),
      child: ListTile(
        minVerticalPadding: 10,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 0,
        ),
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailling,
      ),
    );
  }
}
