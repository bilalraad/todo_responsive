import 'package:flutter/material.dart';

import './clock_circle.dart';
import './select_timer_type.dart';
import './timer_buttons.dart';

class PomodoroTab extends StatefulWidget {
  const PomodoroTab();
  @override
  _PomodoroTabState createState() => _PomodoroTabState();
}

class _PomodoroTabState extends State<PomodoroTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SafeArea(
              child: Column(
            children: [
              SelectTimerTypeWidget(),
              ClockCircle(),
              TimerButtons(),
            ],
          ))),
    );
  }
}
