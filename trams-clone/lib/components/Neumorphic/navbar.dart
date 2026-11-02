import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'base_appbar.dart';

class NeumorphicNavBar extends StatefulWidget implements PreferredSizeWidget {
  static const toolbarHeight = kToolbarHeight + 12 * 2;
  final String? title;
  final Widget? logo;
  final List<Widget>? actions;
  final bool showDrawer;
  final Color? color;
  final Widget? leading;

  const NeumorphicNavBar({
    Key? key,
    this.title,
    this.actions,
    this.logo,
    this.color,
    this.showDrawer = true,
    this.leading,
  })  : preferredSize = const Size.fromHeight(toolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<NeumorphicNavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NeumorphicNavBar> {
  @override
  Widget build(BuildContext context) {
    return BaseNeumorphicAppBar(
      color: widget.color,
      buttonPadding: EdgeInsets.zero,
      buttonStyle: const NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Colors.black54,
        size: 20,
      ),
      automaticallyImplyLeading: widget.showDrawer,
      leading: widget.leading ??
          (widget.showDrawer
              ? null
              : NeumorphicButton(
                  padding: EdgeInsets.zero,
                  style: const NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.circle(),
                  ),
                  child: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
      title: widget.title != null
          ? Text(
              widget.title!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          : widget.logo!,
      actions: widget.actions,
    );
  }
}
