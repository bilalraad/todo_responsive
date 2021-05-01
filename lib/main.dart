import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:todo_responsive/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controllers/pomodoro_controller.dart';
import 'controllers/task_controller.dart';
import 'controllers/theme_controller.dart';
import 'localization/localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  //initialize setting & Task controller lazily
  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    ScreenBreakpoints(desktop: 900, tablet: 550, watch: 100),
  );
  await Hive.initFlutter();
  Get.lazyPut<SettingsController>(() => SettingsController());
  Get.lazyPut<TaskController>(() => TaskController());
  Get.put<PomodoroController>(PomodoroController());
  runApp(TodoResponsive());
}

class TodoResponsive extends StatefulWidget {
  @override
  _TodoResponsiveState createState() => _TodoResponsiveState();
}

class _TodoResponsiveState extends State<TodoResponsive> {
  TodoRouterDelegate _routerDelegate = TodoRouterDelegate();
  TodoRouteInformationParser _routeInformationParser =
      TodoRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
      init: SettingsController(),
      initState: (_) {},
      builder: (_) {
        return GetMaterialApp.router(
          title: 'Todo App',
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeInformationParser,
          // showPerformanceOverlay: true,
          debugShowCheckedModeBanner: false,
          theme: SettingsController.themeData(true, _.locale)
              .copyWith(accentColor: Color(_.prefColor)),

          darkTheme: SettingsController.themeData(false, _.locale)
              .copyWith(accentColor: Color(_.prefColor)),
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
        );
      },
    );
  }
}
