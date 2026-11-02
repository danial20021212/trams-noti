import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tram/controller/home/dashboard_controller.dart';
import 'package:tram/widget/home/dashboard_button_group.dart';

import '../../controller/auth/auth_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: const NeumorphicStyle(
        boxShape: NeumorphicBoxShape.rect(),
        color: Color(0xffe9f3fd),
      ),
      child: const DashboardIconGroup(),
    );
  }
}

class DashboardIconGroup extends StatefulWidget {
  const DashboardIconGroup({super.key});

  @override
  State<DashboardIconGroup> createState() => _DashboardIconGroupState();
}

class _DashboardIconGroupState extends State<DashboardIconGroup> {
  final controller = Get.find<DashboardController>();
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 20,
              left: 5,
              right: 5,
            ),
            width: double.infinity,
            child: Obx(
              () => ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Center(
                    child: Text(
                      "Updated At : ${controller.dateModel.value?.rcdate == null ? '--/--/----' : DateFormat('dd/MM/yyyy').format(controller.dateModel.value!.rcdate!)}",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  _rowTitle("Road"),
                  _buildRoadRow(),
                  _spacer(),
                  _rowTitle("Asset"),
                  _buildAssetRow(),
                  _spacer(),

                  //_rowTitle("Report"),
                  //_buildReportRow(context),
                  //_spacer(),
                  if ((auth.getUserGroup() == "1" ||
                          auth.getUserGroup() == "2") &&
                      (auth.getUserPackage()?.isEmpty ?? true)) ...[
                    _rowTitle("Service Provider Performance"),
                    _buildOtherRow(),
                  ]
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              "V1.1.14",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        )
      ],
    );
  }
}

Widget _spacer() {
  return const SizedBox(
    height: 10,
  );
}

Widget _rowTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 3,
      vertical: 3,
    ),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget generateColumn(List<Widget> items) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final columnCount =
          width < 600 ? 4 : (width / 120).floor().clamp(6, 10).toInt();
      final rows = <Widget>[];

      for (var start = 0; start < items.length; start += columnCount) {
        final end = (start + columnCount).clamp(0, items.length);
        final rowItems = items.sublist(start, end);
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              columnCount,
              (index) => Expanded(
                child: index < rowItems.length ? rowItems[index] : emptyIcon(),
              ),
            ),
          ),
        );
      }

      return Column(children: rows);
    },
  );
}

Widget _buildRoadRow() {
  List<Widget> list = [
    roadLengthIcon(),
    roadMaintenanceIcon(),
    roughnessIndexIcon(),
    roadConditionIcon(),
  ];

  return generateColumn(list);
}

Widget _buildAssetRow() {
  List<Widget> list = [
    assetInventoryIcon(),
  ];
  return generateColumn(list);
}

// Widget _buildReportRow(BuildContext context) {
//   List<Widget> list = [
//     vdsReportIcon()
//   ];
//   return FittedBox(
//     fit: BoxFit.fitWidth,
//     child: generateColumn(list),
//   );
// }

Widget _buildOtherRow() {
  List<Widget> list = [
    paiIcon(),
    spiIcon(),
  ];
  return generateColumn(list);
}
