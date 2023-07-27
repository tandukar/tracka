import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool isChecked = false;

  void toggleCheckbox() {
    isChecked = !isChecked;
    notifyListeners();
  }

  List<Task> tasks = [
    // Task('Task 1', '12:00 pm'),
  ];

  final taskNameController = TextEditingController();
  final taskTimeController = TextEditingController();

  @override
  void dispose() {
    taskNameController.dispose();
    taskTimeController.dispose();
    super.dispose();
  }

  void toggleCardState(Task task) {
    task.isChecked = !task.isChecked;
    notifyListeners();
    saveTasksToSharedPreferences(); // Save tasks to Shared Preferences
  }

  void addTask() {
    tasks.add(Task(taskNameController.text, taskTimeController.text));
    notifyListeners();
    saveTasksToSharedPreferences(); // Save tasks to Shared Preferences
  }

  void editTask(Task oldTask, Task newTask) {
    int index = tasks.indexOf(oldTask);
    if (index != -1) {
      tasks[index] = newTask;
      notifyListeners();
      saveTasksToSharedPreferences(); // Save tasks to Shared Preferences

    }
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    notifyListeners();
    saveTasksToSharedPreferences(); // Save tasks to Shared Preferences
  }

  void deleteAllTasks() {
    tasks.clear();
    notifyListeners();
    saveTasksToSharedPreferences(); // Save tasks to Shared Preferences
  }

  // Method to save tasks in Shared Preferences
  void saveTasksToSharedPreferences() async {
    try {
      List<String> tasksJsonList =
          tasks.map((task) => jsonEncode(task.toMap())).toList();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('tasks', tasksJsonList);
    } catch (e) {
      print("Error while saving tasks to Shared Preferences: $e");
    }
  }

  // Method to load tasks from Shared Preferences
  Future<void> loadTasksFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> tasksJsonList = prefs.getStringList('tasks') ?? [];
      tasks = tasksJsonList
          .map((jsonString) => Task.fromMap(jsonDecode(jsonString)))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error while loading tasks from Shared Preferences: $e");
    }
  }
}

class Task {
  final String title;
  final String time;
  bool isChecked;

  Task(this.title, this.time, {this.isChecked = false});

  @override
  String toString() {
    return 'Task{title: $title, time: $time, isChecked: $isChecked}';
  }

  // Method to convert Task to a Map (JSON representation)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'time': time,
      'isChecked': isChecked,
    };
  }

  // Static method to create a Task object from a Map
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      map['title'],
      map['time'],
      isChecked: map['isChecked'],
    );
  }
}
