import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:todo_responsive/ui/widgets/custom_text.dart';
import '../../../models/task.dart';

class DateTimePickerWidget extends StatelessWidget {
  final Function(DateTime newDateTime) onDateTimeSelected;
  final DateTime currentDateTime;
  const DateTimePickerWidget({
    @required this.onDateTimeSelected,
    @required this.currentDateTime,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime newDatetime;
    Future _selectDate() async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now().subtract(const Duration(days: 1)),
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
        const CustomText(
          text: 'Date & Time',
          padding: EdgeInsets.only(bottom: 5),
          textType: TextType.title,
        ),
        Container(
          width: 330,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/date_and_time_icon.png',
                    color: Theme.of(context).iconTheme.color,
                    width: 25,
                    height: 25,
                  ),
                  TextButton(
                      onPressed: () => _selectDate(),
                      child: CustomText(
                        textColor: Theme.of(context).colorScheme.secondary,
                        textType: TextType.input,
                        text: DateFormat.yMMMEd(Get.locale.languageCode)
                            .format(currentDateTime),
                      )),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/clock_icon.png',
                    color: Theme.of(context).iconTheme.color,
                    width: 25,
                    height: 25,
                  ),
                  TextButton(
                      onPressed: () => _selectTime(),
                      child: CustomText(
                        textColor: Theme.of(context).colorScheme.secondary,
                        textType: TextType.input,
                        text: DateFormat.Hm(Get.locale.languageCode)
                            .format(currentDateTime),
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
