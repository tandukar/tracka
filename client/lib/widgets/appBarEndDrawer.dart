import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import '../auth/login.dart';
import '../createTask/createTask.dart';

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
                    // delete all tasks
                    // Provider.of<AppState>(context, listen: false)
                    //     .deleteAllTasks();
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
                  onTap: () async {
                    // await clearTokenFromSharedPreferences();
                    // SharedPreferences prefs =
                    //     await SharedPreferences.getInstance();

                    // prefs.remove('jwtToken');

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
