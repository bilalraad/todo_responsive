import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:todo_responsive/models/task.dart';

import '../button.dart';
import '../custom_text.dart';

class PriorityWidget extends StatelessWidget {
  final Function(TaskPriority newpriority) onPriprotySelected;
  final String currentPriority;
  const PriorityWidget(
      {@required this.onPriprotySelected, @required this.currentPriority});

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
          height: getValueForScreenType(
              context: context, mobile: null, desktop: 45),
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 1)),
          child: Wrap(
            alignment: WrapAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Custombutton(
                lable: 'Low',
                color: currentPriority != 'Low'
                    ? Theme.of(context).backgroundColor
                    : null,
                onPressed: () {
                  if (currentPriority != 'low')
                    onPriprotySelected(TaskPriority.Low);
                },
              ),
              // VerticalDivider(
              //   thickness: 1,
              //   width: 2,
              //   color: Colors.black,
              // ),
              Custombutton(
                lable: 'Medium',
                color: currentPriority != 'Medium'
                    ? Theme.of(context).backgroundColor
                    : null,
                onPressed: () {
                  if (currentPriority != 'medium')
                    onPriprotySelected(TaskPriority.Medium);
                },
              ),
              // VerticalDivider(
              //   thickness: 1,
              //   width: 2,
              //   color: Colors.black,
              // ),
              Custombutton(
                lable: 'High',
                color: currentPriority != 'High'
                    ? Theme.of(context).backgroundColor
                    : null,
                onPressed: () {
                  if (currentPriority != 'high')
                    onPriprotySelected(TaskPriority.High);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
