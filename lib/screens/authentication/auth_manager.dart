import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/screens/authentication/login.dart';
import 'package:task_bridge/screens/screen_manager/screen_manager.dart';

class AuthManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    if (user == null) return LoginScreen();
    return ScreenManager();
  }
}
