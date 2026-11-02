import 'package:flutter/material.dart';

class NowUIColors {
  static const Color black = Color(0xFF000000);

  static const Color white = Color(0xFFFFFFFF);

  static const Color defaultColor = Color.fromRGBO(136, 136, 136, 1.0);

  static const Color primary = Color.fromARGB(255, 50, 136, 249);

  static const Color secondary = Color.fromRGBO(68, 68, 68, 1.0);

  static const Color label = Color.fromRGBO(254, 36, 114, 1.0);

  static const Color neutral = Color.fromRGBO(255, 255, 255, 0.2);

  static const Color tabs = Color.fromRGBO(222, 222, 222, 0.3);

  static const Color info = Color.fromARGB(255, 44, 150, 255);

  static const Color error = Color.fromRGBO(255, 54, 54, 1.0);

  static const Color success = Color.fromRGBO(24, 206, 15, 1.0);

  static const Color warning = Color.fromRGBO(255, 178, 54, 1.0);

  static const Color text = Color.fromRGBO(44, 44, 44, 1.0);

  static const Color bgColorScreen = Color.fromRGBO(255, 255, 255, 1.0);

  static const Color border = Color.fromRGBO(231, 231, 231, 1.0);

  static const Color inputSuccess = Color.fromRGBO(27, 230, 17, 1.0);

  static const Color input = Color.fromRGBO(220, 220, 220, 1.0);

  static const Color inputError = Color.fromRGBO(255, 54, 54, 1.0);

  static const Color muted = Color.fromRGBO(136, 152, 170, 1.0);

  // static const Color text = Color.fromRGBO(50, 50, 93, 1.0);

  static const Color time = Color.fromRGBO(154, 154, 154, 1.0);

  static const Color priceColor = Color.fromRGBO(234, 213, 251, 1.0);

  static const Color active = Color.fromRGBO(249, 99, 50, 1.0);

  static const Color buttonColor = Color.fromRGBO(156, 38, 176, 1.0);

  static const Color placeholder = Color.fromRGBO(159, 165, 170, 1.0);

  static const Color switchON = Color.fromRGBO(249, 99, 50, 1.0);

  static const Color switchOFF = Color.fromRGBO(137, 137, 137, 1.0);

  static const Color gradientStart = Color.fromRGBO(107, 36, 170, 1.0);

  static const Color gradientEnd = Color.fromRGBO(172, 38, 136, 1.0);

  static const Color socialFacebook = Color.fromRGBO(59, 89, 152, 1.0);

  static const Color socialTwitter = Color.fromRGBO(91, 192, 222, 1.0);

  static const Color socialDribbble = Color.fromRGBO(234, 76, 137, 1.0);

  static const List<Color> indicatorColors = [
    Color(0xff0293ee),
    Color(0xfff8b250),
    Color(0xff845bef),
    Color(0xff13d38e),
    Color.fromARGB(255, 211, 19, 195),
    Color.fromARGB(255, 211, 19, 19),
  ];

  static const List<Gradient> cardColor = [
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Colors.lime,
        Colors.green,
      ],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color.fromARGB(255, 109, 181, 237),
        Color.fromARGB(255, 9, 25, 112),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xff5F0A87),
        Color(0xffA4508B),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 55, 91, 142),
        Color.fromARGB(255, 76, 130, 175),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 245, 56, 201),
        Color(0xff42378F),
      ],
    ),
  ];
}

class NowUIGradient {
  static const LinearGradient pinkRed = LinearGradient(
    colors: [
      Color.fromARGB(255, 230, 67, 67),
      Color.fromARGB(255, 255, 255, 255),
    ],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );

  static const LinearGradient white = LinearGradient(
    colors: [
      Color.fromARGB(255, 255, 251, 251),
      Color.fromARGB(255, 252, 252, 252),
    ],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );
}

class NowTextStyle {
  static TextStyle? sliderTitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: 45,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        );
  }

  static TextStyle? sliderSubtitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: 17,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        );
  }

  static TextStyle? sliderBody(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        );
  }

  static TextStyle? formTitle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        );
  }

  static TextStyle? formSubTitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: 17,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w600,
        );
  }

  static TextStyle? cardSubtitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: 17,
          color: const Color.fromARGB(255, 16, 16, 16),
          fontWeight: FontWeight.bold,
        );
  }

  static TextStyle? cardBody(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: 13,
          color: const Color.fromARGB(255, 96, 96, 96),
          fontWeight: FontWeight.w400,
        );
  }
}
