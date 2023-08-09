import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Provider/provider.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'trackaMainPage.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),

        // Add other providers if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Login()),
        routes: {
          'login': (context) => Login(),
          'register': (context) => Register(),
          'trackaMainPage': (context) => TrackaMain(),
        },
      ),
    );
  }
}
