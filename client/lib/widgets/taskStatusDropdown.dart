import 'package:flutter/material.dart';

const List<String> taskStatusList = <String>[
  'In Progress',
  'Not Started',
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
        labelText: 'Task Status',
        labelStyle: TextStyle(
          fontSize: 19,
          color: Colors.deepPurpleAccent,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
          icon: const Icon(Icons.arrow_drop_down, size: 30),
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
