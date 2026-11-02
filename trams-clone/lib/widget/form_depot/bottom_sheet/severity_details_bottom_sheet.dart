import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:tram/model/form/form_depot/common/severity_model.dart';
import 'package:tram/widget/form_depot/basic/button.dart';
import 'package:tram/widget/form_depot/form_depot_text_scope.dart';

void severityDetailsBottomSheet(BuildContext context,
    {required List<SeverityModel> severityModel}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (BuildContext context) {
      return FormDepotTextScope(
        child: SizedBox(
          height: Get.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button and title row
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Severity Level Rating & Description',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                        width: 20), // To align close button and title
                  ],
                ),
              ),
              const Divider(height: 8, thickness: 1),
              // Material abbreviation list
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Severity Level Rating & Description',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                ),
              ),
              SeverityDetailsList(severityModel: severityModel),
              // Close button
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: button('Close', () async {
                  Navigator.pop(context);
                }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}

class SeverityDetailsList extends StatelessWidget {
  const SeverityDetailsList({Key? key, required this.severityModel})
      : super(key: key);

  final List<SeverityModel> severityModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      shrinkWrap: true,
      children: severityModel.map<Widget>((e) {
        return SeverityDetailsItem(
            severityLevel: e.level,
            severityLevelNote: e.additionalNote,
            description: e.description);
      }).toList(),
    ));
  }
}

class SeverityDetailsItem extends StatefulWidget {
  final String severityLevel;
  final String severityLevelNote;
  final Text description;

  const SeverityDetailsItem({
    Key? key,
    required this.severityLevel,
    this.severityLevelNote = "",
    required this.description,
  }) : super(key: key);

  @override
  State<SeverityDetailsItem> createState() => _SeverityDetailsItemState();
}

class _SeverityDetailsItemState extends State<SeverityDetailsItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // severity level column
          Column(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  widget.severityLevel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              if (widget.severityLevelNote != "")
                SizedBox(
                  width: 40,
                  child: Text(
                    widget.severityLevelNote,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12.0,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          // Description column
          Expanded(child: widget.description),
        ],
      ),
    );
  }
}
