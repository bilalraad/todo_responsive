import 'package:flutter/material.dart';

import './custom_stepper.dart';
import './settings_components.dart';
import '../../widgets/custom_text.dart';
import '../../../controllers/theme_controller.dart';
import '../../../controllers/pomodoro_controller.dart';

class SettingsTap extends StatelessWidget {
  // const SettingsTap();

  final List<Widget> columns = [
    PrefrencesColumn(),
    TimerColumn(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
  const PrefrencesColumn();

  @override
  Widget build(BuildContext context) {
    final sc = SettingsController.to;
    final theme = Theme.of(context);
    Color selectedColor = theme.accentColor;
    bool isDark = theme.brightness == Brightness.dark;
    // sc.themeMode == ThemeMode.dark ? true : false;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const CustomText(
                text: 'Preferences', iprefText: true, fontSize: 24),
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
                onChanged: (_) =>
                    sc.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark)),
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
                      sc.setLocale(Locale('ar'));
                    } else {
                      sc.setLocale(Locale('en'));
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child:
                const CustomText(text: 'Timer', iprefText: true, fontSize: 24),
          ),
          SettingsCard(
              child: CustomStepper(
                value: pc.getTimerDurationInMinute(TimerType.workTime),
                onValueChanged: (value) {
                  pc.changeTimertime(value, TimerType.workTime);
                },
                upperLimit: 100,
                iconSize: 30,
              ),
              label: 'Pomodoro'),
          SettingsCard(
              child: CustomStepper(
                value: pc.getTimerDurationInMinute(TimerType.shortbreak),
                onValueChanged: (value) {
                  pc.changeTimertime(value, TimerType.shortbreak);
                },
                upperLimit: 100,
                iconSize: 30,
              ),
              label: 'Short break'),
          SettingsCard(
              child: CustomStepper(
                value: pc.getTimerDurationInMinute(TimerType.longBreak),
                onValueChanged: (value) {
                  pc.changeTimertime(value, TimerType.longBreak);
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
