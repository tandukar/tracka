import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/Provider/provider.dart';
import '../TrackaMainPage.dart';

Future<dynamic> createTask(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
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
            padding: const EdgeInsets.all(13),
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
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false).addTask();
                      Navigator.of(context).pop();
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
              ],
            ),
          ),
        ),
      );
    },
  );
}
