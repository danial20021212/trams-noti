import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../constant/path.dart';
import '../../controller/home/root_home_controller.dart';
import '../../components/Neumorphic/bottom_bar.dart';
import '../../components/Neumorphic/navbar.dart';

class RootHomeScreen extends StatefulWidget {
  const RootHomeScreen({super.key});

  @override
  State<RootHomeScreen> createState() => _RootHomeState();
}

class _RootHomeState extends State<RootHomeScreen> {
  final controller = Get.find<RootHomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        key: controller.scaffoldKey,
        appBar: NeumorphicNavBar(
          leading: controller.drawer.value == null
              ? const Center()
              : NeumorphicButton(
                  onPressed: () {
                    controller.scaffoldKey.currentState?.openDrawer();
                  },
                  child: controller.index.value == 5
                      ? const Icon(Icons.edit_note, size: 20)
                      : const Icon(Icons.menu, size: 20),
                ),
          logo: SizedBox.square(
            dimension: 44,
            child: Image.asset(
              AssetStorage.logo,
              fit: BoxFit.contain,
            ),
          ),
          color: const Color(0xffe9f3fd),
          actions: [
            if (controller.index.value == 5)
              NeumorphicButton(
                onPressed: () {
                  Get.toNamed('/notifications');
                },
                child: Badge(
                  isLabelVisible: controller.notificationCount.value > 0,
                  label: Text('${controller.notificationCount.value}'),
                  child: const Icon(Icons.notifications_none, size: 20),
                ),
              ),
            NeumorphicButton(
              onPressed: () {
                controller.logout();
              },
              child: const Icon(Icons.logout, size: 20),
            ),
          ],
        ),
        floatingActionButton: controller.floatingButton.value,
        drawer: controller.drawer.value,
        bottomNavigationBar: const NeumorphicBottomBar(),
        body: IndexedStack(
          sizing: StackFit.expand,
          index: controller.index.value,
          children: controller.screens,
        ),
      ),
    );
  }
}
