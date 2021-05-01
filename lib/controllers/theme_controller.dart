import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

final List<int> prefrencesColorsDark = [
  0xFF86C691,
  0xFFBB96FC,
  0xFF80D8FF,
  0xFFF1B5AC,
];
final List<int> prefrencesColorsLight = [
  0xFF3E844F,
  0xFFA3007A,
  0xFF005D85,
  0xFF000000,
];

class SettingsController extends GetxController {
  ///to use SettingsController.to instead Get.find<SettingsController>()
  static SettingsController get to => Get.find();

  @override
  onInit() async {
    super.onInit();
    settings = await Hive.openBox('settings');
    //To indicate if it is the first time the user opens the app
    _firstTime.value = await settings.get("firstTime") ?? true;
    //The 3 functions is used when launching the app to get the settings data (theme, prefcolor, locale)
    //from the local database or set the default settings if it's the first time
    _getThemeModeFromDataBase();
    _getlocaleFromDataBase();
    _getPrefColorFromDataBase();
    if (firstTime) {
      Timer(Duration(seconds: 60), () => settings.put("firstTime", false));
    }
  }

  Box settings;
  final _prefColor = 0xFF86C691.obs;
  final _themeMode = ThemeMode.system.obs;
  final _locale = Locale('en').obs;
  final _firstTime = true.obs;
  Locale get locale => _locale.value;
  ThemeMode get themeMode => _themeMode.value;
  bool get firstTime => _firstTime.value;
  int get prefColor => _prefColor.value;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    Get.changeThemeMode(themeMode);
    _themeMode.value = themeMode;
    _switchPrefColorsWhenThemeChange(themeMode);
    update();
    await settings.put('theme', describeEnum(themeMode));
  }

  _getThemeModeFromDataBase() async {
    ThemeMode themeMode;
    String themeText = settings.get('theme') ?? 'system';
    try {
      if (themeText == 'system') {
        themeMode = Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;
      } else {
        themeMode =
            ThemeMode.values.firstWhere((e) => describeEnum(e) == themeText);
      }
    } catch (e) {
      themeMode = ThemeMode.system;
    }
    setThemeMode(themeMode);
  }

  Future<void> setLocale(Locale newLocale) async {
    if (newLocale != _locale.value) {
      Get.updateLocale(newLocale);
      _locale.value = newLocale;
      update();
      // settings = await Hive.openBox('settings');
      await settings.put('languageCode', newLocale.languageCode);
    }
  }

  ///each theme has diffrerent prefrance colors so this function handels
  ///the switching with he correct index value
  Future<void> _switchPrefColorsWhenThemeChange(ThemeMode mode) async {
    if (mode == ThemeMode.dark) {
      final index = prefrencesColorsLight.indexOf(_prefColor.value);
      if (index != -1) await setPrefColor(prefrencesColorsDark[index]);
    } else {
      final index = prefrencesColorsDark.indexOf(_prefColor.value);
      if (index != -1) await setPrefColor(prefrencesColorsLight[index]);
    }
  }

  void _getlocaleFromDataBase() async {
    Locale locale;
    String languageCode =
        settings.get('languageCode') ?? Get.locale.languageCode;
    try {
      locale = Locale(languageCode);
    } catch (e) {
      locale = Locale('en');
    }
    setLocale(locale);
  }

  Future<void> setPrefColor(int newPrefColor) async {
    if (newPrefColor != _prefColor.value) {
      _prefColor.value = newPrefColor;
      await settings.put('prefrencesColor', newPrefColor);
    }
  }

  _getPrefColorFromDataBase() async {
    int prefColor;
    int dbPrefColor = settings.get('prefrencesColor') ??
        (Get.isDarkMode ? 0xFF86C691 : 0xFF3E844F);
    try {
      prefColor = dbPrefColor;
    } catch (e) {
      prefColor = 0xFF86C691;
    }
    setPrefColor(prefColor);
  }

  static ThemeData themeData(bool isLightTheme, Locale locale) {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: Colors.grey,
      primaryColor: isLightTheme ? Color(0xFFF5F5F5) : Color(0xFF494A67),
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
      backgroundColor: isLightTheme ? Color(0xFFFFFFFF) : Color(0xFF424360),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Color(0xFF737373)),
      scaffoldBackgroundColor:
          isLightTheme ? Color(0xFFFFFFFF) : Color(0xFF424360),
      canvasColor: isLightTheme ? Colors.white : Color(0xFF494A67),
      cardColor: isLightTheme ? Colors.white : Color(0xFF494A67),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isLightTheme ? Colors.grey[100] : Color(0xFF494A67),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xffC5C3E3),
      ),
      appBarTheme: AppBarTheme(
          color: isLightTheme ? Colors.grey[100] : Color(0xFF494A67)),
      fontFamily: locale.languageCode == 'ar' ? 'Cairo' : 'OpenSans',
    );
  }
}
