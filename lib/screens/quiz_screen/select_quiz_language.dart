import 'package:flutter/material.dart';
import 'package:task_bridge/screens/quiz_screen/quiz_screen.dart';

class SelectQuizLanguage extends StatefulWidget {
  final String loggedInUserUid;
  final List<String> tags;

  SelectQuizLanguage({required this.loggedInUserUid, required this.tags});
  @override
  _SelectQuizLanguageState createState() => _SelectQuizLanguageState();
}

class _SelectQuizLanguageState extends State<SelectQuizLanguage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select a Language"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MaterialButton(
            minWidth: double.infinity,
            onPressed: () => _startQuiz("english"),
            child: Text("English"),
          ),
          MaterialButton(
            minWidth: double.infinity,
            onPressed: () => _startQuiz("hindi"),
            child: Text("Hindi"),
          ),
        ],
      ),
    );
  }

  _startQuiz(String language) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          uid: widget.loggedInUserUid,
          tags: widget.tags,
          language: language,
        ),
      ),
    );
  }
}
