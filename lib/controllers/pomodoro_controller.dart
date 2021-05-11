import 'dart:async';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/database.dart';

enum TimerType { workTime, shortbreak, longBreak }

class PomodoroController extends GetxController {
  static PomodoroController get to => Get.find();

  final _percent = 0.0.obs;
  final _seconds = 0.obs;
  final _minutes = 0.obs;
  final _isTimerActive = false.obs;
  final _db = DataBase('settings');
  Timer _timer;
  TimerType _timerType = TimerType.workTime;
  int _workTime;
  int _shortBreakTime;
  int _longBreakTime;

  double get percent => _percent.value;
  int get seconds => _seconds.value;
  int get minutes => _minutes.value;
  TimerType get timerType => _timerType;
  bool get isTimerActive => _isTimerActive.value;

  double _currentTotalSeconds;

  @override
  onInit() async {
    super.onInit();
    _workTime = await _db.getDataFromBox<int>('workTime', defaultValue: 25);
    _shortBreakTime =
        await _db.getDataFromBox<int>('shortbreak', defaultValue: 5);
    _longBreakTime =
        await _db.getDataFromBox<int>('longBreak', defaultValue: 15);
    _minutes.value = _workTime;
    update(['pomodoro']);
  }

  int getTimerDurationInMinute(TimerType type) {
    if (type == TimerType.workTime)
      return _workTime ?? 25;
    else if (type == TimerType.shortbreak) return _shortBreakTime ?? 5;
    return _longBreakTime ?? 15;
  }

  double getDurationInSeconds(TimerType type) {
    int _timeInMinute = 0;
    if (type == TimerType.workTime)
      _timeInMinute = _workTime;
    else if (type == TimerType.longBreak)
      _timeInMinute = _longBreakTime;
    else
      _timeInMinute = _shortBreakTime;

    return Duration(minutes: _timeInMinute).inSeconds.toDouble();
  }

  void startTimer() {
    _isTimerActive.value = true;
    update(['timerBtns']);

    if (_currentTotalSeconds == null)
      _currentTotalSeconds = getDurationInSeconds(_timerType);
    _minutes.value = getTimerDurationInMinute(_timerType);
    _minutes.value--;

    if (_seconds.value == 0) _seconds.value = 60;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (minutesTimer) {
        _seconds.value--;
        _currentTotalSeconds--;
        if (_seconds.value == 0) {
          _seconds.value = 60;
          _minutes.value--;
        }
        _percent.value =
            1 - (_currentTotalSeconds / getDurationInSeconds(_timerType));
        if (_currentTotalSeconds == 0) stopTimer();
        update(['pomodoro']);
      },
    );
  }

  void stopTimer({bool isByUser = false}) {
    _percent.value = 0.0;
    _seconds.value = 0;
    _minutes.value = getTimerDurationInMinute(_timerType);
    _isTimerActive.value = false;
    update(['pomodoro', 'timerBtns']);
    _currentTotalSeconds = null;
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void pauseTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void changeType(TimerType type) {
    _minutes.value = getTimerDurationInMinute(type);
    _timerType = type;
    stopTimer(isByUser: true);
    update(['pomodoro']);
  }

  void changeTimertime(int value, TimerType type) {
    if (type == TimerType.workTime) {
      _workTime = value;
      _minutes.value = value;
    } else if (type == TimerType.shortbreak) {
      _shortBreakTime = value;
    } else {
      _longBreakTime = value;
    }
    _db.putDataIntoBox<int>(describeEnum(type), value);
  }
}
