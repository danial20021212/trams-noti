import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tram/model/basic/map/package_detail_model.dart';

class PackageDialog extends StatelessWidget {
  final PackageModel package;
  final String pkg;
  const PackageDialog({
    super.key,
    required this.package,
    required this.pkg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20,
        ),
        height: Get.height * 0.65 - Get.bottomBarHeight,
        width: Get.width * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _spacer5(),
                  Text(
                    "Package : ${package.package}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  _spacer10(),
                  Text(
                    "Paved Road : ${package.pavedRoadLength} KM",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  _spacer5(),
                  const Text(
                    "Condition Rating",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  _spacer5(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _rank("1", "${package.pavedRdCond1}"),
                      _rank("2", "${package.pavedRdCond2}"),
                      _rank("3", "${package.pavedRdCond3}"),
                    ],
                  ),
                  _spacer10(),
                  Text(
                    "Unpaved Road : ${package.unPavedRoadLength} KM",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  _spacer5(),
                  const Text(
                    "Condition Rating",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  _spacer5(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _rank("1", "${package.unPavedRdCond1}"),
                      _rank("2", "${package.unPavedRdCond2}"),
                      _rank("3", "${package.unPavedRdCond3}"),
                    ],
                  ),
                  _spacer10(),
                  _textBtn(
                    "Total Road : ${package.totalRoadLength}",
                    () {
                      Get.toNamed("/road_statistic_listing", arguments: {
                        "pkg": pkg,
                        "division": package.package,
                        "type": "package",
                      });
                    },
                  ),
                  _textBtn(
                    "Condition (RMI) : ${package.rmi}",
                    () {
                      Get.toNamed("/achievement_kppi", arguments: {
                        "pkg": pkg,
                        "place": "",
                        "type": "package",
                      });
                    },
                  ),
                ],
              ),
            ),
            NeumorphicButton(
              onPressed: () {
                SmartDialog.dismiss();
              },
              child: Container(
                alignment: Alignment.center,
                width: Get.width * 0.65,
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

Widget _textBtn(String text, Function() onPressed) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(
        shadows: [
          Shadow(
            color: Colors.blue,
            offset: Offset(0, -5),
          ),
        ],
        decoration: TextDecoration.underline,
        decorationThickness: 3,
        color: Colors.transparent,
        decorationColor: Colors.blue,
        fontSize: 14,
      ),
    ),
  );
}

Widget _text(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 14,
    ),
  );
}

Widget _rank(String index, String distance) {
  return Column(
    children: [
      Text(
        index,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      ElevatedButton(
        onPressed: () {},
        child: Text(
          distance,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    ],
  );
}

Widget _spacer5() {
  return SizedBox(
    height: 5,
  );
}

Widget _spacer10() {
  return SizedBox(
    height: 10,
  );
}
