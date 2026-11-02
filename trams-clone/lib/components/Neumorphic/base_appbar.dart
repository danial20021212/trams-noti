import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BaseNeumorphicAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  static const toolbarHeight = kToolbarHeight + 12 * 2;
  static const defaultSpacing = 4.0;
  static const buttonExtent = 44.0;

  final Widget? title;

  final Widget? leading;

  final bool? centerTitle;

  final List<Widget>? actions;

  final bool automaticallyImplyLeading;

  final double titleSpacing;

  final double actionSpacing;

  final Color? color;

  final IconThemeData? iconTheme;

  @override
  final Size preferredSize;

  final NeumorphicStyle? buttonStyle;

  final EdgeInsets? buttonPadding;

  final TextStyle? textStyle;

  final double padding;

  const BaseNeumorphicAppBar({
    Key? key,
    this.title,
    this.buttonPadding,
    this.buttonStyle,
    this.iconTheme,
    this.color,
    this.actions,
    this.textStyle,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.actionSpacing = defaultSpacing,
    this.padding = 12,
  })  : preferredSize = const Size.fromHeight(toolbarHeight),
        super(key: key);

  @override
  NeumorphicAppBarState createState() => NeumorphicAppBarState();

  bool _getEffectiveCenterTitle(ThemeData theme, NeumorphicThemeData nTheme) {
    if (centerTitle != null || nTheme.appBarTheme.centerTitle != null) {
      return centerTitle ?? nTheme.appBarTheme.centerTitle!;
    }
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return actions == null || actions!.length < 2;
    }
  }
}

class NeumorphicAppBarTheme extends InheritedWidget {
  // ignore: overridden_fields, annotate_overrides
  final Widget child;

  const NeumorphicAppBarTheme({super.key, required this.child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static NeumorphicAppBarTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }
}

class NeumorphicAppBarState extends State<BaseNeumorphicAppBar> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final nTheme = NeumorphicTheme.of(context);
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;

    Widget? leading = widget.leading;
    if (leading == null && widget.automaticallyImplyLeading) {
      if (hasDrawer) {
        leading = NeumorphicButton(
          padding: widget.buttonPadding,
          style: widget.buttonStyle,
          onPressed: _handleDrawerButton,
          //tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          child: nTheme?.current?.appBarTheme.icons.menuIcon,
        );
      } else {
        if (canPop) {
          leading = useCloseButton
              ? NeumorphicCloseButton(
            padding: widget.buttonPadding,
            style: widget.buttonStyle,
          )
              : NeumorphicBackButton(
            padding: widget.buttonPadding,
            style: widget.buttonStyle,
          );
        }
      }
    }
    if (leading != null) {
      leading = SizedBox(
        width: kToolbarHeight,
        height: kToolbarHeight,
        child: Center(
          child: SizedBox.square(
            dimension: BaseNeumorphicAppBar.buttonExtent,
            child: leading,
          ),
        ),
      );
    }

    Widget? title = widget.title;
    if (title != null) {
      //final AppBarThemeData appBarTheme = AppBarTheme.of(context);
      title = DefaultTextStyle(
        // ignore: deprecated_member_use
        style: (Theme.of(context).textTheme.headlineSmall ??
            Theme.of(context).textTheme.headlineSmall!)
            .merge(widget.textStyle ?? nTheme?.current?.appBarTheme.textStyle),
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: title,
      );
    }

    Widget? actions;
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      actions = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.actions!
            .map((child) => Padding(
          padding: EdgeInsets.only(left: widget.actionSpacing),
          child: SizedBox(
            width: kToolbarHeight,
            height: kToolbarHeight,
            child: Center(
              child: SizedBox.square(
                dimension: BaseNeumorphicAppBar.buttonExtent,
                child: child,
              ),
            ),
          ),
        ))
            .toList(growable: false),
      );
    } else if (hasEndDrawer) {
      actions = SizedBox(
        width: kToolbarHeight,
        height: kToolbarHeight,
        child: Center(
          child: SizedBox.square(
            dimension: BaseNeumorphicAppBar.buttonExtent,
            child: NeumorphicButton(
              padding: widget.buttonPadding,
              style: widget.buttonStyle,
              onPressed: _handleDrawerButtonEnd,
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              child: nTheme?.current?.appBarTheme.icons.menuIcon,
            ),
          ),
        ),
      );
    }
    return Container(
      color: widget.color ?? nTheme?.current?.appBarTheme.color,
      child: SafeArea(
        bottom: false,
        child: NeumorphicAppBarTheme(
          child: Padding(
            padding: EdgeInsets.all(widget.padding),
            child: IconTheme(
              data: widget.iconTheme ??
                  nTheme?.current?.appBarTheme.iconTheme ??
                  nTheme?.current?.iconTheme ??
                  const IconThemeData(),
              child: NavigationToolbar(
                leading: leading,
                middle: title,
                trailing: actions,
                centerMiddle:
                widget._getEffectiveCenterTitle(theme, nTheme!.current!),
                middleSpacing: widget.titleSpacing,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDrawerButton() {
    Scaffold.of(context).openDrawer();
  }

  void _handleDrawerButtonEnd() {
    Scaffold.of(context).openEndDrawer();
  }
}
