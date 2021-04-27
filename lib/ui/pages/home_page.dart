import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:todo_responsive/ui/web/nav_bar.dart';

import './calendar.dart';
import './settings.dart';
import './Pomodoro.dart';
import 'tasks_list_page.dart';

class GenxTodo extends StatefulWidget {
  GenxTodo({Key key}) : super(key: key);

  @override
  _GenxTodoState createState() => _GenxTodoState();
}

class _GenxTodoState extends State<GenxTodo> {
  int _currentIndex = 0;
  List<Widget> taps = [
    const TasksListPage(),
    const CalendartTap(),
    const Pomodoro(),
    const SettingsTap(),
  ];

  List<BottomNav> _items = [
    const BottomNav('Tasks', LineAwesomeIcons.check_square),
    const BottomNav('Calendar', LineAwesomeIcons.calendar_check),
    const BottomNav('Pomodoro', LineAwesomeIcons.stopwatch),
    const BottomNav('Settings', LineAwesomeIcons.horizontal_sliders),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomNavBar(
        selectedWidget: taps[_currentIndex],
        selectedIndex: _currentIndex,
        onTaped: (index) => setState(() => _currentIndex = index),
        navBarItems: _items
            .map((item) => NavigationBarItem(
                  icon: item.icon,
                  label: item.name.tr,
                ))
            .toList(),
      ),
    );
  }
}

class BottomNav {
  final String name;
  final IconData icon;

  const BottomNav(this.name, this.icon);
}
