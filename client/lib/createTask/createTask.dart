import 'package:flutter/material.dart';

class CreateTask extends StatelessWidget {
  const CreateTask({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: ElevatedButton(
        onPressed: () {
          // createTask(context);
        },
        child: Text('Create Task'),
      )),
    );
  }
}

// Future<dynamic> createTask(BuildContext context) {
//     return showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           color: Colors.transparent,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(13),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Add Task',
//                       style:
//                           TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     controller:
//                         Provider.of<AppState>(context).taskNameController,
//                     decoration: InputDecoration(
//                       hintText: 'Task Name',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       prefixIcon: Icon(Icons.task),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     controller:
//                         Provider.of<AppState>(context).taskTimeController,
//                     decoration: InputDecoration(
//                       hintText: 'Time',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       prefixIcon: Icon(Icons.timer),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Provider.of<AppState>(context, listen: false).addTask();
//                         Navigator.of(context).pop();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color.fromARGB(255, 79, 155, 210),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       child: Text('Add Task'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }