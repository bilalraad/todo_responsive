import 'package:flutter/material.dart';
import 'package:todo_responsive/controllers/task_controller.dart';

import '../custom_text.dart';

class CategoryDropDown extends StatelessWidget {
  final String currentCategory;
  final Function(String newCategory) onCategorySelected;
  const CategoryDropDown(
      {@required this.currentCategory, @required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final tc = TaskController.to;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: 'Category',
          padding: EdgeInsets.only(bottom: 5),
        ),
        Container(
          width: 300,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 0),
                    spreadRadius: 1.0,
                    blurRadius: 6.0,
                    color: Colors.black26)
              ]),
          child: DropdownButton<String>(
            value: currentCategory,
            items: tc.taskLists
                .map<DropdownMenuItem<String>>((tl) => DropdownMenuItem(
                      value: tl,
                      child: CustomText(
                        text: tl,
                        padding: EdgeInsets.only(left: 10),
                      ),
                    ))
                .toList(),
            onChanged: (value) => onCategorySelected(value),
            isExpanded: true,
            underline: Container(),
            icon: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).accentColor,
              ),
              child: Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ),
        ),
      ],
    );
  }
}