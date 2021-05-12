import 'package:flutter/material.dart';

import './controllers/task_controller.dart';
import './models/task.dart';
import './ui/widgets/nav_bar.dart';
import './ui/pages/calendar/calendar_tab.dart';
import './ui/pages/tasks_tab.dart';
import './ui/pages/pomodoro/pomodoro_tab.dart';
import './ui/pages/settings/settings_tab.dart';

class TodoAppState extends ChangeNotifier {
  int _selectedIndex;

  Task _selectedTask;

  final List<Task> tasks = TaskController.to.tasks;

  TodoAppState() : _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int idx) {
    _selectedIndex = idx;
    notifyListeners();
  }

  Task get selectedTask => _selectedTask;

  set selectedTask(Task task) {
    _selectedTask = task;
    notifyListeners();
  }

  int getSelectedTaskById() {
    if (!tasks.contains(_selectedTask)) return 0;
    return tasks.indexOf(_selectedTask);
  }

  void setSelectedTaskById(int id) {
    if (id < 0 || id > tasks.length - 1) {
      return;
    }

    _selectedTask = tasks[id];
    notifyListeners();
  }
}

class TodoRouteInformationParser extends RouteInformationParser<TodoRoutePath> {
  @override
  Future<TodoRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'settings') {
      return SettingsPath();
    } else if (uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == 'pomodoro') {
      return PomodoroPath();
    } else if (uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == 'calendar') {
      return CalendarPath();
    } else {
      if (uri.pathSegments.length >= 2) {
        if (uri.pathSegments[0] == 'task') {
          return TaskDetailsPath(int.parse(uri.pathSegments[1]));
        }
      }
      return TasksListPath();
    }
  }

  @override
  RouteInformation restoreRouteInformation(TodoRoutePath configuration) {
    if (configuration is TasksListPath) {
      return RouteInformation(location: '/home');
    }
    if (configuration is SettingsPath) {
      return RouteInformation(location: '/settings');
    }
    if (configuration is PomodoroPath) {
      return RouteInformation(location: '/pomodoro');
    }
    if (configuration is CalendarPath) {
      return RouteInformation(location: '/calendar');
    }
    if (configuration is TaskDetailsPath) {
      return RouteInformation(location: '/task/${configuration.id}');
    }
    return null;
  }
}

class TodoRouterDelegate extends RouterDelegate<TodoRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TodoRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  TodoAppState appState = TodoAppState();

  TodoRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
  }

  @override
  TodoRoutePath get currentConfiguration {
    if (appState.selectedIndex == 1) {
      return CalendarPath();
    } else if (appState.selectedIndex == 2) {
      return PomodoroPath();
    } else if (appState.selectedIndex == 3) {
      return SettingsPath();
    } else {
      if (appState.selectedTask == null) {
        return TasksListPath();
      } else {
        return TaskDetailsPath(appState.getSelectedTaskById());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: AppShell(appState: appState),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (appState.selectedTask != null) {
          appState.selectedTask = null;
        }
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(TodoRoutePath path) async {
    if (path is TasksListPath) {
      appState.selectedIndex = 0;
      appState.selectedTask = null;
    } else if (path is CalendarPath) {
      appState.selectedIndex = 1;
    } else if (path is PomodoroPath) {
      appState.selectedIndex = 2;
    } else if (path is SettingsPath) {
      appState.selectedIndex = 3;
    } else if (path is TaskDetailsPath) {
      appState.selectedIndex = 0;
      appState.setSelectedTaskById(path.id);
    }
  }
}

// Routes
abstract class TodoRoutePath {}

class TasksListPath extends TodoRoutePath {}

class SettingsPath extends TodoRoutePath {}

class PomodoroPath extends TodoRoutePath {}

class CalendarPath extends TodoRoutePath {}

class TaskDetailsPath extends TodoRoutePath {
  final int id;

  TaskDetailsPath(this.id);
}

// Widget that contains the AdaptiveNavigationScaffold
class AppShell extends StatefulWidget {
  final TodoAppState appState;

  AppShell({
    @required this.appState,
  });

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  InnerRouterDelegate _routerDelegate;
  ChildBackButtonDispatcher _backButtonDispatcher;

  void initState() {
    super.initState();
    _routerDelegate = InnerRouterDelegate(widget.appState);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _routerDelegate.appState = widget.appState;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Defer back button dispatching to the child router
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher
        .createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    var appState = widget.appState;

    // Claim priority, If there are parallel sub router, you will need
    // to pick which one should take priority;
    _backButtonDispatcher.takePriority();

    return Scaffold(
      body: CustomNavBar(
          onTaped: (newIndex) {
            appState.selectedIndex = newIndex;
          },
          selectedIndex: appState.selectedIndex,
          selectedWidget: Router(
            routerDelegate: _routerDelegate,
            backButtonDispatcher: _backButtonDispatcher,
          ),
          navBarItems: [
            NavigationBarItem(
                label: 'Tasks', iconPath: 'assets/icons/task_icon.png'),
            NavigationBarItem(
                label: 'Calendar', iconPath: 'assets/icons/calendar_icon.png'),
            NavigationBarItem(
                label: 'Pomodoro', iconPath: 'assets/icons/timer_icon.png'),
            NavigationBarItem(
                label: 'Settings', iconPath: 'assets/icons/settings_icon.png'),
          ]),
    );
  }
}

class InnerRouterDelegate extends RouterDelegate<TodoRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TodoRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  TodoAppState get appState => _appState;
  TodoAppState _appState;
  set appState(TodoAppState value) {
    if (value == _appState) {
      return;
    }
    _appState = value;
    notifyListeners();
  }

  InnerRouterDelegate(this._appState);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appState.selectedIndex == 0) ...[
          FadeAnimationPage(
            child: TasksTab(),
            key: ValueKey('TaskListPage'),
          ),
        ] else if (appState.selectedIndex == 1)
          FadeAnimationPage(
            child: CalendartTap(),
            key: ValueKey('CalendarPage'),
          )
        else if (appState.selectedIndex == 2)
          FadeAnimationPage(
            child: PomodoroTab(),
            key: ValueKey('PomodoroPage'),
          )
        else
          FadeAnimationPage(
            child: SettingsTap(),
            key: ValueKey('SettingsPage'),
          ),
      ],
      onPopPage: (route, result) {
        appState.selectedTask = null;
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(TodoRoutePath path) async {
    // This is not required for inner router delegate because it does not
    // parse route
    assert(false);
  }
}

class FadeAnimationPage extends Page {
  final Widget child;

  FadeAnimationPage({Key key, this.child}) : super(key: key);

  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        var curveTween = CurveTween(curve: Curves.easeIn);
        return FadeTransition(
          opacity: animation.drive(curveTween),
          child: child,
        );
      },
    );
  }
}

// setState(() => _currentIndex = index)
