import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/pomodoro_controller.dart';
import '../../widgets/custom_button.dart';

class TimerButtons extends StatefulWidget {
  const TimerButtons({Key key}) : super(key: key);

  @override
  _TimerButtonsState createState() => _TimerButtonsState();
}

class _TimerButtonsState extends State<TimerButtons> {
  bool isPaused = false;
  final pomodoroController = PomodoroController.to;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PomodoroController>(
      id: 'timerBtns',
      builder: (pc) {
        final isActive = pc.isTimerActive;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Custombutton(
                onPressed: () {
                  if (isActive) {
                    pomodoroController.stopTimer(isByUser: true);
                  } else {
                    pomodoroController.startTimer();
                  }
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
                        if (!isPaused) {
                          pomodoroController.pauseTimer();
                        } else {
                          pomodoroController.startTimer();
                        }

                        setState(() => isPaused = !isPaused);
                      }
                    : null,
                lable: isPaused ? 'Play' : 'Pause',
                color: isPaused ? Colors.green : const Color(0xFFF2C94C),
                width: 200,
              ),
            ),
          ],
        );
      },
    );
  }
}
