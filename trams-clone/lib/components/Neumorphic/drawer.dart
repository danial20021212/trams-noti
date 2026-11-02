// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:get/get.dart';
// import 'package:ld_system/constants/path.dart';
// import 'package:ld_system/controller/home/root_home_controller.dart';

// import '../../constants/theme.dart';
// import 'neumorphic_drawer_list.dart';

// enum Destination {
//   home,
//   scan,
//   notify,
//   profile,
// }

// class NeumorphicDrawer extends GetView<RootHomeController> {
//   const NeumorphicDrawer({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       key: controller.drawerKey,
//       child: Container(
//         color: NeumorphicTheme.baseColor(context),
//         child: Column(
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.12,
//               width: MediaQuery.of(context).size.width * 0.85,
//               child: SafeArea(
//                 bottom: false,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 4.0, right: 20.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     textBaseline: TextBaseline.alphabetic,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: NeumorphicButton(
//                           style: const NeumorphicStyle(
//                             boxShape: NeumorphicBoxShape.circle(),
//                           ),
//                           child: Icon(
//                             Icons.arrow_back,
//                             color: NowUIColors.black.withOpacity(0.82),
//                             size: 30.0,
//                           ),
//                           onPressed: () {
//                             Get.back();
//                           },
//                         ),
//                       ),
//                       Image.asset(AssetStorage.logo),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Obx(
//                 () => ListView(
//                   padding: const EdgeInsets.only(top: 10, left: 8, right: 16),
//                   children: _buildTile(context),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Container(
//                 padding: const EdgeInsets.only(left: 8, right: 16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Divider(
//                         height: 4,
//                         thickness: 0,
//                         color: NowUIColors.white.withOpacity(0.8)),
//                     logoutDrawerTile(context),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildTile(
//     BuildContext context,
//   ) {
//     return [
//       homeDrawerTile(
//         context,
//         controller,
//       ),
//       scanDrawerTile(
//         context,
//         controller,
//       ),
//       notifyDrawerTile(
//         context,
//         controller,
//       ),
//       profileDrawerTile(
//         context,
//         controller,
//       ),
//     ];
//   }
// }
