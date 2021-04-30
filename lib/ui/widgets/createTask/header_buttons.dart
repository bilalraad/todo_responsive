import 'package:flutter/material.dart';
import 'package:todo_responsive/controllers/task_controller.dart';
import 'package:todo_responsive/models/task.dart';
import 'package:todo_responsive/ui/widgets/button.dart';

class HeaderButtons extends StatelessWidget {
  const HeaderButtons({
    Key key,
    @required this.newTask,
    @required this.oldTask,
    @required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final Task newTask;
  final Task oldTask;
  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    final tc = TaskController.to;
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: oldTask != null
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            if (oldTask != null)
              Custombutton(
                  lable: "Delete",
                  color: Color(0xFFD8334F),
                  onPressed: () async {
                    await tc.deleteTask(oldTask.id);
                    Navigator.pop(context);
                  }),
            Custombutton(
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                if (oldTask != null && oldTask == newTask) {
                  Navigator.of(context).pop();
                  return;
                } else if (oldTask == null) {
                  tc.saveTask(newTask);
                  Navigator.pop(context);

                  return;
                }

                tc.updateTask(newTask);
                Navigator.pop(context);
              },
              lable: 'Done',
            ),
          ],
        ));
  }
}

//to add a card theme to the textFeild
class BottomCard extends StatelessWidget {
  final Widget child;

  const BottomCard({this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
