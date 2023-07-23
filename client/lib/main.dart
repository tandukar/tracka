import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//
import 'TrackaMainPage.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'createTask/createTask.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(Tracka());
}

class Tracka extends StatelessWidget {
  const Tracka({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: TrackaMain()),
      routes: {
        'login': (context) => Login(),
        'register': (context) => Register(),
        'trackaMainPage': (context) => TrackaMain(),
        //
        'createTask': (context) => CreateTask(),
      },
    );
  }
}
