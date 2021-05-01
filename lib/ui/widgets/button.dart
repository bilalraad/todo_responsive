import 'package:flutter/material.dart';

import './custom_text.dart';

class Custombutton extends StatelessWidget {
  final Function onPressed;
  final String lable;
  final double fontSize;
  final Color color;
  final double width;
  final double hieght;

  const Custombutton({
    @required this.onPressed,
    @required this.lable,
    this.color,
    this.fontSize,
    this.width,
    this.hieght,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 90,
      height: hieght ?? 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: color ?? Theme.of(context).accentColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
        child: CustomText(
            text: lable,
            fontSize: fontSize ?? 14,
            textColor: Theme.of(context).textTheme.button.color),
      ),
    );
  }
}
