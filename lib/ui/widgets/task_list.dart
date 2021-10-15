import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../models/task.dart';
import 'task_block.dart';
import './custom_text.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    @required this.tasks,
    @required this.titleBlock,
    this.scrollHieght,
    Key key,
  }) : super(key: key);

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
    return SizedBox(
      width: getValueForScreenType<double>(
        context: context,
        mobile: double.infinity,
        desktop: 440,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleBlock.isEmpty
              ? const SizedBox(height: 10)
              : Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: CustomText(
                    text: titleBlock,
                    iprefText: true,
                    textType: TextType.title,
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
              margin: const EdgeInsets.all(10),
              height: getValueForScreenType<double>(
                context: context,
                mobile: null,
                tablet: null,
                desktop:
                    scrollHieght ?? MediaQuery.of(context).size.height / 2.7,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
