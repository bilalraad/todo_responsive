import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_responsive/ui/pages/tasks_tab.dart';

import '../../models/task.dart';
import '../widgets/custom_text.dart';
import '../widgets/createTask/creat_task.dart';
import '../../controllers/task_controller.dart';
import '../../controllers/theme_controller.dart';

class CalendartTap extends StatefulWidget {
  const CalendartTap({Key key}) : super(key: key);

  @override
  _CalendartTapState createState() => _CalendartTapState();
}

class _CalendartTapState extends State<CalendartTap> {
  List<Task> _events = [];
  List<Task> _selectedEvents = [];
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
        id: 'calendar',
        builder: (taskController) {
          _events.assignAll(taskController.tasks);
          _selectedEvents = _events
              .where((task) => isSameDay(task.dueDate, selectedDate))
              .toList();

          return Scaffold(
            body: Center(
              child: Wrap(
                spacing: 40,
                children: [
                  CalendarWidget(
                    events: _events,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        selectedDate = selectedDay;
                      });
                    },
                  ),
                  TaskList(
                    tasks: _selectedEvents,
                    titleBlock:
                        'There is ${_selectedEvents.length} tasks on this day',
                    scrollHieght: MediaQuery.of(context).size.height * 0.8,
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => updateTaskModalBottomSheet(context: context),
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(Icons.add, color: Colors.white),
            ),
          );
        });
  }
}

class CalendarWidget extends StatefulWidget {
  final List<Task> events;
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  CalendarWidget({this.events, this.onDaySelected});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).accentColor;
    final textcolor = Theme.of(context).textTheme.button.color;
    final borderRadius = BorderRadius.circular(5);
    final _locale = SettingsController.to.locale;

    return Container(
      width: getValueForScreenType<double>(
          context: context, mobile: null, desktop: 440),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(50),
      child: TableCalendar(
        daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle(
              color: textcolor,
              fontFamily: _locale.languageCode == 'ar' ? 'Cairo' : 'OpenSans',
            ),
            weekdayStyle: TextStyle(
              color: textcolor,
              fontFamily: _locale.languageCode == 'ar' ? 'Cairo' : 'OpenSans',
            )),
        focusedDay: selectedDate,
        firstDay: DateTime.now().subtract(Duration(days: 1)),
        lastDay: DateTime(2050),
        calendarStyle: CalendarStyle(
          // canMarkersOverflow: true,
          isTodayHighlighted: true,
          weekendTextStyle: TextStyle(
            color: textcolor,
            fontFamily: _locale.languageCode == 'ar' ? 'Cairo' : 'OpenSans',
          ),
          selectedDecoration:
              BoxDecoration(color: selectedColor, borderRadius: borderRadius),
          todayDecoration: BoxDecoration(
              color: selectedColor.withOpacity(0.3),
              borderRadius: borderRadius),
        ),
        headerStyle:
            const HeaderStyle(formatButtonVisible: false, titleCentered: true),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            Widget marker;
            if (events.isNotEmpty) {
              marker = Positioned(
                bottom: 8,
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
      child: CustomText(text: tasksNo.toString(), fontSize: 10.0),
    );
  }
}
