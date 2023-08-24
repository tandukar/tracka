import 'package:flutter/material.dart';

const List<String> priorityList = <String>[
  'Normal',
  'Low',
  'High',
];
String selectedPriority = priorityList.first;

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
          labelText: 'Task Priority',
          labelStyle: TextStyle(
            fontSize: 19,
            color: Colors.deepPurpleAccent,
          )),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedPriority,
          icon: const Icon(Icons.arrow_drop_down, size: 30),
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
