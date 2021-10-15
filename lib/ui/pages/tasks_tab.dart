import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/task.dart';
import '../widgets/task_list.dart';
import '../widgets/custom_text.dart';
import '../widgets/createTask/creat_task.dart';
import '../../controllers/task_controller.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({Key key}) : super(key: key);
  @override
  _TasksTabState createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  double _height;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;

    return GetBuilder<TaskController>(
        id: 'tasks',
        builder: (tc) {
          List<Task> today = [], tomorrow = [], later = [], sTasks = tc.tasks;

          if (sTasks.isNotEmpty) {
            for (var ti in sTasks) {
              if (isSameDay(ti.dueDate, DateTime.now())) {
                today.add(ti);
              } else if (isSameDay(
                  ti.dueDate, DateTime.now().add(const Duration(days: 1)))) {
                tomorrow.add(ti);
              } else {
                later.add(ti);
              }
            }
          }

          Widget _checkIfEmpty({Widget child}) {
            return sTasks.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: _height * 0.4),
                    alignment: Alignment.center,
                    child: const CustomText(
                      text: 'There is no tasks here yet',
                      textType: TextType.title,
                    ),
                  )
                : child;
          }

          Widget _body() {
            return SafeArea(
              child: Center(
                heightFactor: 1,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _checkIfEmpty(
                    child: Wrap(
                      spacing: 100,
                      children: [
                        if (today.isNotEmpty)
                          TaskList(tasks: today, titleBlock: "Today"),
                        if (tomorrow.isNotEmpty)
                          TaskList(tasks: tomorrow, titleBlock: "Tomorrow"),
                        if (later.isNotEmpty)
                          TaskList(tasks: later, titleBlock: "Later"),
                        //in order to be no task under floatingActionButton i added sizedbox
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            body: _body(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                updateTask(context: context);
              },
              child: const Icon(Icons.add, color: Colors.white, size: 24),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          );
        });
  }
}
