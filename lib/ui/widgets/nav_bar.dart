import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:todo_responsive/ui/widgets/custom_text.dart';

class CustomNavBar extends StatelessWidget {
  final Widget selectedWidget;
  final int selectedIndex;
  final List<NavigationBarItem> navBarItems;
  final Function(int index) onTaped;
  CustomNavBar({
    @required this.selectedWidget,
    @required this.selectedIndex,
    @required this.navBarItems,
    @required this.onTaped,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildItems() {
      return <Widget>[
        for (var index = 0; index < navBarItems.length; index++)
          TextButton(
            onPressed: () => onTaped(index),
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Stack(
              alignment: getValueForScreenType<bool>(
                      context: context,
                      mobile: false,
                      desktop: true,
                      tablet: true)
                  ? Get.locale.languageCode == 'ar'
                      ? Alignment.centerRight
                      : Alignment.centerLeft
                  : Alignment.bottomCenter,
              children: [
                if (selectedIndex == index)
                  getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          desktop: true,
                          tablet: true)
                      ? Container(
                          width: 5,
                          height: 100,
                          color: Theme.of(context).accentColor,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 5,
                          color: Theme.of(context).accentColor,
                        ),
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    selectedIndex == index
                        ? Theme.of(context).accentColor
                        : Color(0xFFC1C1C1),
                    BlendMode.modulate,
                  ),
                  child: navBarItems[index],
                ),
              ],
            ),
          )
      ];
    }

    return Container(
      color: Theme.of(context).primaryColor,
      child: ScreenTypeLayout(
        mobile: Column(
          children: [
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: selectedWidget,
              ),
            ),
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildItems(),
              ),
            ),
          ],
        ),
        tablet: Row(
          children: [
            Container(
              // width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildItems(),
              ),
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: selectedWidget,
              ),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Container(
              width: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildItems(),
              ),
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: selectedWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationBarItem extends StatelessWidget {
  final String label;
  final String iconPath;
  const NavigationBarItem({
    @required this.label,
    @required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    final size = getValueForScreenType<double>(
      context: context,
      mobile: MediaQuery.of(context).size.width * 0.07,
      tablet: MediaQuery.of(context).size.width * 0.07,
      desktop: 100,
    );
    return Container(
        width: getValueForScreenType<double>(
            context: context,
            mobile: MediaQuery.of(context).size.width * 0.2,
            tablet: 80,
            desktop: 180),
        child: Column(
          children: [
            SvgPicture.asset(
              iconPath,
              width: size,
              height: size,
              color: Colors.white70,
            ),
            CustomText(
                text: label,
                textColor: Colors.white70,
                fontSize: getValueForScreenType<double>(
                    context: context, mobile: 14, tablet: 15, desktop: 18)),
          ],
        ));
  }
}
