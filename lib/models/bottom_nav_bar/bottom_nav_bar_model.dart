import 'package:flutter/material.dart';

class BottomNavBarModel extends ChangeNotifier {
  int _currentScreenIndex = 0;

  void changeScreen(int index) {
    if (index == _currentScreenIndex) return;
    _currentScreenIndex = index;
    notifyListeners();
  }

  int getCurrentScreenIndex() => _currentScreenIndex;
}
