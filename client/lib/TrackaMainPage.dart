import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'createTask/createTask.dart';

class Task {
  final String title;
  final String time;
  bool isChecked;

  Task(this.title, this.time, {this.isChecked = false});

  @override
  String toString() {
    return 'Task{title: $title, time: $time, isChecked: $isChecked}';
  }
}

class AppState extends ChangeNotifier {
  List<Task> tasks = [
    Task('Task 1', '11:00 AM'),
    Task('Task 2', '02:30 PM'),
    Task('Task 3', '05:15 PM'),
    Task('Task 4', '08:00 PM'),
    Task('Task 5', '10:30 PM'),
    Task('Task 6', '10:30 PM'),
  ];

  final taskNameController = TextEditingController();
  final taskTimeController = TextEditingController();

  @override
  void dispose() {
    taskNameController.dispose();
    taskTimeController.dispose();
    super.dispose();
  }

  void addTask() {
    tasks.add(Task(taskNameController.text, taskTimeController.text));
    notifyListeners();
  }

  void toggleCardState(Task task) {
    task.isChecked = !task.isChecked;
    notifyListeners();
  }
}

class TrackaMain extends StatelessWidget {
  const TrackaMain({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TrackaMainPage(),
      ),
    );
  }
}

class TrackaMainPage extends StatelessWidget {
  const TrackaMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('tracka',
            style: TextStyle(color: Colors.black, fontSize: 27)),
        actions: [
          popUpMenu(),
        ],
      ),
      body: CardList(),
    );
  }

  PopupMenuButton<String> popUpMenu() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.black),
      color: Colors.white,
      onSelected: (String result) {
        // Handle the selected item here
        print('Selected item: $result');
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
            value: 'Create Task',
            child: Text('Create Task'),
            onTap: () {
              print('Create Task');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateTask()));
            }),
        PopupMenuItem<String>(
          value: 'Edit Task',
          child: Text('Edit Task'),
        ),
        PopupMenuItem<String>(
          value: 'Delete Task',
          child: Text('Delete Task'),
        ),
      ],
    );
  }
}

class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final tasks = appState.tasks;
        final completedTasksCount =
            tasks.where((task) => task.isChecked).length;

        return ListView.builder(
          itemCount: tasks.length + 1, // +1 for TaskOverView
          itemBuilder: (context, index) {
            if (index == 0) {
              return TaskOverView(
                  tasks: tasks, completedTasksCount: completedTasksCount);
            } else {
              final task = tasks[index - 1];
              return Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 10,
                      child: CustomCard(
                        task: task,
                        toggleCheckbox: () {
                          appState.toggleCardState(task);
                        },
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.013),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}

class TaskOverView extends StatelessWidget {
  final List<Task> tasks;
  final int completedTasksCount;

  const TaskOverView(
      {super.key, required this.tasks, required this.completedTasksCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 37),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${tasks.length}',
                  style: TextStyle(
                      fontSize: 100, color: Color.fromARGB(255, 233, 90, 90)),
                ),
                TextSpan(
                  text: '\ntasks for\ntoday',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 7, 36, 114)),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            children: [
              Icon(Icons.check, color: Color.fromARGB(255, 54, 192, 135)),
              SizedBox(width: 10),
              Text(
                '$completedTasksCount task(s) done',
                style: TextStyle(
                    color: Color.fromARGB(255, 164, 164, 165),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Task task;
  final Function() toggleCheckbox;

  const CustomCard({
    super.key,
    required this.task,
    required this.toggleCheckbox,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      color: Colors.white.withOpacity(0.97),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(task.time),
                    ],
                  ),
                ),
                IconButton(
                  icon: task.isChecked
                      ? Icon(Icons.check_box_outlined)
                      : Icon(Icons.check_box_outline_blank),
                  onPressed: toggleCheckbox,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
