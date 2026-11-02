import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? logo;
  final bool showDrawer;

  const NavBar({
    Key? key,
    this.title,
    this.logo,
    this.showDrawer = true,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: widget.title != null ? Text(widget.title!) : widget.logo,
      automaticallyImplyLeading: widget.showDrawer,
      leading: widget.showDrawer
          ? null
          : IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                IconData(
                  0xf4fd,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage,
                ),
                size: 30,
              ),
            ),
    );
  }
}
