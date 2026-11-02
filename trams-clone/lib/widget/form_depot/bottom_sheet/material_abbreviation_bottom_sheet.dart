import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tram/widget/form_depot/basic/button.dart';
import 'package:tram/widget/form_depot/form_depot_text_scope.dart';

void materialAbbreviationBottomSheet(
    BuildContext context, List<String> abbreviationsToShow) {
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
            mainAxisSize: MainAxisSize.min, // Adjusts height based on content
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
                      'Material Abbreviation',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                        width: 40), // To align close button and title
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
                    'Material Abbreviation',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              // 2. MODIFICATION: Pass the list to the widget
              MaterialAbbreviationList(
                  abbreviationsToShow: abbreviationsToShow),
              // Close button
              const SizedBox(height: 20),
              button('Close', () async {
                Navigator.pop(context);
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}

class MaterialAbbreviationList extends StatelessWidget {
  final List<String> abbreviationsToShow;

  const MaterialAbbreviationList({
    Key? key,
    required this.abbreviationsToShow,
  }) : super(key: key);

  // Master list of all abbreviations
  static const Map<String, String> _allAbbreviations = {
    'RC': 'Reinforced Concrete/Concrete',
    'S': 'Steel/Metal/Aluminium',
    'P': 'PVC',
    'A': 'Asphaltic',
    'G': 'Gabion',
    'T': 'Timber',
    'O': 'Others',
    'R': 'Rubber/Rubber Pitching',
    'AP': 'Asphaltic Plug',
    'M': 'Masonry',
    'E': 'Elastomeric',
    'N': 'Natural',
    'H': 'HDPE',
    'B': 'Block Stone'
  };

  @override
  Widget build(BuildContext context) {
    // Build the list of widgets dynamically based on abbreviationsToShow
    final List<Widget> filteredItems = abbreviationsToShow.map((abbr) {
      final String? description = _allAbbreviations[abbr];

      if (description != null) {
        return MaterialAbbreviationItem(
          abbreviation: abbr,
          description: description,
        );
      }
      // Fallback for an abbreviation not in the master list
      return MaterialAbbreviationItem(
        abbreviation: abbr,
        description: 'N/A',
      );
    }).toList();

    return Expanded(
      child: ListView(
        children: filteredItems,
      ),
    );
  }
}

class MaterialAbbreviationItem extends StatelessWidget {
  final String abbreviation;
  final String description;

  const MaterialAbbreviationItem({
    Key? key,
    required this.abbreviation,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
      child: Row(
        children: [
          // Abbreviation column
          SizedBox(
            width: 30,
            child: Text(
              abbreviation,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Description column
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
