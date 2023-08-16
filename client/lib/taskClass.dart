import 'widgets/priorityDropdown.dart';
import 'widgets/taskStatusDropdown.dart';

var taskId = '';

class Task {
  final String _id = taskId;
  final String taskName;
  final String taskTime;
  final String taskDescription;
  final String taskStatus = selectedStatus;
  final String taskPriority = selectedPriority;
  bool isChecked;

  Task(this.taskName, this.taskTime, this.taskDescription,
      {this.isChecked = false});

  @override
  String toString() {
    return 'Task{_id:$taskId , taskName: $taskName, taskTime: $taskTime,isChecked: $isChecked, taskDescription: $taskDescription, taskStatus: $taskStatus, taskPriority: $taskPriority,}';
  }

  // Method to convert Task to a Map (JSON representation)
  Map<String, dynamic> toMap() {
    return {
      '_id': _id,
      'taskName': taskName,
      'taskTime': taskTime,
      'description': taskDescription,
      'taskStatus': taskStatus,
      'taskPriority': taskPriority,
      'isChecked': isChecked,
    };
  }

  // Static method to create a Task object from a Map
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      map['taskName'],
      map['time'],
      map['description'],
      isChecked: map['isChecked'],
    );
  }
}
