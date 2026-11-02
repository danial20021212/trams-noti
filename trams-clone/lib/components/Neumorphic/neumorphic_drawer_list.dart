// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:ld_system/controller/auth/auth_controller.dart';
// import 'package:ld_system/controller/home/root_home_controller.dart';
// import '../../constants/theme.dart';
// import 'drawer.dart';
// import 'drawer_tile.dart';

// Widget homeDrawerTile(
//   context,
//   RootHomeController controller,
// ) {
//   return NeumorphicDrawerTile(
//     icon: FontAwesomeIcons.house,
//     onTap: () {
//       if (controller.index.value != 0) {
//         controller.to(0);
//       } else {
//         Get.back();
//       }
//     },
//     background: NowUIColors.primary,
//     title: "Home",
//     isSelected: controller.index.value == 0,
//   );
// }

// Widget scanDrawerTile(
//   context,
//   RootHomeController controller,
// ) {
//   return NeumorphicDrawerTile(
//     icon: Icons.qr_code_scanner,
//     onTap: () {
//       if (controller.index.value != 1) {
//         controller.to(1);
//       } else {
//         Get.back();
//       }
//     },
//     background: NowUIColors.primary,
//     title: "Scan",
//     isSelected: controller.index.value == 1,
//   );
// }

// Widget notifyDrawerTile(
//   context,
//   RootHomeController controller,
// ) {
//   return NeumorphicDrawerTile(
//     icon: Icons.notifications,
//     onTap: () {
//       if (controller.index.value != 2) {
//         controller.to(2);
//       } else {
//         Get.back();
//       }
//     },
//     background: NowUIColors.primary,
//     title: "Notify",
//     isSelected: controller.index.value == 2,
//   );
// }

// Widget profileDrawerTile(
//   context,
//   RootHomeController controller,
// ) {
//   return NeumorphicDrawerTile(
//     icon: Icons.people,
//     onTap: () {
//       if (controller.index.value != 3) {
//         controller.to(3);
//       } else {
//         Get.back();
//       }
//     },
//     background: NowUIColors.primary,
//     title: "Profile",
//     isSelected: controller.index.value == 3,
//   );
// }

// Widget logoutDrawerTile(context) {
//   final auth = Get.find<AuthController>();
//   return NeumorphicDrawerTile(
//     icon: FontAwesomeIcons.user,
//     onTap: () {
//       auth.logout();
//     },
//     background: Colors.red.shade400,
//     title: "Logout",
//   );
// }
