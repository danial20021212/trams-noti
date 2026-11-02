import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../../components/Neumorphic/navbar.dart';
import '../../../../model/shared/loader_state_model.dart';
import '../../../../widget/form_depot/basic/button.dart';
import '../../../../widget/form_depot/dialog/warning_dialog.dart';
import '../../../../widget/form_depot/form_depot_text_scope.dart';

typedef InspectionAction = Future<void> Function();

/// Shared visual shell for a Form Depot inspection editor.
///
/// Form-specific state, validation, persistence, and submission stay in the
/// owning controller. This widget only centralizes the layout and navigation
/// that Forms B, C, G, and R share.
class InspectionFormScreen extends StatefulWidget {
  const InspectionFormScreen({
    super.key,
    required this.pages,
    required this.exitDialogTitle,
    required this.onPageControllerReady,
    required this.onSaveDraft,
    required this.onSubmit,
    required this.submitState,
    this.saveDraftState,
    this.title = 'New Inspection',
  });

  final List<Widget> pages;
  final String title;
  final String exitDialogTitle;
  final ValueChanged<PageController> onPageControllerReady;
  final InspectionAction onSaveDraft;
  final InspectionAction onSubmit;
  final Rx<LoaderState> submitState;
  final Rx<LoaderState>? saveDraftState;

  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreenState();
}

class _InspectionFormScreenState extends State<InspectionFormScreen>
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
      body: SafeArea(child: _buildForm()),
    );
  }

  Widget _buildForm() {
    return Neumorphic(
      style: const NeumorphicStyle(
        boxShape: NeumorphicBoxShape.rect(),
        color: Color(0xffe9f3fd),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            PageView(
              controller: _pageViewController,
              onPageChanged: _handlePageViewChanged,
              children: widget.pages,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
              child: NeumorphicProgress(
                percent:
                    (_currentPageIndex + 1).toDouble() / _pageLength.toDouble(),
                height: 5.0,
              ),
            ),
            Visibility(
              key: const ValueKey('inspection-bottom-controls'),
              visible: _keyboardVisible,
              child: Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    alignment: Alignment.center,
                    color: const Color(0xfff3f8fe),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildBottomButton(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    if (_currentPageIndex == _pageLength - 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(
            'Save as draft',
            widget.onSaveDraft,
            color: Colors.orangeAccent,
            state: widget.saveDraftState,
          ),
          button(
            'Submit',
            _showSubmitConfirmDialog,
            state: widget.submitState,
          ),
        ],
      );
    }

    return button('Continue', () async {
      _pageViewController.jumpToPage(_currentPageIndex + 1);
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
            Get.back();
          },
        ),
      );
      return;
    }

    _pageViewController.jumpToPage(_currentPageIndex - 1);
  }

  Future<void> _showSubmitConfirmDialog() async {
    await Get.dialog<void>(
      FormDepotTextScope(
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            width: Get.width * 0.8,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xfff3f8fe),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Submit Inspection?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Are you sure you want to finalize and submit this inspection to the server? Make sure all details are correct.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NeumorphicButton(
                      onPressed: () => Get.back(),
                      style: NeumorphicStyle(
                        depth: 2,
                        color: Colors.grey[300],
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      child: const Text(
                        'Review',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    NeumorphicButton(
                      onPressed: () async {
                        Get.back();
                        await widget.onSubmit();
                      },
                      style: NeumorphicStyle(
                        depth: 4,
                        color: Colors.blueAccent,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }
}
