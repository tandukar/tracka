import 'dart:convert';

import 'package:client/shared_preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> priorityList = <String>['Low', 'Normal', 'High'];
String selectedPriority = priorityList.first;

const List<String> taskStatusList = <String>[
  'Not Started',
  'In Progress',
  'Completed'
];
String selectedStatus = taskStatusList.first;

class AppState extends ChangeNotifier {
  bool isChecked = false;
  String userId = userIdKey;

  void setUserId(String newUserId) {
    userId = newUserId;
    notifyListeners();
  }

  void toggleCheckbox() {
    isChecked = !isChecked;
    notifyListeners();
  }

  List<Task> tasks = [
    // Task('Task 1', '12:00 pm'),
  ];

  final taskNameController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final taskTimeController = TextEditingController();

  @override
  void dispose() {
    taskNameController.dispose();
    taskDescriptionController.dispose();
    taskTimeController.dispose();
    super.dispose();
  }

  void toggleCardState(Task task) {
    task.isChecked = !task.isChecked;
    notifyListeners();
    saveTasksToSharedPreferences(); // Save tasks to Shared Preferences
  }

  void addTask() {
    tasks.add(Task(
      taskNameController.text,
      taskTimeController.text,
    ));
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
  final String taskName;
  final String time;

  bool isChecked;

  Task(this.taskName, this.time, {this.isChecked = false});

  @override
  String toString() {
    return 'Task{taskName: $taskName, time: $time, isChecked: $isChecked}';
  }

  // Method to convert Task to a Map (JSON representation)
  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
      'time': time,
      'isChecked': isChecked,
    };
  }

  // Static method to create a Task object from a Map
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      map['taskName'],
      map['time'],
      isChecked: map['isChecked'],
    );
  }
}

class PriorityDropdown extends StatefulWidget {
  const PriorityDropdown({super.key});

  @override
  State<PriorityDropdown> createState() => _PriorityDropdownState();
}

class _PriorityDropdownState extends State<PriorityDropdown> {
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurpleAccent),
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 3),
        // labelText: 'Priority',
        hintText: 'Priority',
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedPriority,
          icon: const Icon(Icons.arrow_drop_down, size: 30),
          style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              selectedPriority = value!;
            });
          },
          items: priorityList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class TaskStatusDropdown extends StatefulWidget {
  const TaskStatusDropdown({super.key});

  @override
  State<TaskStatusDropdown> createState() => _TaskStatusDropdownState();
}

class _TaskStatusDropdownState extends State<TaskStatusDropdown> {
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurpleAccent),
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 3),
        hintText: 'Task Status',
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
          icon: const Icon(Icons.arrow_drop_down, size: 30),
          style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              selectedStatus = value!;
            });
          },
          items: taskStatusList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
