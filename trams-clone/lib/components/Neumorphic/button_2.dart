import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

Widget NeumorphicButton2(
  String title,
  Widget child, {
  EdgeInsets? padding,
  Color? color,
  Function()? onPressed,
  EdgeInsets margin = const EdgeInsets.all(20),
}) {
  color ??= Colors.blue.shade500;
  return NeumorphicButton(
    padding: EdgeInsets.zero,
    onPressed: onPressed,
    style: NeumorphicStyle(
      boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.circular(10),
      ),
    ),
    margin: margin,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          child: ListTile(
            minVerticalPadding: 10,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
              ),
            ),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Padding(
          padding: padding ??
              const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
                top: 20,
              ),
          child: child,
        ),
      ],
    ),
  );
}
