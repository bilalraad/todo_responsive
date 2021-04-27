import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/task.dart';
import '../widgets/custom_text.dart';
import '../../models/date_formatter.dart';
import '../widgets/createTask/creat_task.dart';
import '../../ui/widgets/task_block.dart';
import '../../controllers/task_controller.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage();
  @override
  _TasksListPageState createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  double _width, _height;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return GetBuilder<TaskController>(
        id: 'tasks2',
        builder: (tc) {
          List<Task> today = [],
              tomorrow = [],
              later = [],
              noDate = [],
              //selectedTasks
              sTasks = tc.tasks;

          if (sTasks.isNotEmpty)
            sTasks.forEach((ti) {
              if (ti.dueDate == null)
                noDate.add(ti);
              else if (CustomDateFormatter.format(ti.dueDate).contains('Today'))
                today.add(ti);
              else if (CustomDateFormatter.format(ti.dueDate)
                  .contains('Tomorrow'))
                tomorrow.add(ti);
              else
                later.add(ti);
            });

          Widget _checkIfEmpty({Widget child}) {
            return sTasks.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: _height * 0.4),
                    alignment: Alignment.center,
                    child: const CustomText(
                      text: 'There is no tasks here yet',
                      fontSize: 18,
                    ),
                  )
                : child;
          }

          Widget _body() {
            return Container(
              width: _width,
              child: SingleChildScrollView(
                child: _checkIfEmpty(
                  child: Column(
                    children: [
                      todoList(today, "Today"),
                      todoList(tomorrow, "Tomorrow"),
                      todoList(later, "Later"),
                      todoList(noDate, "No Date"),
                      //in order to be no task under floatingActionButton i added sizedbox
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            body: _body(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                updateTaskModalBottomSheet(context: context);
              },
              child: const Icon(Icons.add, color: Colors.white, size: 24),
              backgroundColor: Theme.of(context).accentColor,
            ),
          );
        });
  }

  todoList(List<Task> tasks, String titleBlock) {
    return tasks.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleBlock.isEmpty
                  ? SizedBox(height: 10)
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: CustomText(
                          text: titleBlock, iprefText: true, fontSize: 22)),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return TaskBlock(taskData: tasks[index], key: UniqueKey());
                },
              ),
            ],
          );
  }
}
