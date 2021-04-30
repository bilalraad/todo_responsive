import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
                primary: selectedIndex == index
                    ? Theme.of(context).accentColor
                    : Color(0xFFC1C1C1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                if (selectedIndex == index)
                  Container(
                    width: 10,
                    height: 100,
                    color: Theme.of(context).accentColor,
                  ),
                navBarItems[index],
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
              height: 60,
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
              width: 80,
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
  final IconData icon;
  const NavigationBarItem({
    this.label,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: getValueForScreenType<double>(
            context: context, mobile: 100, tablet: 80, desktop: 180),
        child: Column(
          children: [
            Icon(icon,
                size: getValueForScreenType<double>(
                  context: context,
                  mobile: MediaQuery.of(context).size.width * 0.07,
                  tablet: MediaQuery.of(context).size.width * 0.07,
                  desktop: 100,
                )),
            Text(label ?? '',
                style: TextStyle(
                    fontSize: getValueForScreenType<double>(
                        context: context,
                        mobile: 15,
                        tablet: 15,
                        desktop: 18))),
          ],
        ));
  }
}
