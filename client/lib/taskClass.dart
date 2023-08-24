List<Task> tasks = [];

class Task {
  String id;
  String taskName;
  String taskStatus;
  String taskPriority;
  String taskDescription;
  String taskTime;
  String taskOwnerId;
  bool isChecked;

  Task({
    required this.id,
    required this.taskName,
    required this.taskStatus,
    required this.taskPriority,
    required this.taskDescription,
    required this.taskTime,
    required this.taskOwnerId,
    this.isChecked = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      taskName: json['taskName'],
      taskStatus: json['taskStatus'],
      taskPriority: json['taskPriority'],
      taskDescription: json['taskDescription'],
      taskTime: json['taskTime'],
      taskOwnerId: json['taskOwnerId'],
    );
  }
}
