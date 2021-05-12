import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../models/task.dart';
import '../../widgets/task_list.dart';
import '../../../controllers/task_controller.dart';
import '../../widgets/createTask/creat_task.dart';

import './calendar_widget.dart';

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
