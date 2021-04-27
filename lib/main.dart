import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_builder/responsive_builder.dart';

import './ui/pages/home_page.dart';
import './localization/localizations.dart';
import './controllers/theme_controller.dart';
import './controllers/task_controller.dart';
import 'controllers/pomodoro_controller.dart';
import 'ui/pages/Pomodoro.dart';
import 'ui/pages/calendar.dart';
import 'ui/pages/settings.dart';
import 'ui/pages/tasks_list_page.dart';

//TODO: things to be done
//1- comlete the notfication functionality
//2 - cmplete the ui side of the pomodoro and link it to notification
//3- notify the user when the task reaches it's due date
//4- add the app icon and splash screen
//5- add multi select feature to remove multiple tasks at once
//future stuff:
//1- add the abbility to repeat the task

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isAndroid || Platform.isIOS) {
  //   final appDocumentDirectory =
  //       await pathProvider.getApplicationDocumentsDirectory();
  //   Hive.init(appDocumentDirectory.path);
  // }
  //initialize setting & Task controller lazily
  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    ScreenBreakpoints(desktop: 900, tablet: 550, watch: 100),
  );
  Get.lazyPut<SettingsController>(() => SettingsController());
  Get.put<TaskController>(TaskController());
  Get.put<PomodoroController>(PomodoroController());
  runApp(TodoResponsive());
}

class TodoResponsive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
        init: SettingsController(),
        builder: (_) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Genx todo',
            theme: SettingsController.themeData(true)
                .copyWith(accentColor: Color(int.parse(_.prefColor.value))),
            darkTheme: SettingsController.themeData(false)
                .copyWith(accentColor: Color(int.parse(_.prefColor.value))),
            home: GenxTodo(),
            locale: _.locale,
            themeMode: ThemeMode.system,
            translations: MyTranslations(),
            supportedLocales: [
              const Locale('en'),
              const Locale('ar'),
            ],
            localizationsDelegates: [
              // ... app-specific localization delegate[s] here
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routes: {
              'TasksListPage': (_) => TasksListPage(),
              'Pomodoro': (_) => Pomodoro(),
              'SettingsTap': (_) => SettingsTap(),
              'CalendartTap': (_) => CalendartTap(),
            },
          );
        });
  }
}
