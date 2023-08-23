import 'package:flutter/material.dart';

import '../taskClass.dart';
import '../widgets/time.dart';

Future<void> updateTask(BuildContext context, Task task) async {
  String initialTitle = task.taskName;
  String initialTime = task.taskTime;

  String initialDescription = task.taskDescription;
  String selectedStatus = task.taskStatus;
  String selectedPriority = task.taskPriority;

  TextEditingController taskNameController =
      TextEditingController(text: initialTitle);
  TextEditingController taskTimeController =
      TextEditingController(text: initialTime);

  TextEditingController taskDescriptionController =
      TextEditingController(text: initialDescription);

  TextEditingController taskPriorityController =
      TextEditingController(text: selectedPriority);
  TextEditingController taskStatusController =
      TextEditingController(text: selectedStatus);

  TimeOfDay? pickedTime;

  await showModalBottomSheet(
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
                // PriorityDropdown(),
                TextFormField(
                  onTap: () {},
                  controller: taskPriorityController,
                  decoration: InputDecoration(
                    hintText: 'Task Priority',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon(Icons.task),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: taskDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                SizedBox(height: 20),
                // TaskStatusDropdown(),
                TextFormField(
                  controller: taskStatusController,
                  decoration: InputDecoration(
                    hintText: 'Task Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon(Icons.task_alt),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
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
