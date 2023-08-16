import 'package:client/shared_preferences_util.dart';
// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import '../taskClass.dart';
import '../widgets/appBarEndDrawer.dart';
import 'cardList.dart';

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

class TrackaMainPage extends StatefulWidget {
  const TrackaMainPage({Key? key}) : super(key: key);

  @override
  State<TrackaMainPage> createState() => _TrackaMainPageState();
}

class _TrackaMainPageState extends State<TrackaMainPage> {
  @override
  void initState() {
    sharedPreferencesUtil();
    print('TrackaMainPage: $userIdKey');
    super.initState();
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
                  style: TextStyle(color: Colors.red, fontSize: 26)),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Image.asset('assets/drawerIcon.png',
                        color: Color.fromARGB(255, 7, 36, 114),
                        width: 25,
                        height: 25),
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 37),
      child: ValueListenableBuilder<int>(
        valueListenable: ValueNotifier(widget.completedTasksCount),
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: '${widget.tasks.length}',
                    style: TextStyle(
                        fontSize: 100,
                        color: Color.fromARGB(255, 233, 90, 90))),
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
                  Icon(Icons.check, color: Color.fromARGB(255, 54, 192, 135)),
                  SizedBox(width: 10),
                  Text(
                    '${widget.completedTasksCount} task(s) done',
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
