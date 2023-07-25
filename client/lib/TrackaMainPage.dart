import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() => runApp(TrackaMain());

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
  final now = DateTime.now();
  final parsedTime = DateTime(
    now.year,
    now.month,
    now.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );
  final formattedTime = DateFormat.jm().format(parsedTime).toLowerCase();
  return formattedTime;
}

class AppState extends ChangeNotifier {
  List<Task> tasks = [
    Task('Task 1', '12:00 am'),
    Task('Task 2', '1:00 pm'),
    Task('Task 3', '2:00 pm'),
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

  void deleteAllTasks() {
    tasks.clear();
    notifyListeners();
  }
}

class TrackaMain extends StatelessWidget {
  const TrackaMain({Key? key}) : super(key: key);

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
  const TrackaMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black, size: 30),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('tracka',
            style: TextStyle(color: Colors.red, fontSize: 25)),
        actions: [
          Builder(
            builder: (context) => IconButton(
              // icon: Icon(Icons.menu, color: Colors.black, size: 30),
              icon: Image.asset('assets/drawerIcon.png',
                  color: Color.fromARGB(255, 84, 157, 211),
                  width: 25,
                  height: 25),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      endDrawer: appBarEndDrawer(context),
      body: CardList(),
    );
  }
}

class TaskOverView extends StatelessWidget {
  final List<Task> tasks;
  final int completedTasksCount;

  const TaskOverView({
    Key? key,
    required this.tasks,
    required this.completedTasksCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 37),
      child: ValueListenableBuilder<int>(
        valueListenable: ValueNotifier(completedTasksCount),
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: '${tasks.length}',
                    style: TextStyle(
                        fontSize: 100,
                        color: Color.fromARGB(255, 233, 90, 90))),
                TextSpan(
                    text: '\ntasks for\ntoday',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 7, 36, 114)))
              ])),
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
          );
        },
      ),
    );
  }
}

class CardList extends StatelessWidget {
  const CardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final tasks = appState.tasks;
        final completedTasksCount =
            tasks.where((task) => task.isChecked).length;

        void deleteTask(BuildContext context, Task task) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                title: Center(
                    child: Text('Task Deleted!',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 25,
                            fontWeight: FontWeight.bold))),
                content: Text('${task.title} has been deleted.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17)),
                actions: [
                  TextButton(
                    onPressed: () {
                      appState.deleteTask(task);
                      Navigator.of(context).pop();
                    },
                    child: Center(
                        child: Text('OK', style: TextStyle(fontSize: 17))),
                  ),
                ],
              );
            },
          );
        }

        return ListView.builder(
          itemCount: tasks.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return TaskOverView(
                key: ValueKey('TaskOverView'),
                tasks: tasks,
                completedTasksCount: completedTasksCount,
              );
            } else {
              final task = tasks[index - 1];
              return Padding(
                key: ValueKey(task.title),
                padding: const EdgeInsets.only(left: 13, right: 13, bottom: 5),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.13,
                      child: CustomCard(
                        key: ValueKey(task.title),
                        task: task,
                        deleteTask: (context) => deleteTask(context, task),
                      ),
                    ),
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

class CustomCard extends StatelessWidget {
  final Task task;
  final Function(BuildContext) deleteTask;

  const CustomCard({
    required this.task,
    required this.deleteTask,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        updateTask(context, task);
      },
      child: Dismissible(
        key: ValueKey(task.title),
        direction: DismissDirection.endToStart,
        confirmDismiss: (DismissDirection direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                title: Center(
                    child: Text('Delete Task?',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold))),
                content: Text('Deletion process cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17)),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel', style: TextStyle(fontSize: 17)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Delete', style: TextStyle(fontSize: 17)),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          bool shouldDelete = direction == DismissDirection.endToStart;
          if (shouldDelete) {
            deleteTask(context);
          }
        },
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
          ),
        ),
        child: Card(
          elevation: 7,
          color: Color.fromARGB(255, 54, 192, 135),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(task.time, style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: task.isChecked
                              ? Icon(Icons.check_box,
                                  color: Colors.white, size: 30)
                              : Icon(Icons.check_box_outline_blank,
                                  color: Colors.white, size: 30),
                          onPressed: () {
                            Provider.of<AppState>(context, listen: false)
                                .toggleCardState(task);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Drawer appBarEndDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ProfilePicture(
                  name: 'John Doe',
                  radius: 37,
                  fontsize: 31,
                  random: true,
                ),
                SizedBox(height: 20),
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              ListTileTheme(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.add, size: 30, color: Colors.green),
                  title: Text('Create task', style: TextStyle(fontSize: 19)),
                  onTap: () {
                    Navigator.pop(context);
                    createTask(context);
                  },
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              ListTileTheme(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.delete, size: 30, color: Colors.red),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delete all tasks', style: TextStyle(fontSize: 19)),
                      SizedBox(height: 5),
                      Text('Please click wisely,\nThis action cannot be undone',
                          style: TextStyle(fontSize: 12, color: Colors.red)),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Provider.of<AppState>(context, listen: false)
                        .deleteAllTasks();
                  },
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Spacer(),
              Divider(color: Colors.black.withOpacity(0.3)),
              ListTileTheme(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.logout, size: 30, color: Colors.blue),
                  title: Text('Logout', style: TextStyle(fontSize: 19)),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        'login', (Route<dynamic> route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

void onTapTime(BuildContext context) async {
  TimeOfDay? pickedTime = await showTimePicker(
    initialTime: TimeOfDay.now(),
    context: context,
  );

  if (pickedTime != null) {
    String formattedTime = formatTime(pickedTime);
    Provider.of<AppState>(context, listen: false).taskTimeController.text =
        formattedTime;
  }
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
                Center(
                  child: Text(
                    'Add Task',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  onFieldSubmitted: (value) {
                    Provider.of<AppState>(context, listen: false)
                        .taskNameController;
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
                  readOnly: true,
                  controller: Provider.of<AppState>(context).taskTimeController,
                  onTap: () async {
                    onTapTime(context);
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
                      Provider.of<AppState>(context, listen: false).addTask();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(150, 50),
                    ),
                    child: Text('Add Task', style: TextStyle(fontSize: 20)),
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
