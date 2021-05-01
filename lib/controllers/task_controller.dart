import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  static TaskController get to => Get.find();

  final _tasks = <Task>[].obs;
  final _taskCategories = <String>["Default", "Personal", "Work"].obs;
  Box _taskBox;
  Box _taskCategoriesBox;

  List<Task> get tasks => _tasks;
  List<String> get taskCategories => _taskCategories;

  @override
  void onInit() async {
    super.onInit();
    //To make sure the is only one instance of the sqflite db for the entire app
    _taskBox = await Hive.openBox('tasks');
    _taskCategoriesBox = await Hive.openBox('taskLists');
    _tasks.assignAll(await _getAllTasks());
    update(["tasks", "calendar"]);
    await _getTaskLists();
  }

  ///To creat new task and save it on the local DB
  Future<void> saveTask(Task task) async {
    try {
      _tasks.add(task);
      update(["tasks", "calendar"]);
      _taskBox.put(task.id, task.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  ///To Delete a task by Id from the local DB
  Future<void> deleteTask(String id) async {
    try {
      _tasks.removeWhere((t) => t.id == id);
      update(['tasks', 'calendar']);
      _taskBox.delete(id);
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
      _taskBox.put(task.id, task.toMap());
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

  //this func. shouldn't be used outside the class
  Future<List<Task>> _getAllTasks() async {
    try {
      final result = _taskBox.values.toList();
      // return null;
      return _listofTasksFromMap(result.asMap()) ?? [];
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //this func. shouldn't be used outside the class
  Future<void> _getTaskLists() async {
    try {
      List result = _taskCategoriesBox.values.toList();
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
      await _taskCategoriesBox.put(listName, listName);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  ///To remove a list and The tasks that belongs to it
  ///from the App and the local DB
  Future<void> removeList(String listName) async {
    try {
      _taskCategories.remove(listName);
      _tasks.forEach((t) {
        if (t.belongsTo == listName) deleteTask(t.id);
      });
      update(['tasks']);
      _taskCategoriesBox.delete(listName);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  void close() async {
    try {
      await _taskBox.close();
      await _taskCategoriesBox.close();
    } catch (e) {
      print(e.toString());
    }
  }
}
