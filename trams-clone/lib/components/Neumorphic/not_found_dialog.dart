import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class NeumorphicDialog {
  static showNotFound({String? title}) {
    SmartDialog.show(
      alignment: Alignment.center,
      clickMaskDismiss: false,
      backDismiss: false,
      builder: (context) => _NotFound1(
        title ?? "Item Not Found",
      ),
    );
  }
}

class _NotFound1 extends StatelessWidget {
  final String title;
  const _NotFound1(this.title);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height * 0.5 + 50,
      child: Neumorphic(
        margin: const EdgeInsets.all(50),
        style: NeumorphicStyle(
          color: const Color.fromARGB(255, 222, 240, 255),
          intensity: 0.8,
          shape: NeumorphicShape.flat,
          surfaceIntensity: 1,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 30,
                color: Colors.red.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
            _closeButton(),
          ],
        ),
      ),
    );
  }
}

Widget _closeButton() {
  return NeumorphicButton(
    padding: const EdgeInsets.only(
      left: 35,
      right: 35,
      top: 15,
      bottom: 15,
    ),
    style: const NeumorphicStyle(
      color: Colors.blueAccent,
      depth: 5,
      boxShape: NeumorphicBoxShape.stadium(),
    ),
    onPressed: () {
      Get.back();
    },
    child: const Text(
      'Close',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );
}
