// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:get/get.dart';
//
// class FormDepotScreen extends StatefulWidget {
//   const FormDepotScreen({super.key});
//
//   @override
//   State<FormDepotScreen> createState() => _FormDepotScreenState();
// }
//
// class _FormDepotScreenState extends State<FormDepotScreen> {
//   // 1. Pagination State Variables
//   int _currentPage = 0;
//   final int _itemsPerPage = 7;
//
//   final List<Map<String, String>> formTypes = [
//     {'code': 'B', 'title': 'BRIDGE VISUAL INSPECTION (RECORD & FORM)'},
//     {'code': 'C', 'title': 'CULVERT VISUAL INSPECTION (RECORD & FORM)'},
//     {'code': 'G', 'title': 'GANTRY SIGN VISUAL INSPECTION (RECORD & FORM)'},
//     {'code': 'R', 'title': 'RETAINING WALL VISUAL INSPECTION (RECORD & FORM)'},
//     {'code': 'X', 'title': 'Coming soon'},
//     {'code': 'H', 'title': 'Coming soon'},
//     {'code': 'M', 'title': 'Coming soon'},
//     {'code': 'FC', 'title': 'Coming soon'},
//     {'code': 'FD', 'title': 'Coming soon'},
//     {'code': 'F1', 'title': 'Coming soon'},
//     {'code': 'F2', 'title': 'Coming soon'},
//     {'code': 'F3', 'title': 'Coming soon'},
//     {'code': 'F4', 'title': 'Coming soon'},
//     {'code': 'F5', 'title': 'Coming soon'},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     // 2. Calculate the slice of data for the current page
//     final int startIndex = _currentPage * _itemsPerPage;
//     final int endIndex = (startIndex + _itemsPerPage < formTypes.length)
//         ? startIndex + _itemsPerPage
//         : formTypes.length;
//
//     // Get the actual list to display
//     final List<Map<String, String>> currentForms =
//         formTypes.sublist(startIndex, endIndex);
//
//     // Calculate total pages needed
//     final int totalPages = (formTypes.length / _itemsPerPage).ceil();
//
//     return Container(
//       color: const Color(0xffe9f3fd),
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           // 3. The Grid List (Takes up remaining space)
//           Expanded(
//             child: RepaintBoundary(
//               child: GridView.count(
//                 crossAxisCount: 3,
//                 children: currentForms.map((type) {
//                   return formDepotButton(
//                     code: type['code']!.startsWith('FORM')
//                         ? type['code']!
//                         : 'FORM ${type['code']}',
//                     title: type['title'] ?? '',
//                     onPressed: () {
//                       if (type['title'] == 'Coming soon') {
//                         Get.snackbar(
//                           "Notice",
//                           "This feature is coming soon !",
//                           colorText: Colors.black,
//                           margin: const EdgeInsets.all(10),
//                           duration: const Duration(seconds: 2),
//                         );
//                       } else {
//                         // Normal navigation for active forms
//                         Get.toNamed(
//                           '/main_listing_form',
//                           arguments: {
//                             'formType': type['code'],
//                             'formTitle': type['title']
//                           },
//                         );
//                       }
//                     },
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           // 4. Pagination Controls (Bottom Row)
//           RepaintBoundary(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(totalPages, (index) {
//                 bool isActive = _currentPage == index;
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5),
//                   child: NeumorphicButton(
//                     onPressed: () {
//                       setState(() {
//                         _currentPage = index;
//                       });
//                     },
//                     style: NeumorphicStyle(
//                       shape: NeumorphicShape.flat,
//                       boxShape:
//                           NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
//                       depth: isActive ? -2 : 5, // Emboss effect if active
//                       intensity: 0.8,
//                       // Use Amber/Yellow for active, Default color for inactive
//                       color: isActive ? Colors.amber : const Color(0xffe9f3fd),
//                     ),
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//                     child: Text(
//                       "${index + 1}",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: isActive ? Colors.black : Colors.grey[700],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//           const SizedBox(height: 20), // Extra padding at bottom
//         ],
//       ),
//     );
//   }
// }
//
// // Reused your existing button widget
// Widget formDepotButton({
//   required String code,
//   required String title,
//   Function()? onPressed,
// }) {
//   return NeumorphicButton(
//     onPressed: onPressed,
//     style: NeumorphicStyle(
//       shape: NeumorphicShape.flat,
//       depth: 5,
//       intensity: 0.8,
//       boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
//     ),
//     padding: EdgeInsets.zero,
//     margin: const EdgeInsets.all(10),
//     child: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             code,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//               color: Colors.black,
//               letterSpacing: 1,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 10,
//               color: Colors.black,
//               letterSpacing: 1,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

