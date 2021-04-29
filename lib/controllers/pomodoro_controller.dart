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
  // Timer _timer;

  Box settings;
  @override
  onInit() async {
    super.onInit();
    settings = await Hive.openBox('settings');
    _workTime = settings.get('workTime') ?? 25;
    _shortBreakTime = settings.get('shortBreakTime') ?? 5;
    _longBreakTime = settings.get('longBreakTime') ?? 15;
  }

  int _workTime;
  int _shortBreakTime;
  int _longBreakTime;

  double get percent => _percent.value;
  int get seconds => _seconds.value;
  int get minutes => _minutes.value;

  int getTimerDurationInMinute(TimerType type) {
    if (type == TimerType.workTime)
      return _workTime;
    else if (type == TimerType.shortbreak) return _shortBreakTime;
    return _longBreakTime;
  }

  // _initTimer() {
  //   _percent.value = 0;
  //   _workTime = 1;
  //   // _timeInSec = _workTime.value * 60 == 0 ? 60 : _workTime.value * 60;
  //   _seconds.value = 0;
  // }

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

  void startTimer(TimerType type) {
    // _timeInSec = Duration(minutes: _workTime.value).inSeconds;
    final seconds = getDurationInSeconds(type);
    _minutes.value = getTimerDurationInMinute(type);
    Timer sTimer;
    Timer.periodic(const Duration(minutes: 1), (minutesTimer) {
      _minutes.value--;
      _seconds.value = 60;
      if (!sTimer.isBlank && sTimer.isActive) sTimer.cancel();

      sTimer = Timer.periodic(const Duration(seconds: 1), (secondsTimer) {
        if (_minutes.value <= 0) minutesTimer.cancel();
        _seconds.value--;
        _percent.value = 1 - (seconds / getDurationInSeconds(type));
        update(['workTime']);
      });

      // if (_seconds.value > 0) {
      //   _seconds.value--;
      //   if (_seconds.value <= 1) {
      //     //reset the second
      //     _seconds.value = 59;
      //     if (_workTime.value > 0) _workTime.value--;
      //   }

      // } else {
      //   // FlutterRingtonePlayer.playAlarm();
      //   _initTimer();
      //   timer.cancel();
      // }
    });
  }

  // void stopTimer() {
  //   _initTimer();
  //   update(['workTime']);

  //   // FlutterRingtonePlayer.stop();
  //   if (_timer != null) {
  //     _timer.cancel();
  //     _timer = null;
  //   }
  // }

  void changeTimertime(int value, TimerType type) {
    if (type == TimerType.workTime) {
      settings.put('workTime', value);
      _workTime = value;
    } else if (type == TimerType.longBreak) {
      settings.put('longBreakTime', value);
      _longBreakTime = value;
    } else {
      settings.put('shortBreakTime', value);
      _shortBreakTime = value;
    }
    print(settings.get('workTime'));
  }
}
