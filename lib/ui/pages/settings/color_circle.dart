import 'package:flutter/material.dart';

import '../../../controllers/settings_controller.dart';

class ColorCircle extends StatelessWidget {
  const ColorCircle({
    @required this.isSelected,
    @required this.hexColor,
  });

  final bool isSelected;
  final int hexColor;

  @override
  Widget build(BuildContext context) {
    final sc = SettingsController.to;
    return InkWell(
      onTap: () => sc.setPrefColor(hexColor),
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: isSelected
                ? Border.all(width: 3, color: Color(hexColor))
                : null,
            borderRadius: BorderRadius.circular(50)),
        child: Container(
          decoration: BoxDecoration(
              color: Color(hexColor),
              border: isSelected
                  ? Border.all(width: 2, color: Theme.of(context).canvasColor)
                  : null,
              borderRadius: BorderRadius.circular(50)),
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
