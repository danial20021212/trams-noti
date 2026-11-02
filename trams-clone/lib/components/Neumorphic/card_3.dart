import 'package:flutter_neumorphic/flutter_neumorphic.dart';

Widget NeumorphicCard3(
  String title, {
  EdgeInsets? padding,
  Color? color,
  required List<Widget> children,
  CrossAxisAlignment? crossAxisAlignment,
}) {
  color ??= Colors.blue.shade500;
  return Neumorphic(
    style: NeumorphicStyle(
      boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.circular(10),
      ),
    ),
    margin: const EdgeInsets.all(20),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            title: Text(
              title,
              style: const TextStyle(
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
          child: Column(
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ],
    ),
  );
}
