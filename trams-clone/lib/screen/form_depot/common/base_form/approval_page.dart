import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/widget/form_depot/basic/input_group.dart';

import '../../../../controller/form_depot/common/base_form_controller.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({super.key});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage>
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
            const Text.rich(
              TextSpan(
                text: "Investigation",
                children: [
                  TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(height: 30),
            _buildApproval()
          ],
        ),
      ),
    );
  }

  Widget _buildApproval() {
    //Servives Provider Part
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "This bridge has been inspected in accordance with the requirements and I hereby certify that the above recorded information is true to the best of my knowledge.",
        //   style: TextStyle(color: Colors.grey[700], fontSize: 18),
        // ),
        // const SizedBox(height: 10),
        // _buildTextField(labelText: "Name", data: auth.accessName() ?? ""),
        // _buildTextField(
        //     labelText: "Designation", data: auth.getUserDesignation() ?? ""),
        // DatePickerTextField(
        //     getter: controller.getSpSignDate,
        //     setter: (e) => controller.setSpSignDate = e),
        // const SizedBox(height: 20),
        Text(
          "Have issues been found that require further investigation?",
          style: TextStyle(color: Colors.grey[700], fontSize: 18),
        ),
        const SizedBox(height: 10),
        Obx(() => CustomRadioListTile(
            title: "YES",
            value: "1",
            groupValue: controller.getInvestigation,
            onChanged: (value) => setState(
                () => controller.setInvestigation = value.toString()))),
        Obx(
          () => CustomRadioListTile(
              title: "NO",
              value: "0",
              groupValue: controller.getInvestigation,
              onChanged: (value) => setState(
                  () => controller.setInvestigation = value.toString())),
        ),
        // const SizedBox(height: 20),
        // Text(
        //   "Agree or Disagree this record",
        //   style: TextStyle(color: Colors.grey[700], fontSize: 18),
        // ),
        // const SizedBox(height: 10),
        // Obx(() => CustomRadioListTile(
        //     title: "Agree",
        //     value: "agree",
        //     groupValue: controller.getEcSignAgree,
        //     onChanged: (value) =>
        //         setState(() => controller.setEcSignAgree = value.toString()))),
        // Obx(
        //   () => CustomRadioListTile(
        //       title: "Disagree",
        //       value: "disagree",
        //       groupValue: controller.getEcSignAgree,
        //       onChanged: (value) =>
        //           setState(() => controller.setEcSignAgree = value.toString())),
        // ),
      ],
    );
  }

  // Widget _buildSpPart() {
  //   //Servives Provider Part
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // Text(
  //       //   "This bridge has been inspected in accordance with the requirements and I hereby certify that the above recorded information is true to the best of my knowledge.",
  //       //   style: TextStyle(color: Colors.grey[700], fontSize: 18),
  //       // ),
  //       // const SizedBox(height: 10),
  //       // _buildTextField(labelText: "Name", data: auth.accessName() ?? ""),
  //       // _buildTextField(
  //       //     labelText: "Designation", data: auth.getUserDesignation() ?? ""),
  //       // DatePickerTextField(
  //       //     getter: controller.getSpSignDate,
  //       //     setter: (e) => controller.setSpSignDate = e),
  //       // const SizedBox(height: 20),
  //       Text(
  //         "Have issues been found that require further investigation?",
  //         style: TextStyle(color: Colors.grey[700], fontSize: 18),
  //       ),
  //       const SizedBox(height: 10),
  //       Obx(() => CustomRadioListTile(
  //           title: "YES",
  //           value: "1",
  //           groupValue: controller.getInvestigation,
  //           onChanged: (value) => setState(
  //               () => controller.setInvestigation = value.toString()))),
  //       Obx(
  //         () => CustomRadioListTile(
  //             title: "NO",
  //             value: "0",
  //             groupValue: controller.getInvestigation,
  //             onChanged: (value) => setState(
  //                 () => controller.setInvestigation = value.toString())),
  //       ),
  //       // const SizedBox(height: 20),
  //       // Text(
  //       //   "Agree or Disagree this record",
  //       //   style: TextStyle(color: Colors.grey[700], fontSize: 18),
  //       // ),
  //       // const SizedBox(height: 10),
  //       // Obx(() => CustomRadioListTile(
  //       //     title: "Agree",
  //       //     value: "agree",
  //       //     groupValue: controller.getEcSignAgree,
  //       //     onChanged: (value) =>
  //       //         setState(() => controller.setEcSignAgree = value.toString()))),
  //       // Obx(
  //       //   () => CustomRadioListTile(
  //       //       title: "Disagree",
  //       //       value: "disagree",
  //       //       groupValue: controller.getEcSignAgree,
  //       //       onChanged: (value) =>
  //       //           setState(() => controller.setEcSignAgree = value.toString())),
  //       // ),
  //     ],
  //   );
  // }
  //
  // Widget _buildConsPart() {
  //   //Consultant Part
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "This is to confirm that the inspection information and results reported by the Service Provider is verified to the best of my knowledge.",
  //         style: TextStyle(color: Colors.grey[700], fontSize: 18),
  //       ),
  //       const SizedBox(height: 10),
  //       _buildTextField(labelText: "Name", data: auth.accessName() ?? ""),
  //       _buildTextField(
  //           labelText: "Designation", data: auth.getUserDesignation() ?? ""),
  //       DatePickerTextField(
  //           getter: controller.getEcSignDate,
  //           setter: (e) => controller.setEcSignDate = e),
  //       const SizedBox(height: 20),
  //       Text(
  //         "Agree or Disagree this record",
  //         style: TextStyle(color: Colors.grey[700], fontSize: 18),
  //       ),
  //       const SizedBox(height: 10),
  //       Obx(() => CustomRadioListTile(
  //           title: "Agree",
  //           value: "agree",
  //           groupValue: controller.getEcSignAgree,
  //           onChanged: (value) =>
  //               setState(() => controller.setEcSignAgree = value.toString()))),
  //       Obx(
  //         () => CustomRadioListTile(
  //             title: "Disagree",
  //             value: "disagree",
  //             groupValue: controller.getEcSignAgree,
  //             onChanged: (value) =>
  //                 setState(() => controller.setEcSignAgree = value.toString())),
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget _buildOtherPart() {
  //   return Center(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Text(
  //           "You are not authorized to sign this form.",
  //           style: TextStyle(
  //             color: Colors.grey[700],
  //             fontSize: 18,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //
  //         SizedBox(height: 8),
  //
  //         Text(
  //           "Your current role is: ${controller.currentRole.name}",
  //           style: TextStyle(
  //             color: Colors.grey[600],
  //             fontSize: 16,
  //           ),
  //         ),
  //
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildSignatureView() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         "Status",
  //         style: TextStyle(fontSize: 20),
  //       ),
  //       const Text("Approved",
  //           style: TextStyle(
  //               fontSize: 20,
  //               color: Colors.green,
  //               fontWeight: FontWeight.bold)),
  //       const SizedBox(height: 20),
  //       Container(
  //           width: Get.width,
  //           height: 150,
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.grey),
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Image.memory(
  //             controller.dataFromBase64String(controller.currentSignatures.value),
  //             fit: BoxFit.contain,
  //           )),
  //     ],
  //   );
  // }

  Widget _buildTextField({required String labelText, required String data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: Get.width,
        child: TextField(
          readOnly: true,
          canRequestFocus: false,
          controller: TextEditingController(text: data),
          decoration: InputDecoration(
            suffixStyle: const TextStyle(
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
              borderSide: const BorderSide(
                  color: Colors.grey), // Optional: Border color
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10), // Rounded corners when inactive
              borderSide: const BorderSide(color: Colors.grey),
            ),
            labelText: labelText,
          ),
        ),
      ),
    );
  }
}
