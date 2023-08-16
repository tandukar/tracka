import 'package:flutter/material.dart';

const List<String> taskStatusList = <String>[
  'Not Started',
  'In Progress',
  'Completed'
];
String selectedStatus = taskStatusList.first;

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
