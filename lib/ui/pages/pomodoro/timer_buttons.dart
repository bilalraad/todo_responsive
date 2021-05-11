import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/pomodoro_controller.dart';
import '../../widgets/button.dart';

class TimerButtons extends StatefulWidget {
  const TimerButtons();

  @override
  _TimerButtonsState createState() => _TimerButtonsState();
}

class _TimerButtonsState extends State<TimerButtons> {
  // bool isActive = false;
  bool isPaused = false;
  final pomodoroController = PomodoroController.to;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PomodoroController>(
      id: 'timerBtns',
      builder: (_) {
        final isActive = _.isTimerActive;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Custombutton(
                onPressed: () {
                  if (isActive)
                    pomodoroController.stopTimer(isByUser: true);
                  else
                    pomodoroController.startTimer();
                },
                lable: isActive ? 'Stop' : 'Start',
                color: isActive ? Colors.red : null,
                width: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Custombutton(
                onPressed: isActive
                    ? () {
                        if (!isPaused)
                          pomodoroController.pauseTimer();
                        else
                          pomodoroController.startTimer();

                        setState(() => isPaused = !isPaused);
                      }
                    : null,
                lable: isPaused ? 'Play' : 'Pause',
                color: isPaused ? Colors.green : Color(0xFFF2C94C),
                width: 200,
              ),
            ),
          ],
        );
      },
    );
  }
}
