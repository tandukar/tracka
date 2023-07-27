import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/Provider/provider.dart';
import '../TrackaMainPage.dart';

Future<void> updateTask(BuildContext context, Task task) async {
  String initialTitle = task.title;
  String initialTime = task.time;

  TextEditingController taskNameController =
      TextEditingController(text: initialTitle);
  TextEditingController taskTimeController =
      TextEditingController(text: initialTime);

  TimeOfDay? pickedTime;

  await showModalBottomSheet(
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
                    'Edit Task',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: taskNameController,
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
                  controller: taskTimeController,
                  onTap: () async {
                    pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      String formattedTime = formatTime(pickedTime!);
                      taskTimeController.text = formattedTime;
                    }
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
                      String updatedTitle = taskNameController.text;
                      String updatedTime = taskTimeController.text;

                      if (updatedTitle.isNotEmpty && updatedTime.isNotEmpty) {
                        Task updatedTask = Task(
                          updatedTitle,
                          updatedTime,
                          isChecked: task.isChecked,
                        );

                        Provider.of<AppState>(context, listen: false)
                            .editTask(task, updatedTask);
                      }

                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: Size(180, 50),
                    ),
                    child: Text('Edit Task',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
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
