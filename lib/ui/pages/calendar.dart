import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_responsive/ui/pages/tasks_tab.dart';

import '../../models/task.dart';
import '../widgets/custom_text.dart';
import '../widgets/createTask/creat_task.dart';
import '../../controllers/task_controller.dart';

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
          _events.assignAll(
              taskController.tasks.where((t) => !t.isFinished).toList());
          _selectedEvents = _events
              .where((task) => isSameDay(task.dueDate, selectedDate))
              .toList();

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Center(
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
                        titleBlock: 'There is number tasks on this day'
                            .trParams({'number': '${_selectedEvents.length}'}),
                        scrollHieght: MediaQuery.of(context).size.height * 0.8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => updateTask(context: context),
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

    return Container(
      width: getValueForScreenType<double>(
          context: context, mobile: null, desktop: 440),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(20),
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
        firstDay: DateTime.now().subtract(Duration(days: 1)),
        lastDay: DateTime(2050),
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          weekendTextStyle: TextStyle(color: textcolor),
          selectedDecoration: BoxDecoration(
            color: selectedColor,
            // shape: BoxShape.rectangle,
            // borderRadius: borderRadius,
          ),
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
