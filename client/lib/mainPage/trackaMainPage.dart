import 'package:client/shared_preferences_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../baseApi.dart';
import '../taskClass.dart';
import '../widgets/appBarEndDrawer.dart';
import 'cardList.dart';

class TrackaMain extends StatelessWidget {
  const TrackaMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrackaMainPage(),
    );
  }
}

class TrackaMainPage extends StatefulWidget {
  const TrackaMainPage({Key? key}) : super(key: key);

  @override
  State<TrackaMainPage> createState() => _TrackaMainPageState();
}

class _TrackaMainPageState extends State<TrackaMainPage> {
  late Future<List<Task>> tasksFuture;
  List<Task> tasks = []; // Add this list to store tasks

  @override
  void initState() {
    sharedPreferencesUtil();
    getTask(context);
    super.initState();
    tasksFuture = getTask(context); // Fetch tasks and store in tasksFuture
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          tasksFuture = getTask(context);
        });
      },
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/trackaMainPage.png'),
                  fit: BoxFit.cover)),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black, size: 30),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text('tracka',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 17, 0), fontSize: 26)),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Image.asset('assets/drawerIcon.png',
                        color: Color.fromARGB(255, 0, 0, 0),
                        width: 23,
                        height: 23),
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ],
            ),
            endDrawer: appBarEndDrawer(context),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: FutureBuilder<List<Task>>(
                future: tasksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Display loading indicator while fetching data.
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No tasks available.'));
                  } else {
                    final tasks = snapshot.data!;

                    // Pass the list of tasks to the CardList widget
                    return CardList(tasks: tasks);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Task>> getTask(BuildContext context) async {
    print('Get Taskkkkkkkkkkkkkkkkkkk');
    print('TrackaMainPage: $userIdKey');
    try {
      var response = await Dio().get(
        '$baseApi/tasks/$userIdKey',
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      print(response.data);
      if (response.statusCode == 200) {
        print('Task fetched successfully from taskOwnerId: $userIdKey');
        // Parse the response data and return a list of Task objects
        List<Task> tasks = [];
        for (var taskData in response.data) {
          tasks.add(Task.fromJson(taskData));
        }
        return tasks;
      } else if (response.statusCode == 400) {
        print('Task creation failed');
        // Handle error case
        return []; // Return an empty list in case of an error
      }
    } on DioException catch (e) {
      print('Errorrr: $e');
      // Handle error case
      return []; // Return an empty list in case of an error
    }
    // Return an empty list in case of failure
    return [];
  }
}

class TaskOverView extends StatefulWidget {
  final List<Task> tasks;
  final int completedTasksCount;

  const TaskOverView({
    Key? key,
    required this.tasks,
    required this.completedTasksCount,
  }) : super(key: key);

  @override
  State<TaskOverView> createState() => _TaskOverViewState();
}

class _TaskOverViewState extends State<TaskOverView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 37),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: '${widget.tasks.length}',
                style: TextStyle(
                    fontSize: 100, color: Color.fromARGB(255, 233, 90, 90))),
            TextSpan(
                text: '\ntasks for\ntoday',
                style: GoogleFonts.basic(
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 7, 36, 114),
                  ),
                )),
          ])),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            children: [
              Icon(Icons.check, color: Color.fromARGB(255, 40, 141, 99)),
              SizedBox(width: 10),
              Text(
                '${widget.completedTasksCount} task(s) done',
                style: TextStyle(
                    color: Color.fromARGB(255, 123, 123, 123),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ValueListenableBuilder<int>(
            valueListenable: ValueNotifier(widget.completedTasksCount),
            builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
