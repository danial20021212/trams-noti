import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicCard1 extends StatelessWidget {
  const NeumorphicCard1({
    super.key,
    this.title = "Placeholder Title",
    this.subtitle = "",
    this.description = "",
    required this.img,
    this.tap = defaultFunc,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
  });

  final String subtitle;
  final String description;
  final ImageProvider<Object> img;
  final Function() tap;
  final String title;

  final EdgeInsets margin;
  final EdgeInsets padding;

  static void defaultFunc() {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: NeumorphicButton(
        margin: margin,
        padding: padding,
        onPressed: tap,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image(
                      image: img,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                          Text(subtitle),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Expanded(
              flex: 3,
              child: Text("test"),
            )
          ],
        ),
      ),
    );
  }
}
