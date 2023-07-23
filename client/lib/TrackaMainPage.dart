import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

String formatTime(TimeOfDay timeOfDay) {
  DateTime now = DateTime.now();
  DateTime parsedTime = DateTime(
    now.year,
    now.month,
    now.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );
  String formattedTime =
      DateFormat.jm().format(parsedTime); // Format to include AM or PM
  return formattedTime;
}

class AppState extends ChangeNotifier {
  List<Task> tasks = [
    Task('Task 1', '12:00 AM'),
    Task('Task 2', '1:00 PM'),
    Task('Task 3', '2:00 PM'),
  ];

  final taskNameController = TextEditingController();
  final taskTimeController = TextEditingController();

  @override
  void dispose() {
    taskNameController.dispose();
    taskTimeController.dispose();
    super.dispose();
  }

  void toggleCardState(Task task) {
    task.isChecked = !task.isChecked;
    notifyListeners();
  }

  void addTask() {
    tasks.add(Task(taskNameController.text, taskTimeController.text));
    notifyListeners();
  }

  void editTask(Task oldTask, Task newTask) {
    int index = tasks.indexOf(oldTask);
    if (index != -1) {
      tasks[index] = newTask;
      notifyListeners();
    }
  }

  void deleteTask(Task task) {
    tasks.remove(task);
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
        iconTheme: IconThemeData(color: Colors.black, size: 30),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('tracka',
            style: TextStyle(color: Colors.black, fontSize: 27)),
      ),
      endDrawer: appBarEndDrawer(context),
      body: CardList(),
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

        void deleteTask(BuildContext context, Task task) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Delete Task'),
                content: Text('Are you sure you want to delete this task?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      appState.deleteTask(task);
                      Navigator.of(context).pop();
                    },
                    child: Text('Delete'),
                  ),
                ],
              );
            },
          );
        }

        return ListView.builder(
          itemCount: tasks.length + 1, // +1 for TaskOverView
          itemBuilder: (context, index) {
            if (index == 0) {
              return TaskOverView(
                  tasks: tasks, completedTasksCount: completedTasksCount);
            } else {
              final task = tasks[index - 1];
              return Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.017),
                  Padding(
                    padding: const EdgeInsets.only(left: 13, right: 13),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.133,
                          child: CustomCard(
                            task: task,
                            toggleCheckbox: () {
                              appState.toggleCardState(task);
                            },
                            deleteTask: (context) {
                              deleteTask(context, task);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Task task;
  final Function() toggleCheckbox;
  final Function(BuildContext) deleteTask;

  const CustomCard({
    required this.task,
    required this.toggleCheckbox,
    required this.deleteTask,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      // get the color of the card based on the task's isChecked state
      color: task.isChecked ? Colors.green : Colors.red,
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
                    onPressed: () {
                      updateTask(context, task);
                    },
                    icon: Icon(Icons.edit)),
                IconButton(
                    onPressed: () {
                      deleteTask(context);
                    },
                    icon: Icon(Icons.delete)),
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

Drawer appBarEndDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
            ),
            child: Column(
              children: [
                ProfilePicture(
                    name: 'John Doe', radius: 35, fontsize: 35, random: true),
                SizedBox(height: 20),
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ],
            )),
        ListTile(
          leading: Icon(Icons.add, size: 30),
          title: Text('Create task', style: TextStyle(fontSize: 19)),
          onTap: () {
            createTask(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.delete, size: 30),
          title: Text('Delete all tasks', style: TextStyle(fontSize: 19)),
          onTap: () {},
        ),
      ],
    ),
  );
}

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
                Text(
                  'Add Task',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  // clear the text when the textfield is submitted
                  onFieldSubmitted: (value) {
                    Provider.of<AppState>(context, listen: false)
                        .taskNameController
                        .clear();
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
                  readOnly:
                      true, // Set this to true to prevent the keyboard from popping up
                  controller: Provider.of<AppState>(context).taskTimeController,
                  onTap: () async {
                    // Show the time picker when the TextFormField is clicked
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      String formattedTime = formatTime(pickedTime);
                      Provider.of<AppState>(context, listen: false)
                          .taskTimeController
                          .text = formattedTime;
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false).addTask();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 79, 155, 210),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text('Add Task'),
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
                Text(
                  'Edit Task',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                    // Show the time picker when the TextFormField is clicked
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform the update when the "Edit Task" button is pressed
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
                      backgroundColor: Color.fromARGB(255, 79, 155, 210),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text('Edit Task'),
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
