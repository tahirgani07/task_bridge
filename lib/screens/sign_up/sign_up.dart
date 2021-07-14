import 'package:flutter/material.dart';
import 'package:task_bridge/models/authentication/auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            child: Text("Google Sign In"),
            onPressed: () async {
              await AuthService().signInWithGoogle();
            },
          ),
          ElevatedButton(
            child: Text("Email Password sign in"),
            onPressed: () async {
              await AuthService()
                  .createUserWithEmailAndPassword("abc@gmail.com", "39918062");
            },
          ),
        ],
      ),
    );
  }
}
