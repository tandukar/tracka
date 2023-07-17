import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool isChecked = false;

  void toggleCheckbox() {
    isChecked = !isChecked;
    notifyListeners();
  }
}
