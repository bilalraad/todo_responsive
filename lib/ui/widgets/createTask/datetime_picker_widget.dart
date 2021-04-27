import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todo_responsive/ui/widgets/custom_text.dart';
import '../../../models/task.dart';

class DateTimePickerWidget extends StatelessWidget {
  final Function(DateTime newDateTime) onDateTimeSelected;
  final DateTime currentDateTime;
  const DateTimePickerWidget({
    @required this.onDateTimeSelected,
    @required this.currentDateTime,
  });

  @override
  Widget build(BuildContext context) {
    DateTime newDatetime;
    Future _selectDate() async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        newDatetime = currentDateTime.copywith(
          day: picked.day,
          month: picked.month,
          year: picked.year,
        );
        onDateTimeSelected(newDatetime);
      }
    }

    Future _selectTime() async {
      final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: currentDateTime.hour,
          minute: 0,
        ),
      );
      if (picked != null) {
        newDatetime =
            currentDateTime.copywith(hour: picked.hour, minute: picked.minute);
        onDateTimeSelected(newDatetime);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: 'Date & Time',
          padding: EdgeInsets.only(bottom: 5),
        ),
        Container(
          width: 330,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/date_and_time_icon.png',
                    color: Theme.of(context).iconTheme.color,
                  ),
                  SizedBox(width: 10),
                  TextButton(
                      onPressed: () => _selectDate(),
                      child: CustomText(
                        textColor: Theme.of(context).accentColor,
                        fontSize: 18,
                        text: DateFormat.yMMMEd().format(currentDateTime),
                      )),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/date_and_time_icon.png',
                    color: Theme.of(context).iconTheme.color,
                  ),
                  SizedBox(width: 10),
                  TextButton(
                      onPressed: () => _selectTime(),
                      child: CustomText(
                        textColor: Theme.of(context).accentColor,
                        fontSize: 18,
                        text: DateFormat.Hm().format(currentDateTime),
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}