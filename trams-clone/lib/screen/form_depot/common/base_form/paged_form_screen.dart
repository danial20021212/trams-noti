import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../../components/Neumorphic/navbar.dart';
import '../../../../widget/form_depot/basic/button.dart';
import '../../../../widget/form_depot/dialog/warning_dialog.dart';

typedef PagedFormAction = Future<void> Function();

/// Shared shell for Form Depot flows with progress and one final action.
///
/// Layout values are configurable so existing record and review screens can
/// share navigation without changing their footer dimensions or spacing.
class PagedFormScreen extends StatefulWidget {
  const PagedFormScreen({
    super.key,
    required this.title,
    required this.exitDialogTitle,
    required this.pages,
    required this.onPageControllerReady,
    required this.lastButtonTitle,
    required this.onLastPage,
    this.footerHeight,
    this.footerPadding = EdgeInsets.zero,
    this.lastButtonTitleBuilder,
    this.onExit,
    this.animateForward = true,
    this.animateBack = true,
  });

  final String title;
  final String exitDialogTitle;
  final List<Widget> pages;
  final ValueChanged<PageController> onPageControllerReady;
  final String lastButtonTitle;
  final String Function()? lastButtonTitleBuilder;
  final PagedFormAction onLastPage;
  final double? footerHeight;
  final EdgeInsetsGeometry footerPadding;
  final VoidCallback? onExit;
  final bool animateForward;
  final bool animateBack;

  @override
  State<PagedFormScreen> createState() => _PagedFormScreenState();
}

class _PagedFormScreenState extends State<PagedFormScreen>
    with TickerProviderStateMixin {
  late final PageController _pageViewController;
  late final TabController _tabController;
  late final int _pageLength;

  int _currentPageIndex = 0;
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _pageLength = widget.pages.length;
    _pageViewController = PageController();
    _tabController = TabController(length: _pageLength, vsync: this);
    widget.onPageControllerReady(_pageViewController);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom == 0;
    return Scaffold(
      appBar: NeumorphicNavBar(
        title: widget.title,
        showDrawer: false,
        color: const Color(0xfff3f8fe),
        leading: NeumorphicButton(
          padding: EdgeInsets.zero,
          style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
          ),
          onPressed: _handleBack,
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Neumorphic(
          style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.rect(),
            color: Color(0xffe9f3fd),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              PageView(
                controller: _pageViewController,
                onPageChanged: _handlePageViewChanged,
                children: widget.pages,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                child: NeumorphicProgress(
                  percent: (_currentPageIndex + 1).toDouble() /
                      _pageLength.toDouble(),
                  height: 5.0,
                ),
              ),
              Visibility(
                key: const ValueKey('paged-form-bottom-controls'),
                visible: _keyboardVisible,
                child: Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      key: const ValueKey('paged-form-footer'),
                      alignment: Alignment.center,
                      height: widget.footerHeight,
                      color: const Color(0xfff3f8fe),
                      child: Padding(
                        padding: widget.footerPadding,
                        child: _buildBottomButton(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    if (_currentPageIndex == _pageLength - 1) {
      return button(
        widget.lastButtonTitleBuilder?.call() ?? widget.lastButtonTitle,
        widget.onLastPage,
      );
    }

    return button('Continue', () async {
      if (widget.animateForward) {
        _pageViewController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        _pageViewController.jumpToPage(_currentPageIndex + 1);
      }
    });
  }

  void _handleBack() {
    if (_currentPageIndex == 0) {
      showDialog<void>(
        context: context,
        builder: (context) => WarningDialog(
          title: widget.exitDialogTitle,
          onPressed: () async {
            Navigator.pop(context);
            widget.onExit?.call();
            Get.back();
          },
        ),
      );
      return;
    }

    if (widget.animateBack) {
      _pageViewController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _pageViewController.jumpToPage(_currentPageIndex - 1);
    }
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }
}
