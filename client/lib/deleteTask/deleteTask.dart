import 'package:flutter/material.dart';

Future<bool?> deleteATask(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: Center(
            child: Text('Delete Task?',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        content: Text('Deletion process cannot be undone.',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 17)),
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
}
