import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

import '../custom_text.dart';
import '../../../models/task.dart';
import './datetime_picker_widget.dart';
import './header_buttons.dart';
import './priority_widget.dart';
import './category_dropdown.dart';

///This func. is used to create or update a task form the ui side
void updateTask({@required BuildContext context, Task oldTask}) {
  final _formKey = GlobalKey<FormState>();
  Task newTask;

  if (oldTask != null)
    newTask = oldTask;
  else
    newTask = Task(
      id: Uuid().v4(),
      title: '',
      body: '',
      priority: TaskPriority.Low,
      dueDate: DateTime.now().add(Duration(hours: 1)),
      createdAt: DateTime.now(),
      belongsTo: 'Default',
      isFinished: false,
    );

  getValueForScreenType(
    context: context,
    mobile: true,
    desktop: false,
    tablet: false,
  )
      ? showMaterialModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).backgroundColor,
          builder: (bc) {
            final _height = MediaQuery.of(context).size.height;
            return creatTaskFeilds(_height, oldTask, newTask, _formKey);
          })
      : showDialog(
          context: context,
          builder: (bc) {
            final _height = MediaQuery.of(context).size.height;

            return AlertDialog(
              backgroundColor: Theme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: creatTaskFeilds(_height, oldTask, newTask, _formKey),
            );
          });
}

StatefulBuilder creatTaskFeilds(
    double _height, Task oldTask, Task newTask, GlobalKey<FormState> _formKey) {
  ///I used [StatefulBuilder]because in normal setstate
  ///the modal sheet doesn't update its state. So insted use [modalSetState((){})]
  return StatefulBuilder(builder: (context, modalSetState) {
    return Container(
        height: _height * 0.8,
        width: 400,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: <Widget>[
            Container(
              width: 60,
              height: 5,
              margin: const EdgeInsets.only(top: 5, bottom: 10),
              decoration: BoxDecoration(
                  color: const Color(0xFFCFDADF),
                  borderRadius: BorderRadius.circular(10)),
            ),
            CustomText(
              text: oldTask != null ? "Task Details" : "Creat New Task",
              textType: TextType.main,
            ),
            HeaderButtons(
                newTask: newTask, oldTask: oldTask, formKey: _formKey),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  BottomCard(
                    child: TextFormField(
                      initialValue: newTask.title,
                      autofocus: false,
                      onChanged: (value) {
                        modalSetState(
                            () => newTask = newTask.copyWith(title: value));
                      },
                      validator: (value) {
                        if (newTask.title.isEmpty) {
                          return 'Please enter the title'.tr;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Task name".tr,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  BottomCard(
                    child: TextFormField(
                      initialValue: newTask.body,
                      autofocus: false,
                      onChanged: (value) => modalSetState(
                          () => newTask = newTask.copyWith(title: value)),
                      maxLines: 3,
                      decoration: InputDecoration(
                          hintText: "Task note".tr, border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PriorityWidget(
              onPriprotySelected: (newpriority) {
                modalSetState(() => newTask = newTask.copyWith(
                      priority: newpriority,
                    ));
              },
              currentPriority: describeEnum(newTask.priority),
            ),
            const SizedBox(height: 20),
            DateTimePickerWidget(
              currentDateTime: newTask.dueDate,
              onDateTimeSelected: (newDateTime) {
                modalSetState(() => newTask = newTask.copyWith(
                      dueDate: newDateTime,
                    ));
              },
            ),
            const SizedBox(height: 20),
            CategoryDropDown(
                currentCategory: newTask.belongsTo,
                onCategorySelected: (newCat) {
                  modalSetState(
                      () => newTask = newTask.copyWith(belongsTo: newCat));
                }),
          ]),
        ));
  });
}
