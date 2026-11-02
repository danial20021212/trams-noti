import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tram/controller/detail/package_detail_listing_controller.dart';
import 'package:tram/model/basic/map/package_detail_model.dart';
import 'package:tram/widget/package/dialog/division_dialog.dart';

import '../../../components/Neumorphic/button_1.dart';

class ListDivision extends GetView<PackageDetailListingController> {
  const ListDivision({super.key});

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, DivisionModel>(
      pagingController: controller.p1,
      builderDelegate: PagedChildBuilderDelegate<DivisionModel>(
        itemBuilder: (context, item, index) => _item(
          item,
        ),
      ),
    );
  }

  Widget _item(DivisionModel division) {
    return NeumorphicButton1(
      onPressed: () {
        SmartDialog.show(
          builder: (context) {
            return DivisionDialog(
              division: division,
              pkg: controller.pkg,
            );
          },
        );
      },
      title: Text(
        division.division,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
