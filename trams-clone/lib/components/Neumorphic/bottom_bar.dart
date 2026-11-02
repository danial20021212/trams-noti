import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../controller/home/root_home_controller.dart';
import 'tile_bottom_bar.dart';

class NeumorphicBottomBar extends GetView<RootHomeController> {
  static const double buttonExtent = 60;
  static const double verticalPadding = 10;
  static const double height = buttonExtent + (verticalPadding * 2);

  final Color background;
  const NeumorphicBottomBar({
    super.key,
    this.background = const Color(0xffe9f3fd),
  });

  List<Widget> _buildListScreens() => [
        NeumorphicTileBottomBar(
          pressed: controller.index.value == 0,
          icon: Icons.home,
          title: "Home",
          onPressed: () => controller.to(0),
        ),
        NeumorphicTileBottomBar(
          pressed: controller.index.value == 1,
          icon: Icons.dashboard,
          title: "Dashboard",
          onPressed: () => controller.to(1),
        ),
        NeumorphicTileBottomBar(
          pressed: controller.index.value == 2,
          icon: Icons.dock,
          title: "Doc",
          onPressed: () => controller.to(2),
        ),
        NeumorphicTileBottomBar(
          pressed: controller.index.value == 3,
          icon: Icons.map,
          title: "Map",
          onPressed: () => controller.to(3),
        ),
        NeumorphicTileBottomBar(
          pressed: controller.index.value == 4,
          icon: Icons.work,
          title: "Work\nHistory",
          onPressed: () => controller.to(4),
        ),
        NeumorphicTileBottomBar(
          pressed: controller.index.value == 5,
          icon: Icons.edit_document,
          title: "Form\nDepot",
          onPressed: () => controller.to(5),
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Neumorphic(
        style: const NeumorphicStyle(
          color: Color(0xffe9f3fd),
        ),
        child: Container(
          padding: const EdgeInsets.only(
            top: verticalPadding,
            bottom: verticalPadding,
            left: 5,
            right: 5,
          ),
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildListScreens(),
            ),
          ),
        ),
      ),
    );
  }
}
