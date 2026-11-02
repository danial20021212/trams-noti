import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SimpleDatePicker extends StatelessWidget {
  final Function(DateTime)? onSubmit;
  final Function()? onCancel;
  final DateRangePickerView view;
  const SimpleDatePicker(
      {super.key,
      this.view = DateRangePickerView.month,
      this.onSubmit,
      this.onCancel});

  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      showActionButtons: true,
      view: view,
      allowViewNavigation: false,
      selectionColor: Colors.deepPurpleAccent,
      selectionShape: DateRangePickerSelectionShape.rectangle,
      selectionTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      headerStyle: const DateRangePickerHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          fontSize: 18,
          color: Color(0xff130438),
        ),
      ),
      headerHeight: 70,
      monthCellStyle: const DateRangePickerMonthCellStyle(
          cellDecoration: _MonthCellDecoration(
            backgroundColor: Color(0xfff7f4ff),
            showIndicator: false,
          ),
          todayCellDecoration: _MonthCellDecoration(
            borderColor: Colors.deepPurpleAccent,
            backgroundColor: Color(0xfff7f4ff),
            showIndicator: false,
          ),
          specialDatesDecoration: _MonthCellDecoration(
            backgroundColor: Color(0xfff7f4ff),
            showIndicator: true,
          ),
          disabledDatesTextStyle: TextStyle(
            color: Color(0xffe2d7fe),
          ),
          weekendTextStyle: TextStyle(
            color: Colors.deepPurpleAccent,
          ),
          textStyle: TextStyle(
            color: Color(0xff130438),
            fontSize: 14,
          ),
          specialDatesTextStyle:
              TextStyle(color: Color(0xff130438), fontSize: 14),
          todayTextStyle:
              TextStyle(color: Colors.deepPurpleAccent, fontSize: 14)),
      yearCellStyle: DateRangePickerYearCellStyle(
        todayTextStyle:
            const TextStyle(color: Colors.deepPurpleAccent, fontSize: 14),
        textStyle: const TextStyle(color: Color(0xff130438), fontSize: 14),
        disabledDatesTextStyle: const TextStyle(
          color: Color(0xffe2d7fe),
        ),
        leadingDatesTextStyle: TextStyle(
          color: const Color(0xff130438).withOpacity(0.5),
          fontSize: 14,
        ),
      ),
      showNavigationArrow: true,
      todayHighlightColor: Colors.deepPurpleAccent,
      monthViewSettings: const DateRangePickerMonthViewSettings(
        firstDayOfWeek: 1,
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: TextStyle(
              fontSize: 10,
              color: Color(0xff130438),
              fontWeight: FontWeight.w600),
        ),
        dayFormat: 'EEE',
      ),
      onCancel: cancel,
      onSubmit: submit,
    );
  }

  void submit(Object? value) {
    if (onSubmit != null || value != null) onSubmit!(value! as DateTime);
  }

  void cancel() {
    if (onCancel != null) onCancel!();
  }
}

class _MonthCellDecoration extends Decoration {
  const _MonthCellDecoration({
    this.borderColor,
    this.backgroundColor,
    required this.showIndicator,
    // ignore: unused_element
    this.indicatorColor,
  });

  final Color? borderColor;
  final Color? backgroundColor;
  final bool showIndicator;
  final Color? indicatorColor;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MonthCellDecorationPainter(
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      showIndicator: showIndicator,
      indicatorColor: indicatorColor,
    );
  }
}

class _MonthCellDecorationPainter extends BoxPainter {
  _MonthCellDecorationPainter({
    this.borderColor,
    this.backgroundColor,
    required this.showIndicator,
    this.indicatorColor,
  });

  final Color? borderColor;
  final Color? backgroundColor;
  final bool showIndicator;
  final Color? indicatorColor;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect bounds = offset & configuration.size!;
    _drawDecoration(canvas, bounds);
  }

  void _drawDecoration(Canvas canvas, Rect bounds) {
    final Paint paint = Paint()..color = backgroundColor!;
    canvas.drawRRect(
        RRect.fromRectAndRadius(bounds, const Radius.circular(5)), paint);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    if (borderColor != null) {
      paint.color = borderColor!;
      canvas.drawRRect(
          RRect.fromRectAndRadius(bounds, const Radius.circular(5)), paint);
    }

    if (showIndicator) {
      paint.color = indicatorColor!;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(bounds.right - 6, bounds.top + 6), 2.5, paint);
    }
  }
}
