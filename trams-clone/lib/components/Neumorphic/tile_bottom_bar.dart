import 'package:badges/badges.dart' as bdg;
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'bottom_bar.dart';

class NeumorphicTileBottomBar extends StatelessWidget {
  final IconData icon;
  final NeumorphicButtonClickListener onPressed;
  final bool pressed;
  final String title;
  final String? badge;

  const NeumorphicTileBottomBar({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.pressed = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: NeumorphicBottomBar.buttonExtent,
        child: NeumorphicButton(
          onPressed: pressed ? () {} : onPressed,
          pressed: pressed,
          style: NeumorphicStyle(
            shape: pressed ? NeumorphicShape.concave : NeumorphicShape.convex,
            boxShape: const NeumorphicBoxShape.circle(),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              bdg.Badge(
                showBadge: badge != null,
                position: bdg.BadgePosition.topEnd(top: -10, end: -13),
                badgeContent: Text(
                  badge ?? "",
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: pressed
                      ? CupertinoColors.activeBlue
                      : const Color.fromARGB(255, 70, 72, 74),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  height: 1,
                  color: pressed
                      ? CupertinoColors.activeBlue
                      : const Color.fromARGB(255, 70, 72, 74),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
