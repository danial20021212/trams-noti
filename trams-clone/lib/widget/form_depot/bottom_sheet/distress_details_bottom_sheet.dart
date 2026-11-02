import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tram/widget/form_depot/basic/button.dart';
import 'package:tram/widget/form_depot/form_depot_text_scope.dart';

void distressDetailsBottomSheet(BuildContext context,
    {required List<String> distressList}) {
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
                      'Common Distress Abbreviation',
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
                    'Common Distress Abbreviation',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              DistressDetailsList(distressList: distressList),
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

class DistressDetailsList extends StatelessWidget {
  const DistressDetailsList({Key? key, required this.distressList})
      : super(key: key);

  final List<String> distressList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: distressList.map<Widget>((code) {
          String description = _getDescriptionFromCode(code);
          return DistressDetailsItem(code: code, description: description);
        }).toList(),
      ),
    );
  }

  String _getDescriptionFromCode(String code) {
    switch (code) {
      case 'C01':
        return 'Not installed';
      case 'C02':
        return 'Mission';
      case 'C03':
        return 'Damaged';
      case 'C04':
        return 'Obscured';
      case 'C05':
        return 'Vegetation';
      case 'C06':
        return 'Debris';
      case 'C07':
        return 'Erosion / Scour';
      case 'C08':
        return 'Siltation';
      case 'C09':
        return 'Blockages';
      case 'C10':
        return 'Damaged';
      case 'C11':
        return 'Failure';
      case 'C12':
        return 'Others';
      case 'C13':
        return 'Material defects';
      case 'C14':
        return 'Impact damage';
      case 'C15':
        return 'Coatings defects';
      case 'C16':
        return 'Movement';
      case 'C17':
        return 'Settlement';
      case 'C18':
        return 'Loss of material underneath';
      case 'C19':
        return 'Pile exposed';
      case 'C20':
        return 'Others';
      case 'C21':
        return 'Joints material deficiency';
      case 'C22':
        return 'Impact damage';
      case 'C23':
        return 'Coatings damage';
      case 'C24':
        return 'Unit localized movement';
      case 'C25':
        return 'Settlement';
      case 'C26':
        return 'Tilting';
      case 'C27':
        return 'Unit Dislocation';
      case 'C28':
        return 'Inadequate opening / channel size';
      case 'C30':
        return 'Abrasion';
      case 'C31':
        return 'Corrosion';
      case 'C32':
        return 'Others';
      case 'C33':
        return 'Settlement';
      case 'C34':
        return 'Bump';
      case 'C35':
        return 'Structure Expose';
      case 'C36':
        return 'Other';
      default:
        return 'Unknown';
    }
  }
}

class DistressDetailsItem extends StatelessWidget {
  final String code;
  final String description;

  const DistressDetailsItem({
    Key? key,
    required this.code,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // severity level column
          SizedBox(
            width: 50,
            child: Text(
              code,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16.0, height: 2),
            ),
          ),
          const SizedBox(width: 10),
          // Description column
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 16.0, height: 2),
            ),
          ),
        ],
      ),
    );
  }
}
