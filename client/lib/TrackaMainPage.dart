import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/Provider/provider.dart';
import 'auth/login.dart';
import 'createTask/createTask.dart';
import 'deleteTask/deleteTask.dart';
import 'shared_preferences_util.dart';
import 'updateTask/updateTask.dart';

void main() => runApp(TrackaMain());

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

class TrackaMainPage extends StatefulWidget {
  const TrackaMainPage({Key? key}) : super(key: key);

  @override
  State<TrackaMainPage> createState() => _TrackaMainPageState();
}

class _TrackaMainPageState extends State<TrackaMainPage> {
  @override
  void initState() {
    super.initState();
    // Load tasks from Shared Preferences
    Provider.of<AppState>(context, listen: false)
        .loadTasksFromSharedPreferences();
    sharedPreferencesUtil();
    print('This is from mainPage initState: _$userIdKey');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
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
                    icon: Image.asset('assets/drawerIcon.png',
                        color: Color.fromARGB(255, 84, 157, 211),
                        width: 25,
                        height: 25),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              ],
            ),
            endDrawer: appBarEndDrawer(context),
            body: CardList(),
          );
        },
      ),
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
          return await deleteATask(context);
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
                  title: Text('Create task',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
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
                      Text('Delete all tasks',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(
                          'Choose Wisely, Alert!!!\nThis operation cannot be UnDone',
                          style: TextStyle(fontSize: 13, color: Colors.red)),
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
                  title: Text('Logout',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Login()));
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
