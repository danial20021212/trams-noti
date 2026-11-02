import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../custom_tile.dart';

class NeumorphicCard2 extends StatelessWidget {
  const NeumorphicCard2({
    super.key,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.cardColor = const Color(0xffd6e3f4),
    this.onPressed,
    this.title = "",
    this.subtitle = "",
    this.leading,
    this.trailing,
    this.titleStyle = const TextStyle(
      fontSize: 18,
      color: Color.fromARGB(255, 68, 65, 118),
      fontWeight: FontWeight.bold,
    ),
    this.subtitleStyle = const TextStyle(
      fontSize: 15,
      color: Color.fromARGB(255, 64, 64, 95),
      fontWeight: FontWeight.w400,
    ),
  });

  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color cardColor;
  final void Function()? onPressed;

  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: padding,
      margin: margin,
      style: NeumorphicStyle(
        depth: 3,
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
        intensity: 0.8,
        color: cardColor,
      ),
      minDistance: -3,
      onPressed: onPressed,
      child: CustomTile(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 0,
          right: 20,
        ),
        leading: leading,
        title: _title(title),
        subtitle: _subtitle(subtitle),
        trailing: trailing ?? _viewIcon(),
      ),
    );
  }

  Widget _title(String title) {
    return Text(
      title,
      style: titleStyle,
    );
  }

  Widget _subtitle(String title) {
    return Text(
      title,
      style: subtitleStyle,
    );
  }
}

Widget _viewIcon() {
  return Icon(
    Icons.arrow_forward_ios,
    color: Color.fromARGB(255, 147, 147, 147),
    size: 25,
  );
}
