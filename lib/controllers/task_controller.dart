import 'package:get/get.dart';
import 'package:todo_responsive/models/database.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  static TaskController get to => Get.find();

  final _tasks = <Task>[].obs;
  final _taskCategories = <String>["Default", "Personal", "Work"].obs;

  final _tasksDB = DataBase('tasks');
  final _taskCategoriesDb = DataBase('taskCategories');

  List<Task> get tasks => _tasks;
  List<String> get taskCategories => _taskCategories;

  @override
  void onInit() async {
    super.onInit();
    _tasks.assignAll(await _getAllTasks());
    update(["tasks", "calendar"]);
    await _getTaskCategories();
  }

  ///To creat new task and save it on the local DB
  Future<void> saveTask(Task task) async {
    try {
      _tasks.add(task);
      update(["tasks", "calendar"]);
      _tasksDB.putDataIntoBox(task.id, task.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  ///To Delete a task by Id from the local DB
  Future<void> deleteTask(String id) async {
    try {
      _tasks.removeWhere((t) => t.id == id);
      update(['tasks', 'calendar']);
      _tasksDB.removeDataFromBox(id);
    } catch (e) {
      print(e.toString());
    }
  }

  ///To update new task and save it on the local DB
  Future<void> updateTask(Task task) async {
    try {
      var index = _tasks.indexWhere((t) => t.id == task.id);
      _tasks[index] = task;
      update(['tasks', 'calendar']);
      _tasksDB.putDataIntoBox(task.id, task.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Task> _listofTasksFromMap(Map<int, dynamic> result) {
    List<Task> tasks = [];
    result?.forEach((_, task) {
      tasks.add(Task.fromMap(task));
    });
    return tasks;
  }

  Future<List<Task>> _getAllTasks() async {
    try {
      final result = await _tasksDB.getAllDataFromBox();
      return _listofTasksFromMap(result.asMap()) ?? [];
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> _getTaskCategories() async {
    try {
      List result = await _taskCategoriesDb.getAllDataFromBox();
      if (result != null && result.isNotEmpty) {
        result.forEach((listM) {
          _taskCategories.add(listM);
        });
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  ///To add a new list to the App and save it to the local DB
  Future<void> addNewList(String listName) async {
    try {
      _taskCategories.add(listName);
      update(['tasks']);
      await _taskCategoriesDb.putDataIntoBox(listName, listName);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  ///To remove a list and The tasks that belongs to it
  ///from the App and the local DB
  // for future use
  Future<void> removeList(String listName) async {
    try {
      _taskCategories.remove(listName);
      _tasks.forEach((t) {
        if (t.belongsTo == listName) deleteTask(t.id);
      });
      update(['tasks']);
      _taskCategoriesDb.removeDataFromBox(listName);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
