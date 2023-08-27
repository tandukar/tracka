import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../createTask/createTask.dart';

String formatTime(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final parsedTime = DateTime(
    now.year,
    now.month,
    now.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );
  final formattedTime = parsedTime.toIso8601String();
  return formattedTime;
}

void onTapTime(context) async {
  TimeOfDay? pickedTime = await showTimePicker(
    initialTime: TimeOfDay.now(),
    context: context,
  );

  if (pickedTime != null) {
    String formattedTime = formatTime(pickedTime);
    taskTimeController.text = formattedTime;
  }
}

String displayTime(taskTime) {
  DateTime dateTime = DateTime.parse(taskTime);
  String formattedTime = DateFormat('yyyy-MM-dd, hh:mm a').format(dateTime);
  return formattedTime;
}
