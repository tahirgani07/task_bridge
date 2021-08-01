import 'package:flutter/material.dart';
import 'package:task_bridge/others/testpage.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text("GO"),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TestPage())),
      ),
    );
  }
}
