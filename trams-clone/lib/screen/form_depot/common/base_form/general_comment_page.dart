import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';

import '../../../../controller/form_depot/common/base_form_controller.dart';

class GeneralCommentPage extends StatefulWidget {
  const  GeneralCommentPage({super.key});

  @override
  State<GeneralCommentPage> createState() => _GeneralCommentPageState();
}

class _GeneralCommentPageState extends State<GeneralCommentPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<BaseFormController>();
  final auth = Get.find<AuthController>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xfff3f8fe),
      body: Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 5,
          left: 5,
          right: 5,
        ),
        width: Get.width,
        height: Get.height -
            Scaffold.of(context).appBarMaxHeight!.toDouble() -
            (Get.size.shortestSide >= 600 ? 80 : 60) -
            50,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          children: [
            const SizedBox(height: 50),
            const Text("PART C: General Comment (If any)",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            const SizedBox(height: 20),
            Obx(() => richTextField(
                isEnable: controller.currentRole == Roles.sp && !controller.isReviewMode.value,
                title: "Service Provider",
                getter: controller.getSpRemarkPartC,
                onChanged: (e) => controller.setSpRemarkPartC = e)),
            Obx(() => richTextField(
                isEnable: controller.currentRole == Roles.cons && controller.isReviewMode.value && !controller.isReadOnly.value,
                title: "Engineering Consultant/S.O/S.O's Rep.",
                getter: controller.getConsRemarkPartC,
                onChanged: (e) => controller.setConsRemarkPartC = e)),
          ],
        ),
      ),
    );
  }
}
