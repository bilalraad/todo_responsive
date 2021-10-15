import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:todo_responsive/models/task.dart';

import '../custom_button.dart';
import '../custom_text.dart';

class PriorityWidget extends StatelessWidget {
  final Function(TaskPriority newpriority) onPriprotySelected;
  final String currentPriority;
  const PriorityWidget({
    @required this.onPriprotySelected,
    @required this.currentPriority,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(
          text: 'Priority',
          padding: EdgeInsets.only(bottom: 5),
          textType: TextType.title,
        ),
        Container(
          height: getValueForScreenType(
              context: context, mobile: null, desktop: 45),
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 1)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Custombutton(
                lable: 'Low',
                color: currentPriority != 'Low'
                    ? Theme.of(context).backgroundColor
                    : const Color(0xFF66C749),
                onPressed: () {
                  if (currentPriority != 'low') {
                    onPriprotySelected(TaskPriority.Low);
                  }
                },
              ),
              Custombutton(
                lable: 'Medium',
                color: currentPriority != 'Medium'
                    ? Theme.of(context).backgroundColor
                    : const Color(0xFFE3A224),
                onPressed: () {
                  if (currentPriority != 'medium') {
                    onPriprotySelected(TaskPriority.Medium);
                  }
                },
              ),
              Custombutton(
                lable: 'High',
                color: currentPriority != 'High'
                    ? Theme.of(context).backgroundColor
                    : const Color(0xFFD8334F),
                onPressed: () {
                  if (currentPriority != 'high') {
                    onPriprotySelected(TaskPriority.High);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
