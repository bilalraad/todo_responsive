import 'dart:async';

// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

enum TimerType { workTime, shortbreak, longBreak }

class PomodoroController extends GetxController {
  static PomodoroController get to => Get.find();

  final _percent = 0.0.obs;
  final _seconds = 0.obs;
  final _minutes = 0.obs;
  final _isTimerActive = false.obs;
  Timer _timer;
  TimerType _timerType = TimerType.workTime;
  int _workTime;
  int _shortBreakTime;
  int _longBreakTime;
  Box settings;

  double get percent => _percent.value;
  int get seconds => _seconds.value;
  int get minutes => _minutes.value;
  TimerType get timerType => _timerType;
  bool get isTimerActive => _isTimerActive.value;

  double _currentTotalSeconds;

  @override
  onInit() async {
    super.onInit();
    settings = await Hive.openBox('settings');
    _workTime = settings.get('workTime') ?? 25;
    _shortBreakTime = settings.get('shortBreakTime') ?? 5;
    _longBreakTime = settings.get('longBreakTime') ?? 15;
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

  void stopTimer() {
    _percent.value = 0.0;
    _seconds.value = 0;
    _minutes.value = getTimerDurationInMinute(_timerType);
    _isTimerActive.value = false;
    update(['pomodoro', 'timerBtns']);
    _currentTotalSeconds = null;
    // FlutterRingtonePlayer.stop();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void pauseTimer() {
    // FlutterRingtonePlayer.stop();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void changeType(TimerType type) {
    _minutes.value = getTimerDurationInMinute(type);
    _timerType = type;
    stopTimer();
    update(['pomodoro']);
  }

  void changeTimertime(int value, TimerType type) {
    if (type == TimerType.workTime) {
      settings.put('workTime', value);
      _workTime = value;
      _minutes.value = value;
    } else if (type == TimerType.longBreak) {
      settings.put('longBreakTime', value);
      _longBreakTime = value;
    } else {
      settings.put('shortBreakTime', value);
      _shortBreakTime = value;
    }
  }
}
