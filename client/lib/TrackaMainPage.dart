import 'package:flutter/material.dart';
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

List<Task> tasks = [
  Task('Task 1', '11:00 AM'),
  Task('Task 2', '02:30 PM'),
  Task('Task 3', '05:15 PM'),
  Task('Task 4', '08:00 PM'),
  Task('Task 5', '10:30 PM'),

  // Add more tasks here as needed
];

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
  const TrackaMainPage({super.key});

  @override
  State<TrackaMainPage> createState() => _TrackaMainPageState();
}

class _TrackaMainPageState extends State<TrackaMainPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/logRegBg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 2.5),
                Expanded(
                  child: CardList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  void toggleCardState(Task task) {
    task.isChecked = !task.isChecked;
    notifyListeners();
  }
}

class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return SizedBox(
          height: MediaQuery.of(context).size.height / 10,
          child: CustomCard(
              task: task,
              isChecked: task.isChecked,
              toggleCheckbox: () {
                appState.toggleCardState(task);

                print('Task Details:\n$task');
              }),
        );
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final Task task;
  final bool isChecked;
  final Function() toggleCheckbox;

  const CustomCard({
    super.key,
    required this.task,
    required this.isChecked,
    required this.toggleCheckbox,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(task.time),
                    ],
                  ),
                ),
                IconButton(
                  icon: isChecked
                      ? Icon(Icons.check_box_outlined)
                      : Icon(Icons.check_box_outline_blank),
                  onPressed: toggleCheckbox,
                ),
              ],
            ),
            // SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
