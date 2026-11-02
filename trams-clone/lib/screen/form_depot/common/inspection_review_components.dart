import 'package:flutter/material.dart';

const Color inspectionReviewBaseColor = Color(0xFFE3E8EF);

class InspectionReviewBackButton extends StatefulWidget {
  const InspectionReviewBackButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.arrow_back,
    this.iconSize = 24.0,
    this.padding = const EdgeInsets.all(12),
    this.baseColor = inspectionReviewBaseColor,
    this.iconColor = Colors.black,
    this.shadowOpacity = 0.25,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final Color baseColor;
  final Color iconColor;
  final double shadowOpacity;

  @override
  State<InspectionReviewBackButton> createState() =>
      _InspectionReviewBackButtonState();
}

class _InspectionReviewBackButtonState
    extends State<InspectionReviewBackButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.baseColor,
          shape: BoxShape.circle,
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.blueGrey.withValues(
                      alpha: widget.shadowOpacity,
                    ),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Icon(
          widget.icon,
          size: widget.iconSize,
          color: widget.iconColor,
        ),
      ),
    );
  }
}

class InspectionDateBanner extends StatelessWidget {
  const InspectionDateBanner({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 8,
              offset: Offset(-4, -4),
            ),
          ],
        ),
        child: Text(
          'Inspection Date: $date',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class InspectionReviewGroup extends StatelessWidget {
  const InspectionReviewGroup({
    super.key,
    required this.headerTitle,
    required this.children,
    required this.initiallyExpanded,
    this.baseColor = inspectionReviewBaseColor,
  });

  final String headerTitle;
  final List<Widget> children;
  final bool initiallyExpanded;
  final Color baseColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 8,
              offset: Offset(-4, -4),
            ),
          ],
        ),
        child: Material(
          color: baseColor,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: initiallyExpanded,
              iconColor: Colors.black87,
              collapsedIconColor: Colors.black87,
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              title: Text(
                headerTitle.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              children: [
                Container(
                  color: const Color(0xFFF0F4F8),
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                  child: Column(children: children),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InspectionReviewRetryPanel extends StatelessWidget {
  const InspectionReviewRetryPanel({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load data'),
            TextButton(
              onPressed: onRetry,
              child: const Text(
                'Retry ?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
