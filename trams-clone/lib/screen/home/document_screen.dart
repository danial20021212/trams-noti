import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tram/controller/home/document_controller.dart';
import 'package:tram/model/basic/document/document_list_model.dart';

import '../../components/Neumorphic/card_2.dart';
import '../../constant/path.dart';

class DocumemntScreen extends StatefulWidget {
  const DocumemntScreen({super.key});

  @override
  State<DocumemntScreen> createState() => _DocumentState();
}

class _DocumentState extends State<DocumemntScreen> {
  final controller = Get.find<DocumentController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 20,
        left: 5,
        right: 5,
      ),
      color: const Color(0xffe9f3fd),
      width: Get.width,
      child: PagedListView<int, DocumentModel>(
        pagingController: controller.pagingController,
        builderDelegate: PagedChildBuilderDelegate<DocumentModel>(
          animateTransitions: true,
          transitionDuration: const Duration(milliseconds: 500),
          itemBuilder: (context, item, index) => _listItem(
            context,
            item: item,
          ),
          // noMoreItemsIndicatorBuilder: (context) => noMoreItems(),
        ),
      ),
    );
  }

  Widget _listItem(BuildContext context, {required DocumentModel item}) {
    return NeumorphicCard2(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.fromLTRB(
        10,
        10,
        10,
        10,
      ),
      title: item.documentName,
      subtitle: item.uploadDate,
      titleStyle: const TextStyle(
        fontSize: 18,
        color: Color.fromARGB(255, 68, 65, 118),
        fontWeight: FontWeight.bold,
      ),
      subtitleStyle: const TextStyle(
        fontSize: 15,
        color: Color.fromARGB(255, 64, 64, 95),
        fontWeight: FontWeight.w400,
      ),
      leading: _tileIcon(),
      cardColor: const Color(0xffd6e3f4),
      onPressed: () {
        controller.view(item);
      },
    );
  }
}

Widget _tileIcon() {
  return Container(
    margin: const EdgeInsets.only(
      right: 10,
      left: 20,
      bottom: 0,
      top: 0,
    ),
    padding: EdgeInsets.zero,
    child: Image.asset(
      AssetStorage.document,
      width: 100,
      height: 60,
    ),
  );
}
