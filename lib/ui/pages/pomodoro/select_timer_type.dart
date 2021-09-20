import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../controllers/pomodoro_controller.dart';
import '../../widgets/custom_text.dart';

class SelectTimerTypeWidget extends StatefulWidget {
  const SelectTimerTypeWidget();

  @override
  _SelectTimerTypeWidgetState createState() => _SelectTimerTypeWidgetState();
}

class _SelectTimerTypeWidgetState extends State<SelectTimerTypeWidget> {
  TimerType currrentType = PomodoroController.to.timerType;
  @override
  Widget build(BuildContext context) {
    Widget _typeChip({String label, TimerType type}) {
      return Container(
        width: 150,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: currrentType == type
              ? Border.all(color: Theme.of(context).colorScheme.secondary)
              : null,
        ),
        child: TextButton(
          style: TextButton.styleFrom(
              primary: Theme.of(context).textTheme.button.color,
              padding: EdgeInsets.symmetric(
                vertical: getValueForScreenType(
                    context: context, mobile: 5, desktop: 15, tablet: 10),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              // textStyle: TextStyle(color: Theme.of(context).accentColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
          onPressed: () {
            if (type != currrentType) {
              setState(() => currrentType = type);
              PomodoroController.to.changeType(type);
            }
          },
          child: CustomText(
            text: label,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: [
        _typeChip(
          label: 'Work Time',
          type: TimerType.workTime,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _typeChip(
              label: 'Short break',
              type: TimerType.shortbreak,
            ),
            _typeChip(
              label: 'Long break',
              type: TimerType.longBreak,
            ),
          ],
        ),
      ],
    );
  }
}
