import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tram/components/Neumorphic/button_2.dart';
import 'package:tram/controller/detail/package_detail_listing_controller.dart';
import 'package:tram/model/basic/map/package_detail_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/widget/package/detail/list_district.dart';
import 'package:tram/widget/package/detail/list_division.dart';
import 'package:tram/widget/package/dialog/package_dialog.dart';

import '../../components/Neumorphic/card_3.dart';
import '../../components/Neumorphic/navbar.dart';
import '../../components/sliver_tab_bar_delegate.dart';

class PackageDetailListingScreen extends StatefulWidget {
  const PackageDetailListingScreen({super.key});

  @override
  State<PackageDetailListingScreen> createState() => _DetailState();
}

class _DetailState extends State<PackageDetailListingScreen> {
  final controller = Get.find<PackageDetailListingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NeumorphicNavBar(
        title: "Package Detail",
        showDrawer: false,
        color: Color(0xfff3f8fe),
      ),
      body: Neumorphic(
        style: const NeumorphicStyle(
          color: Color(0xfff3f8fe),
        ),
        child: SafeArea(
          bottom: false,
          child: NestedScrollView(
            controller: controller.scrollController,
            headerSliverBuilder: (context, _) => [
              SliverToBoxAdapter(child: Obx(() {
                switch (controller.state.value) {
                  case LoaderState.initial:
                  case LoaderState.loading:
                    return SizedBox(
                      height: Get.size.shortestSide >= 600 ? 250 : 150,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  case LoaderState.loaded:
                    PackageModel package = controller.detail.value!.package!;
                    return _buildDetail(package);
                  case LoaderState.failure:
                    return SizedBox(
                      height: Get.size.shortestSide >= 600 ? 250 : 150,
                      child: const Center(
                        child: Text("Failed to load data"),
                      ),
                    );
                }
              })),
            ],
            body: DefaultTabController(
              initialIndex: 0,
              length: controller.tabs.length,
              child: CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.scrollController,
                slivers: [
                  SliverPersistentHeader(
                    delegate: SliverTabBarDelegate(
                      tabBar: TabBar(
                        tabs: controller.tabs,
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.black,
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    pinned: true,
                  ),
                  const SliverFillRemaining(
                    child: TabBarView(
                      children: [
                        ListDivision(),
                        ListDistrict(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(PackageModel package) {
    return NeumorphicButton2(
      margin: Get.size.shortestSide >= 600
          ? const EdgeInsets.only(left: 50, right: 50, bottom: 20, top: 20)
          : const EdgeInsets.all(10),
      onPressed: () {
        SmartDialog.show(
          builder: (context) {
            return PackageDialog(
              package: package,
              pkg: controller.pkg,
            );
          },
        );
      },
      "Detail",
      SizedBox(
        height: 130,
        child: Column(
          children: [
            _textWithIcon(
              Icon(
                size: 24,
                Icons.business,
                color: Colors.orange,
              ),
              controller.companyName,
            ),
            SizedBox(
              height: 5,
            ),
            _textWithIcon(
              const Icon(
                size: 24,
                IconData(
                  0xf2bf,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage,
                ),
                color: Colors.green,
              ),
              "Total Length : ${package.totalRoadLength} KM",
            ),
            _textWithIcon2(
              Icon(
                size: 24,
                Icons.book,
                color: Colors.blue,
              ),
              "Package : ",
              "${package.package}",
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _textWithIcon(Icon icon, String text) {
  return Row(
    children: [
      icon,
      SizedBox(
        width: 15,
      ),
      Flexible(
        child: Text(
          text,
          textAlign: TextAlign.left,
          softWrap: true,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    ],
  );
}

Widget _textWithIcon2(
  Icon icon,
  String tiitle,
  String value, {
  Color color = Colors.black,
}) {
  return Row(
    children: [
      icon,
      SizedBox(
        width: 15,
      ),
      Flexible(
        child: RichText(
          textAlign: TextAlign.left,
          softWrap: true,
          text: TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                TextSpan(text: tiitle),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 18,
                    color: color,
                  ),
                ),
              ]),
        ),
      ),
    ],
  );
}
