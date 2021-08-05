import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/others/my_alerts/show_alert.dart';
import 'package:task_bridge/others/my_colors.dart';

class RatingDailog extends StatefulWidget {
  final String uid;
  final String name;
  RatingDailog(this.uid, this.name);

  @override
  _RatingDailogState createState() => _RatingDailogState();
}

class _RatingDailogState extends State<RatingDailog> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Rate ${widget.name}"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getStar(0),
          _getStar(1),
          _getStar(2),
          _getStar(3),
          _getStar(4),
        ],
      ),
      actions: [
        MaterialButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.red,
          textColor: Colors.white,
          child: Text(
            "Close",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        MaterialButton(
          onPressed: () async {
            ShowAlert.showLoadingDialog(context);
            await Database().updateRating(
              widget.uid,
              _selectedIndex + 1,
              incrementWorkDone: true,
            );
            ShowAlert.dismissLoadingDialog(context);
            Navigator.of(context).pop();
            Flushbar(
              message: "Rated Successfully",
              duration: Duration(seconds: 3),
            ).show(context);
          },
          color: MyColor.primaryColor,
          textColor: Colors.white,
          child: Text(
            "Submit",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  _getStar(int index) {
    return Flexible(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Icon(
          Icons.star,
          color: index <= _selectedIndex ? Colors.yellow : Colors.grey[300],
          size: 50,
        ),
      ),
    );
  }
}