class FormDepotScreen extends StatefulWidget {
  const FormDepotScreen({super.key});

  @override
  State<FormDepotScreen> createState() => _FormDepotScreenState();
}

class _FormDepotScreenState extends State<FormDepotScreen> {
  // 1. Pagination State Variables
  int _currentPage = 0;
  final int _itemsPerPage = 7;

  final List<Map<String, String>> formTypes = [
    {'code': 'B', 'title': 'BRIDGE VISUAL INSPECTION (RECORD & FORM)'},
    {'code': 'C', 'title': 'CULVERT VISUAL INSPECTION (RECORD & FORM)'},
    {'code': 'G', 'title': 'GANTRY SIGN VISUAL INSPECTION (RECORD & FORM)'},
    {'code': 'R', 'title': 'RETAINING WALL VISUAL INSPECTION (RECORD & FORM)'},
    {'code': 'X', 'title': 'Coming soon'},
    {'code': 'H', 'title': 'Coming soon'},
    {'code': 'M', 'title': 'Coming soon'},
    {'code': 'FC', 'title': 'Coming soon'},
    {'code': 'FD', 'title': 'Coming soon'},
    {'code': 'F1', 'title': 'Coming soon'},
    {'code': 'F2', 'title': 'Coming soon'},
    {'code': 'F3', 'title': 'Coming soon'},
    {'code': 'F4', 'title': 'Coming soon'},
    {'code': 'F5', 'title': 'Coming soon'},
  ];

  @override
  Widget build(BuildContext context) {
    // 2. Calculate the slice of data for the current page
    final int startIndex = _currentPage * _itemsPerPage;
    final int endIndex = (startIndex + _itemsPerPage < formTypes.length)
        ? startIndex + _itemsPerPage
        : formTypes.length;

    // Get the actual list to display
    final List<Map<String, String>> currentForms =
        formTypes.sublist(startIndex, endIndex);

    // Calculate total pages needed
    final int totalPages = (formTypes.length / _itemsPerPage).ceil();

    return Container(
      color: const Color(0xffe9f3fd),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // 3. The Grid List (Takes up remaining space)
          Expanded(
            child: RepaintBoundary(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columnCount = constraints.maxWidth < 600
                      ? 2
                      : constraints.maxWidth >= 1200
                          ? 4
                          : 3;

                  return GridView.count(
                    crossAxisCount: columnCount,
                    children: currentForms.map((type) {
                      return formDepotButton(
                        code: type['code']!.startsWith('FORM')
                            ? type['code']!
                            : 'FORM ${type['code']}',
                        title: type['title'] ?? '',
                        onPressed: () {
                          if (type['title'] == 'Coming soon') {
                            Get.snackbar(
                              "Notice",
                              "This feature is coming soon !",
                              colorText: Colors.black,
                              margin: const EdgeInsets.all(10),
                              duration: const Duration(seconds: 2),
                            );
                          } else {
                            // Normal navigation for active forms
                            Get.toNamed(
                              '/main_listing_form',
                              arguments: {
                                'formType': type['code'],
                                'formTitle': type['title']
                              },
                            );
                          }
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 4. Pagination Controls (Bottom Row)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (index) {
              final bool isActive = _currentPage == index;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: NeumorphicButton(
                  onPressed: () {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                    depth: isActive ? -2 : 5,
                    intensity: 0.8,
                    color: isActive ? Colors.amber : const Color(0xffe9f3fd),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.black : Colors.grey[700],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20), // Extra padding at bottom
        ],
      ),
    );
  }
}

Widget formDepotButton({
  required String code,
  required String title,
  Function()? onPressed,
}) {
  return NeumorphicButton(
    onPressed: onPressed,
    style: NeumorphicStyle(
      shape: NeumorphicShape.flat,
      depth: 5,
      intensity: 0.8,
      color: const Color(0xffe3e8ef),
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
    ),
    padding: EdgeInsets.zero,
    margin: const EdgeInsets.all(6),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            code,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    ),
  );
}
