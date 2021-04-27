import 'package:flutter/material.dart';
import 'package:todo_responsive/models/task.dart';

import '../button.dart';
import '../custom_text.dart';

class PriorityWidget extends StatelessWidget {
  final Function(TaskPriority newpriority) onPriprotySelected;
  final String currentPriority;
  const PriorityWidget(
      {@required this.onPriprotySelected, this.currentPriority});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: 'Priority',
          padding: EdgeInsets.only(bottom: 5),
        ),
        Container(
          height: 35,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Custombutton(
                  lable: 'Low',
                  color: currentPriority != 'low'
                      ? Theme.of(context).backgroundColor
                      : null,
                  onPressed: () {
                    if (currentPriority != 'low')
                      onPriprotySelected(TaskPriority.low);
                  },
                ),
              ),
              VerticalDivider(
                thickness: 1,
                width: 2,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Custombutton(
                  lable: 'Medium',
                  color: currentPriority != 'medium'
                      ? Theme.of(context).backgroundColor
                      : null,
                  onPressed: () {
                    if (currentPriority != 'medium')
                      onPriprotySelected(TaskPriority.medium);
                  },
                ),
              ),
              VerticalDivider(
                thickness: 1,
                width: 2,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Custombutton(
                  lable: 'High',
                  color: currentPriority != 'high'
                      ? Theme.of(context).backgroundColor
                      : null,
                  onPressed: () {
                    if (currentPriority != 'high')
                      onPriprotySelected(TaskPriority.high);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
