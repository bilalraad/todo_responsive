import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import './home_page.dart';
import './controllers/pomodoro_controller.dart';
import './controllers/task_controller.dart';
import 'controllers/settings_controller.dart';
import './localization/localizations.dart';
import 'models/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  //initialize setting & Task controller lazily
  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    const ScreenBreakpoints(desktop: 900, tablet: 550, watch: 100),
  );
  await Hive.initFlutter();
  Get.put<SettingsController>(SettingsController(LocalDataBase('settings')));
  Get.lazyPut<TaskController>(() => TaskController(LocalDataBase('tasks')));
  Get.lazyPut<PomodoroController>(
      () => PomodoroController(LocalDataBase('settings')));
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://2091334bfc98400895e278473d466aa0@o1019039.ingest.sentry.io/5984951';
    },
    appRunner: () => runApp(const TodoResponsive()),
  );
}

class TodoResponsive extends StatefulWidget {
  const TodoResponsive({Key key}) : super(key: key);

  @override
  _TodoResponsiveState createState() => _TodoResponsiveState();
}

class _TodoResponsiveState extends State<TodoResponsive> {
  final _routerDelegate = TodoRouterDelegate();
  final _routeInformationParser = TodoRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
      initState: (_) {},
      builder: (_) {
        return GetMaterialApp.router(
          title: 'Todo App',
          navigatorObservers: [
            SentryNavigatorObserver(),
          ],
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeInformationParser,
          debugShowCheckedModeBanner: false,
          theme: SettingsController.themeData(true, _.locale).copyWith(
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: Color(_.prefColor))),
          darkTheme: SettingsController.themeData(false, _.locale).copyWith(
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: Color(_.prefColor))),
          locale: _.locale,
          themeMode: SettingsController.to.themeMode,
          translations: MyTranslations(),
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
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
