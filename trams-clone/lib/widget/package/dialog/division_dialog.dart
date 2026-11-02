import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tram/controller/home/home_controller.dart';
import 'package:tram/model/basic/map/company_detail_model.dart';
import 'package:tram/model/basic/map/package_detail_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';

class DivisionDialog extends StatelessWidget {
  final DivisionModel division;
  final String pkg;
  const DivisionDialog({
    super.key,
    required this.division,
    required this.pkg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
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
                    "Division : ${division.division}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  _spacer10(),
                  Text(
                    "Paved Road : ${division.pavedRoadLength} KM",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  _spacer5(),
                  Text(
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
                      _rank("1", division.pavedRdCond1),
                      _rank("2", division.pavedRdCond2),
                      _rank("3", division.pavedRdCond3),
                    ],
                  ),
                  _spacer10(),
                  Text(
                    "Unpaved Road : ${division.unPavedRoadLength} KM",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  _spacer5(),
                  Text(
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
                      _rank("1", division.unPavedRdCond1),
                      _rank("2", division.unPavedRdCond2),
                      _rank("3", division.unPavedRdCond3),
                    ],
                  ),
                  _spacer10(),
                  _textBtn(
                    "Total Road : ${division.totalRoadLength}",
                    () {
                      Get.toNamed("/road_statistic_listing", arguments: {
                        "pkg": pkg,
                        "division": division.division,
                        "type": "division",
                      });
                    },
                  ),
                  _textBtn(
                    "Condition (RMI) : ${division.rmi}",
                    () {
                      Get.toNamed("/achievement_kppi", arguments: {
                        "pkg": pkg,
                        "place": division.division,
                        "type": "division",
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
      style: TextStyle(
        shadows: const [
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
