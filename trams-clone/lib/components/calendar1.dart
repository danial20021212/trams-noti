// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';

// class Calendar1 extends StatelessWidget {
//   final CalendarController? controller;
//   final CalendarView view;
//   final List<CalendarView>? allowedViews;
//   final CalendarDataSource<Object?>? dataSource;
//   final Color backgroundColor;
//   final void Function(CalendarTapDetails)? onTap;

//   const Calendar1({
//     super.key,
//     this.controller,
//     this.view = CalendarView.day,
//     this.dataSource,
//     this.allowedViews,
//     this.onTap,
//     this.backgroundColor = const Color(0xffe9f3fd),
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SfCalendar(
//       controller: controller,
//       dataSource: dataSource,
//       showNavigationArrow: true,
//       showDatePickerButton: true,
//       allowedViews: allowedViews,
//       view: view,
//       onTap: onTap,
//       backgroundColor: backgroundColor,
//       selectionDecoration: const BoxDecoration(
//         backgroundBlendMode: BlendMode.multiply,
//         color: Color.fromARGB(255, 227, 242, 253),
//       ),
//       headerHeight: 60,
//       headerStyle: CalendarHeaderStyle(
//         textStyle: const TextStyle(
//           fontSize: 20,
//         ),
//         backgroundColor: backgroundColor,
//       ),
//       viewHeaderStyle: ViewHeaderStyle(
//         backgroundColor: backgroundColor,
//       ),
//       scheduleViewSettings: ScheduleViewSettings(
//         monthHeaderSettings: MonthHeaderSettings(
//           monthTextStyle: const TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//           backgroundColor: Colors.blue.shade50,
//         ),
//       ),
//       monthViewSettings: MonthViewSettings(
//         showAgenda: true,
//         dayFormat: 'EEE',
//         agendaItemHeight: Get.height * 0.1,
//         agendaStyle: AgendaStyle(
//           backgroundColor: backgroundColor,
//           dayTextStyle: const TextStyle(
//             color: Colors.orange,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//           dateTextStyle: TextStyle(
//             color: Colors.black,
//             fontSize: 26,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
//       ),
//       monthCellBuilder: (context, details) {
//         return Container(
//           color: backgroundColor,
//           alignment: Alignment.center,
//           child: Text(
//             details.date.day.toString(),
//           ),
//         );
//       },
//     );
//   }
// }
