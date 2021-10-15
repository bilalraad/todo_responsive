import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../widgets/custom_text.dart';

class SettingsCard extends StatelessWidget {
  final String label;
  final Widget child;
  const SettingsCard({Key key, @required this.child, @required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: getValueForScreenType<double>(
          context: context,
          mobile: double.infinity,
          tablet: double.infinity,
          desktop: 440),
      height: getValueForScreenType<double>(
          context: context, mobile: 70, tablet: 65, desktop: 100),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).backgroundColor,
          boxShadow: const [
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
              padding: const EdgeInsets.all(10),
              textType: TextType.title,
            ),
            child,
          ],
        ),
      ),
    );
  }
}
