import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../baseApi.dart';

final Dio _dio = Dio();

Future<bool?> deleteATask(BuildContext context, taskToDelete) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: Center(
            child: Text('Delete Task?',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        content: Text('Deletion process cannot be undone.',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 17)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel', style: TextStyle(fontSize: 17)),
              ),
              TextButton(
                onPressed: () async {
                  final response =
                      await _dio.delete('$baseApi/tasks/$taskToDelete');
                  if (response.statusCode == 200) {
                    print(taskToDelete);
                    Navigator.of(context).pop(true);
                  }
                },
                child: Text('Delete', style: TextStyle(fontSize: 17)),
              ),
            ],
          ),
        ],
      );
    },
  );
}
