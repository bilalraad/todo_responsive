import 'package:flutter/material.dart';

import './custom_stepper.dart';
import './color_circle.dart';
import './settings_card.dart';
import '../../widgets/custom_text.dart';
import '../../../controllers/settings_controller.dart';
import '../../../controllers/pomodoro_controller.dart';

class SettingsTap extends StatelessWidget {
  final List<Widget> columns = [
    const PrefrencesColumn(),
    TimerColumn(),
  ];

  SettingsTap({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Wrap(
              spacing: 40,
              children: columns,
            ),
          ),
        ),
      ),
    );
  }
}

class PrefrencesColumn extends StatelessWidget {
  const PrefrencesColumn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sc = SettingsController.to;
    final theme = Theme.of(context);
    Color selectedColor = theme.colorScheme.secondary;
    bool isDark = sc.themeMode == ThemeMode.dark;
    print(isDark);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomText(
              text: 'Preferences',
              iprefText: true,
              textType: TextType.main,
            ),
          ),
          SettingsCard(
            label: 'Color',
            child: Row(
              children: (isDark ? prefrencesColorsDark : prefrencesColorsLight)
                  .map((hexColor) => ColorCircle(
                        isSelected: selectedColor == Color(hexColor),
                        hexColor: hexColor,
                      ))
                  .toList(),
            ),
          ),
          SettingsCard(
            label: 'Dark Theme',
            child: Switch.adaptive(
              value: isDark,
              activeColor: selectedColor,
              onChanged: (value) =>
                  sc.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark),
            ),
          ),
          SettingsCard(
            label: 'Language',
            child: SizedBox(
              width: 100,
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: sc.locale.languageCode == 'ar' ? 'Arabic' : 'English',
                  iconSize: 0,
                  underline: Container(),
                  icon: Container(),
                  isExpanded: true,
                  items: ['English', 'Arabic'].map((dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: SizedBox(
                          width: 200,
                          child: CustomText(
                            text: dropDownStringItem,
                            iprefText: true,
                          )),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == 'Arabic') {
                      sc.setLocale(const Locale('ar'));
                    } else {
                      sc.setLocale(const Locale('en'));
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TimerColumn extends StatelessWidget {
  final pc = PomodoroController.to;

  TimerColumn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomText(
              text: 'Timer',
              iprefText: true,
              textType: TextType.main,
            ),
          ),
          SettingsCard(
              child: CustomStepper(
                value: pc.getTimerDurationInMinute(TimerType.workTime),
                onValueChanged: (isIncrement) {
                  pc.changeTimertime(isIncrement, TimerType.workTime);
                },
                upperLimit: 100,
                iconSize: 30,
              ),
              label: 'Pomodoro'),
          SettingsCard(
              child: CustomStepper(
                value: pc.getTimerDurationInMinute(TimerType.shortbreak),
                onValueChanged: (isIncrement) {
                  pc.changeTimertime(isIncrement, TimerType.shortbreak);
                },
                upperLimit: 100,
                iconSize: 30,
              ),
              label: 'Short break'),
          SettingsCard(
              child: CustomStepper(
                value: pc.getTimerDurationInMinute(TimerType.longBreak),
                onValueChanged: (isIncrement) {
                  pc.changeTimertime(isIncrement, TimerType.longBreak);
                },
                upperLimit: 100,
                iconSize: 30,
              ),
              label: 'Long break'),
        ],
      ),
    );
  }
}
