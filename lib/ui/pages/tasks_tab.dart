import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/task.dart';
import '../widgets/custom_text.dart';
import '../widgets/createTask/creat_task.dart';
import '../widgets/task_block.dart';
import '../../controllers/task_controller.dart';

class TasksTab extends StatefulWidget {
  const TasksTab();
  @override
  _TasksTabState createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  double _width, _height;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return GetBuilder<TaskController>(
        id: 'tasks',
        builder: (tc) {
          List<Task> today = [],
              tomorrow = [],
              later = [],
              //selectedTasks
              sTasks = tc.tasks;

          if (sTasks.isNotEmpty)
            sTasks.forEach((ti) {
              if (isSameDay(ti.dueDate, DateTime.now()))
                today.add(ti);
              else if (isSameDay(
                  ti.dueDate, DateTime.now().add(Duration(days: 1))))
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
            return SafeArea(
              child: Container(
                  width: _width,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: _checkIfEmpty(
                      child: Center(
                        child: Wrap(
                          spacing: 40,
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
                  )),
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
}

class TaskList extends StatelessWidget {
  const TaskList({
    @required this.tasks,
    @required this.titleBlock,
    this.scrollHieght,
  });

  final List<Task> tasks;
  final String titleBlock;
  final double scrollHieght;

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    //Sort by priority [high to low]
    tasks.sort((t1, t2) {
      if (!t1.isFinished) return t1.priority.index.compareTo(t2.priority.index);
      return 1;
    });
    //
    //this will move the finished tasks to the end of the list;
    tasks.sort((t1, t2) {
      int t1finished = t1.isFinished ? 1 : 0;
      int t2finished = t2.isFinished ? 1 : 0;
      //if t1<t2 put t2 at the end
      //if t2<t1 swap t1 and t2
      return t1finished.compareTo(t2finished);
    });
    return Container(
      width: getValueForScreenType<double>(
        context: context,
        mobile: double.infinity,
        desktop: 440,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleBlock.isEmpty
              ? SizedBox(height: 10)
              : Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: CustomText(
                    text: titleBlock,
                    iprefText: true,
                    fontSize: 22,
                  )),
          Scrollbar(
            controller: _scrollController,
            isAlwaysShown: getValueForScreenType<bool>(
              context: context,
              mobile: false,
              tablet: false,
              desktop: true,
            ),
            child: Container(
              margin: EdgeInsets.all(10),
              height: getValueForScreenType<double>(
                context: context,
                mobile: null,
                tablet: null,
                desktop: scrollHieght ?? 300,
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  children: tasks
                      .map(
                          (task) => TaskBlock(taskData: task, key: UniqueKey()))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
