import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'custom_text.dart';

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
              )
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
                  )
                      ? Container(
                          width: 5,
                          height: MediaQuery.of(context).size.width * 0.05,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: 5,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                child: selectedWidget,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildItems(),
              ),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.07,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildItems(),
              ),
            ),
            Expanded(
              child: Container(
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
  final bool selected;
  const NavigationBarItem({
    @required this.label,
    @required this.iconPath,
    @required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.06;
    return Container(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          children: [
            Image.asset(
              iconPath,
              width: size,
              height: size,
              color: selected
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey,
            ),
            CustomText(
              text: label,
              textColor: selected
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey,
              textType: TextType.smallest,
            ),
          ],
        ));
  }
}
