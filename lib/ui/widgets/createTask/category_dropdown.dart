import 'package:flutter/material.dart';

import '../custom_text.dart';
import '../../../controllers/settings_controller.dart';
import '../../../controllers/task_controller.dart';

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
          textType: TextType.title,
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
            items: tc.taskCategories
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
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color:
                    textColorBasedOnBG(Theme.of(context).colorScheme.secondary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
