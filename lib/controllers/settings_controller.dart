import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/database.dart';

final List<int> prefrencesColorsDark = [
  0xFF86C691, //green
  0xFFBB96FC, //purple
  0xFF80D8FF, //light blue
  0xFFF1B5AC, //pink
];
final List<int> prefrencesColorsLight = [
  0xFF3E844F, //green
  0xFFA3007A, //eggplant
  0xFF005D85, //blue
  0xFF000000, //black
];

//Change text color based on brightness of the covered background area
Color textColorBasedOnBG(Color color) {
  if (color == null) {
    return Get.isDarkMode ? Colors.black : Colors.white;
  }

  final r = color.red.toInt(); //red
  final g = color.green.toInt(); //green
  final b = color.blue.toInt(); //blue
  //Color brightness is determined by the following formula:
  final brightness = (((r * 299) + (g * 587) + (b * 114)) / 1000).round();
  final textColour = (brightness > 125) ? Colors.black : Colors.white;
  return textColour;
}

class SettingsController extends GetxController {
  ///to use SettingsController.to instead Get.find<SettingsController>()
  static SettingsController get to => Get.find();

  @override
  onInit() async {
    super.onInit();
    //To indicate if it is the first time the user opens the app
    // _firstTime.value = await settings.get("firstTime", defaultValue: true);
    _firstTime.value =
        await db.getDataFromBox<bool>('firstTime', defaultValue: true);
    //The 3 functions is used when launching the app to get the settings data (theme, prefcolor, locale)
    //from the local database or set the default settings if it's the first time
    _getThemeModeFromDataBase();
    _getlocaleFromDataBase();
    _getPrefColorFromDataBase();
    if (firstTime) {
      Timer(Duration(seconds: 60),
          () => db.putDataIntoBox<bool>('firstTime', false));
    }
  }

  final db = DataBase('settings');
  final _prefColor = 0xFF86C691.obs;
  final _themeMode = ThemeMode.system.obs;
  final _locale = Locale('en').obs;
  final _firstTime = true.obs;
  Locale get locale => _locale.value;
  ThemeMode get themeMode => _themeMode.value;
  bool get firstTime => _firstTime.value;
  int get prefColor => _prefColor.value;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode.value = themeMode;
    Get.changeThemeMode(themeMode);
    _switchPrefColorsWhenThemeChange(themeMode);
    await db.putDataIntoBox<String>('theme', describeEnum(themeMode));
  }

  void _getThemeModeFromDataBase() async {
    String themeText =
        await db.getDataFromBox<String>('theme', defaultValue: 'system');
    try {
      if (themeText == 'system') {
        _themeMode.value = Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;
      } else {
        _themeMode.value =
            ThemeMode.values.firstWhere((e) => describeEnum(e) == themeText);
      }
    } catch (e) {
      _themeMode.value = ThemeMode.system;
    }
    setThemeMode(_themeMode.value);
  }

  Future<void> setLocale(Locale newLocale) async {
    if (newLocale != _locale.value) {
      Get.updateLocale(newLocale);
      _locale.value = newLocale;
      update();
      await db.putDataIntoBox('languageCode', newLocale.languageCode);
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
    try {
      final languageCode = await db.getDataFromBox<String>('languageCode',
          defaultValue: Get.locale.languageCode);
      locale = Locale(languageCode);
      setLocale(locale);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setPrefColor(int newPrefColor) async {
    if (newPrefColor != _prefColor.value) {
      _prefColor.value = newPrefColor;
      await db.putDataIntoBox('prefrencesColor', newPrefColor);
    }
  }

  void _getPrefColorFromDataBase() async {
    int prefColor;
    try {
      int dbPrefColor = await db.getDataFromBox('prefrencesColor',
          defaultValue: Get.isDarkMode ? 0xFF86C691 : 0xFF3E844F);
      prefColor = dbPrefColor;
      setPrefColor(prefColor);
    } catch (e) {
      print(e);
    }
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
