import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/theme.dart';

enum Destination {
  home,
  warehouse,
  project,
  sites,
  inventory,
  materialrequest,
  stockcheck,
  machine,
}

class NowDrawer extends StatefulWidget {
  final Destination currentPage;
  const NowDrawer({
    super.key,
    required this.currentPage,
  });

  @override
  State<NowDrawer> createState() => _NowDrawerState();
}

class _NowDrawerState extends State<NowDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
      vsync: this,
    );
    super.initState();
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: NowUIColors.primary,
      child: Column(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    //Image.asset("assets/imgs/now-logo.png"),

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: IconButton(
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.arrow_menu,
                          progress: controller,
                          color: NowUIColors.white.withOpacity(0.82),
                          size: 24.0,
                        ),
                        onPressed: () {
                          controller.reverse();
                          Get.back();
                        },
                      ),
                    ),
                    const Text("LD System"),
                  ],
                ),
              ),
            )),
        Expanded(
          flex: 2,
          child: ListView(
            padding: const EdgeInsets.only(top: 36, left: 8, right: 16),
            children: [
              // homeDrawerTile(
              //   context,
              //   widget.currentPage,
              // ),
              // warehouseDrawerTile(
              //   context,
              //   widget.currentPage,
              // ),
              // projectDrawerTile(
              //   context,
              //   widget.currentPage,
              // ),
              // sitesDrawerTile(
              //   context,
              //   widget.currentPage,
              // ),
              // inventoryDrawerTile(
              //   context,
              //   widget.currentPage,
              // ),
              // materialDrawerTile(
              //   context,
              //   widget.currentPage,
              // ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              padding: const EdgeInsets.only(left: 8, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                      height: 4,
                      thickness: 0,
                      color: NowUIColors.white.withOpacity(0.8)),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 16, bottom: 8),
                    child: Text("DOCUMENTATION",
                        style: TextStyle(
                          color: NowUIColors.white.withOpacity(0.8),
                          fontSize: 13,
                        )),
                  ),
                ],
              )),
        ),
      ]),
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
