import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../widgets/custom_text.dart';
import '../../../models/task.dart';

class CalendarWidget extends StatefulWidget {
  final List<Task> events;
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  const CalendarWidget({Key key, this.events, this.onDaySelected})
      : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.secondary;
    final textcolor = Theme.of(context).textTheme.button.color;
    final borderRadius = BorderRadius.circular(5);

    return Container(
      width: getValueForScreenType<double>(
          context: context, mobile: null, desktop: 440),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(20),
      padding: EdgeInsets.all(
        getValueForScreenType<double>(
            context: context, mobile: 10, tablet: 10, desktop: 50),
      ),
      child: TableCalendar<Task>(
        locale: Get.locale.languageCode,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(color: textcolor, height: 1, fontSize: 12),
          weekdayStyle: TextStyle(color: textcolor, height: 1, fontSize: 12),
        ),
        focusedDay: selectedDate,
        firstDay: DateTime.now().subtract(const Duration(days: 1)),
        lastDay: DateTime(2050),
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          weekendTextStyle: TextStyle(color: textcolor),
          selectedDecoration: BoxDecoration(color: selectedColor),
          todayDecoration: BoxDecoration(
            color: selectedColor.withOpacity(0.3),
            shape: BoxShape.rectangle,
            borderRadius: borderRadius,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            Widget marker;
            if (events.isNotEmpty) {
              marker = Positioned(
                bottom: 5,
                child: _buildEventsMarkerNumber(events.length),
              );
            }
            return marker;
          },
        ),
        eventLoader: (day) {
          return widget.events
              .where((task) => isSameDay(task.dueDate, day))
              .toList();
        },
        selectedDayPredicate: (day) {
          return isSameDay(day, selectedDate);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            selectedDate = selectedDay;
          });
          widget.onDaySelected(selectedDay, focusedDay);
        },
      ),
    );
  }

  ///To indicate that there is some events on that day
  Widget _buildEventsMarkerNumber(int tasksNo) {
    return Center(
      child: CustomText(text: tasksNo.toString(), textType: TextType.smallest),
    );
  }
}
