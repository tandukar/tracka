// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:client/baseApi.dart';
import 'package:client/shared_preferences_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/Provider/provider.dart';
import '../trackaMainPage.dart';

Future<dynamic> createTask(BuildContext context) {
  void addTask() async {
    print('Add Taskkkkkkkkkkkkkkkkkkkkk');

    var regBody = {
      'taskName':
          Provider.of<AppState>(context, listen: false).taskNameController.text,
      'taskStatus': selectedStatus,
      'taskPriority': selectedPriority,
      'taskDescription': Provider.of<AppState>(context, listen: false)
          .taskDescriptionController
          .text,
      'taskTime':
          Provider.of<AppState>(context, listen: false).taskTimeController.text,
      'taskOwnerId': userIdKey,
      // 'taskOwner': 'John Doe',
      // 'taskCreatedDate': DateTime(2023, 8, 1),
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
        Provider.of<AppState>(context, listen: false).addTask();
        Navigator.of(context).pop();
        //
        // clear the text field
        Provider.of<AppState>(context, listen: false)
            .taskNameController
            .clear();
        Provider.of<AppState>(context, listen: false)
            .taskTimeController
            .clear();
        Provider.of<AppState>(context, listen: false)
            .taskDescriptionController
            .clear();

        print('Task created successfully');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task created successfully')),
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
                SizedBox(height: 20),
                TextFormField(
                  onFieldSubmitted: (value) {
                    Provider.of<AppState>(context, listen: false)
                        .taskNameController;
                  },
                  controller: Provider.of<AppState>(context).taskNameController,
                  decoration: InputDecoration(
                    hintText: 'Task Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon(Icons.task),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  controller: Provider.of<AppState>(context).taskTimeController,
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
                ),
                SizedBox(height: 20),
                PriorityDropdown(),
                SizedBox(height: 20),
                TextFormField(
                  onFieldSubmitted: (value) {
                    Provider.of<AppState>(context, listen: false)
                        .taskDescriptionController;
                  },
                  controller:
                      Provider.of<AppState>(context).taskDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Task Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon(Icons.task),
                  ),
                ),
                SizedBox(height: 20),
                TaskStatusDropdown(),
                Expanded(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        print(selectedPriority);
                        addTask();
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
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
