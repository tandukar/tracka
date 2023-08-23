import 'package:client/mainPage/trackaMainPage.dart';
import 'package:flutter/material.dart';

import '../deleteTask/deleteTask.dart';
import '../taskClass.dart';
import '../updateTask/updateTask.dart';
import '../widgets/time.dart';

class CardList extends StatefulWidget {
  final List<Task> tasks; // Receive tasks as a parameter

  const CardList({Key? key, required this.tasks}) : super(key: key);

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.tasks; // Use the tasks received as a parameter
    final completedTasksCount = tasks.where((task) => task.isChecked).length;

    void deleteTask(BuildContext context, Task task) {
      // showDialoggg(context, task);
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
            key: ValueKey(task.taskName),
            padding: const EdgeInsets.only(left: 13, right: 13, bottom: 7),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.111,
                  child: CustomCard(
                    key: ValueKey(task.taskName),
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
  }

  Future<dynamic> showDialoggg(BuildContext context, Task task) {
    return showDialog(
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
          content: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: '"${task.taskName}"',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(text: ' deleted'),
              ],
            ),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // appState.deleteTask(task);
                Navigator.of(context).pop();
              },
              child: Center(child: Text('OK', style: TextStyle(fontSize: 17))),
            ),
          ],
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
        key: ValueKey(task.taskName),
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
          elevation: 5,
          color: task.taskPriority == 'High'
              ? Color.fromARGB(255, 244, 84, 62)
              : task.taskPriority == 'Normal'
                  ? Color.fromARGB(255, 39, 188, 126)
                  : Color.fromARGB(255, 102, 168, 216),
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
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.taskName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(displayTime(task.taskTime),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)),
                          // Text('fafa:$taskId')
                        ],
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: task.isChecked
                            ? Icon(Icons.check_box,
                                color: Colors.white, size: 30)
                            : Icon(Icons.check_box_outline_blank,
                                color: Colors.white, size: 30),
                        onPressed: () {
                          // Provider.of<AppState>(context, listen: false)
                          //     .toggleCardState(task);
                        },
                      ),
                    ),
                  ],
                ),
                ////////////////////////////////
                // Text('$task')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
