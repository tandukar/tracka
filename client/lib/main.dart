// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(const Tracka());
}

class Tracka extends StatelessWidget {
  const Tracka({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tracka'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Tracka'),
        ),
      ),
    );
  }
}
