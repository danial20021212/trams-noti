import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:get/get.dart';

import '../../constant/path.dart';

//-------------------Warehouse------------------------
Widget roadLengthIcon() {
  return _iconButton(
    Image.asset(
      AssetStorage.roadLength,
    ),
    "Road\nLength",
    () {
      Get.toNamed(
        '/road_length',
      );
    },
  );
}

Widget roadMaintenanceIcon() {
  return _iconButton(
    Image.asset(
      AssetStorage.roadMaintenance,
    ),
    "Road\nMaintenance\nIndicator",
    () {
      Get.toNamed(
        '/road_maintenance',
      );
    },
  );
}

Widget roughnessIndexIcon() {
  return _iconButton(
    Image.asset(
      AssetStorage.roughnessIndex,
    ),
    "International\nRoughness\nIndex",
    () {
      Get.toNamed(
        '/roughness_index',
      );
    },
  );
}

Widget roadConditionIcon() {
  return _iconButton(
    Image.asset(
      AssetStorage.roadCondition,
    ),
    "Road\nCondition\nRating",
    () {
      Get.toNamed(
        '/road_condition',
      );
    },
  );
}

//----------------------------------------------------

Widget assetInventoryIcon() {
  return _iconButton(
    Image.asset(
      AssetStorage.assetInventory,
    ),
    "Asset\nInventories",
    () {
      Get.toNamed(
        '/asset_inventory',
      );
    },
  );
}

//-------------------------------------------------------------------------------------------

// Widget vdsReportIcon() {
//   return _iconButton(
//     Image.asset(
//       AssetStorage.assetInventory,
//     ),
//     "VDS\nReport",
//     () {
//       Get.toNamed(
//         '/vds_report',
//       );
//     },
//   );
// }

//-------------------------------------------------------------------------------------------
Widget paiIcon() {
  return _iconButton(
    Image.asset(
      AssetStorage.pai,
    ),
    "PAI",
    () {
      Get.toNamed(
        '/pai',
      );
    },
  );
}

Widget spiIcon() {
  return _iconButton(
    Image.asset(
      AssetStorage.spi,
    ),
    "SPI",
    () {
      Get.toNamed(
        '/spi',
      );
    },
  );
}

//----------------------------------------------------------

Widget _iconButton(
  Widget child,
  String title,
  void Function() onPressed,
) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isCompact = MediaQuery.sizeOf(context).width < 600;
      final maxButtonExtent = isCompact ? 80.0 : 96.0;
      final buttonExtent =
          (constraints.maxWidth - 10).clamp(48.0, maxButtonExtent).toDouble();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(
          height: buttonExtent + (isCompact ? 48 : 54),
          child: Column(
            children: [
              SizedBox.square(
                dimension: buttonExtent,
                child: NeumorphicButton(
                  minDistance: -3,
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(12),
                    ),
                    depth: 4,
                    lightSource: LightSource.topLeft,
                  ),
                  onPressed: onPressed,
                  child: child,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: AutoSizeText(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 14,
                    height: 1,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                  minFontSize: isCompact ? 9 : 11,
                  wrapWords: false,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget emptyIcon() {
  return const SizedBox.shrink();
}
