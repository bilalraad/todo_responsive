import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../controllers/settings_controller.dart';
import '../../widgets/custom_text.dart';

class SettingsCard extends StatelessWidget {
  final String label;
  final Widget child;
  SettingsCard({@required this.child, @required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: getValueForScreenType<double>(
          context: context,
          mobile: double.infinity,
          tablet: double.infinity,
          desktop: 440),
      height: getValueForScreenType<double>(
          context: context, mobile: 65, tablet: 65, desktop: 100),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 0),
                spreadRadius: 1.0,
                blurRadius: 6.0,
                color: Colors.black26)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: label,
              padding: EdgeInsets.all(10),
              textType: TextType.title,
            ),
            child,
          ],
        ),
      ),
    );
  }
}

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
