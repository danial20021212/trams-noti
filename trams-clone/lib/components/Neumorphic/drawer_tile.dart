import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicDrawerTile extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isSelected;
  // final Color iconColor;
  final bool pressed;
  final Color background;

  const NeumorphicDrawerTile({
    super.key,
    this.title,
    this.icon,
    this.onTap,
    this.isSelected = false,
    this.background = Colors.blue,
    // this.iconColor = NowUIColors.text,
    this.pressed = false,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: onTap,
      pressed: pressed,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(16),
      minDistance: -3,
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(54),
        ),
        depth: 3,
        shape: pressed ? NeumorphicShape.concave : NeumorphicShape.convex,
        color: isSelected ? Colors.white : background,
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 18,
              color: isSelected
                  ? Colors.blue
                  : Colors.white.withOpacity(0.6)),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title!,
              style: TextStyle(
                letterSpacing: .3,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? Colors.blue
                    : Colors.white.withOpacity(0.8),
              ),
            ),
          )
        ],
      ),
    );
  }
}
