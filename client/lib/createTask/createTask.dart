// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:client/baseApi.dart';
import 'package:client/shared_preferences_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../widgets/priorityDropdown.dart';
import '../widgets/taskStatusDropdown.dart';
import '../widgets/time.dart';

TextEditingController taskNameController = TextEditingController();
TextEditingController taskTimeController = TextEditingController();
TextEditingController taskDescriptionController = TextEditingController();

bool _isAnyFieldEmpty(BuildContext context) {
  return taskNameController.text.isEmpty ||
      taskTimeController.text.isEmpty ||
      taskDescriptionController.text.isEmpty;
}

Future<dynamic> createTask(BuildContext context) {
  void addTask() async {
    print('Add Taskkkkkkkkkkkkkkkkkkkkk');

    var regBody = {
      'taskName': taskNameController.text,
      'taskStatus': selectedStatus,
      'taskPriority': selectedPriority,
      'taskDescription': taskDescriptionController.text,
      'taskTime': taskTimeController.text,
      'taskOwnerId': userIdKey,
    };
    print(regBody);

    try {
      var response = await Dio().post(
        '$baseApi/tasks/create',
        options: Options(headers: {"Content-Type": "application/json"}),
        data: jsonEncode(regBody),
      );
      print(response.data);

      if (response.statusCode == 200) {
        // Task is created from below line

        Navigator.of(context).pop();

        // clear the text field
        taskNameController.clear();
        taskTimeController.clear();
        taskDescriptionController.clear();

        print('Task created successfully');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(minutes: 2),
            content: Text('Task created successfully\nPlease refresh'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      } else if (response.statusCode == 400) {
        print('Task creation failed');
      }
    } on DioException catch (e) {
      print('Errorrr: $e');
    }
  }

  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.67,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, top: 23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Add Task',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15),
                taskName(),
                SizedBox(height: 15),
                taskTime(context),
                SizedBox(height: 19),
                PriorityDropdown(),
                SizedBox(height: 15),
                taskDescription(),
                SizedBox(height: 19),
                TaskStatusDropdown(),
                SizedBox(height: 15),
                addTaskButton(context, addTask),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Expanded addTaskButton(BuildContext context, void Function() addTask) {
  return Expanded(
    child: Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_isAnyFieldEmpty(context)) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  title: Center(
                      child: Text('Empty!!!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold))),
                  content: Text('Please enter all the fields',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17)),
                  actions: [
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('OK', style: TextStyle(fontSize: 17)),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            addTask();
            // await createAndRefreshTasks();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: Size(150, 50),
        ),
        child: Text('Add Task', style: TextStyle(fontSize: 20)),
      ),
    ),
  );
}

TextFormField taskDescription() {
  return TextFormField(
    onFieldSubmitted: (value) {
      taskDescriptionController;
    },
    controller: taskDescriptionController,
    decoration: InputDecoration(
      hintText: 'Task Description',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      prefixIcon: Icon(Icons.task),
    ),
  );
}

TextFormField taskTime(BuildContext context) {
  return TextFormField(
    readOnly: true,
    controller: taskTimeController,
    onTap: () async {
      onTapTime(context);
    },
    decoration: InputDecoration(
      hintText: 'Time',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      prefixIcon: Icon(Icons.timer),
    ),
  );
}

TextFormField taskName() {
  return TextFormField(
    onFieldSubmitted: (value) {
      taskNameController;
    },
    controller: taskNameController,
    decoration: InputDecoration(
      hintText: 'Task Name',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      prefixIcon: Icon(Icons.task),
    ),
  );
}
