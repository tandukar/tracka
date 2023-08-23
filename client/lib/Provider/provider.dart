// import 'package:flutter/material.dart';

// import '../taskClass.dart';

// class AppState extends ChangeNotifier {
//   bool isChecked = false;

//   void toggleCheckbox() {
//     isChecked = !isChecked;
//     notifyListeners();
//   }

//   // List<Task> tasks = [];

//   final taskNameController = TextEditingController();
//   final taskDescriptionController = TextEditingController();
//   final taskTimeController = TextEditingController();

//   @override
//   void dispose() {
//     taskNameController.dispose();
//     taskDescriptionController.dispose();
//     taskTimeController.dispose();
//     super.dispose();
//   }

//   void toggleCardState(Task task) {
//     task.isChecked = !task.isChecked;
//     notifyListeners();
//   }

//   // void addTask() {
//   //   tasks.add(Task(
//   //     taskNameController.text,
//   //     taskTimeController.text,
//   //     taskDescriptionController.text,
//   //   ));
//   //   notifyListeners();
//   // }

//   void editTask(Task oldTask, Task newTask) {
//     int index = tasks.indexOf(oldTask);
//     if (index != -1) {
//       tasks[index] = newTask;
//       notifyListeners();
//     }
//   }

//   void deleteTask(Task task) {
//     tasks.remove(task);
//     notifyListeners();
//   }

//   void deleteAllTasks() {
//     tasks.clear();
//     notifyListeners();
//   }
// }
