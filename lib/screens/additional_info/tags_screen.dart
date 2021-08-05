import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/others/my_alerts/show_alert.dart';
import 'package:task_bridge/others/my_colors.dart';
import 'package:task_bridge/screens/authentication/auth_manager.dart';

class TagsScreen extends StatefulWidget {
  final String uid;
  final String state;
  final String city;
  TagsScreen({
    required this.uid,
    required this.state,
    required this.city,
  });

  @override
  _TagsScreenState createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  List<String> _selectedTags = [];
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    QuerySnapshot data = await Database().db.collection("tags").get();
    _tags = data.docs.map((e) => e["name"].toString()).toList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AuthManager(),
          ),
        );
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: MyColor.subtleBg,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  Text(
                    "Select Tags",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: MyColor.headingText,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Select tags appropriate to you.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 30),
                  TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        autofocus: false,
                        decoration:
                            InputDecoration(border: OutlineInputBorder())),
                    suggestionsCallback: (text) async {
                      return _getSuggestions(text);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text("$suggestion"),
                      );
                    },
                    onSuggestionSelected: (val) => _onTagSelect(val.toString()),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    children: List.generate(_selectedTags.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_selectedTags[index]),
                                SizedBox(width: 5),
                                InkWell(
                                  onTap: () => _removeTag(index),
                                  splashColor: Colors.red,
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.red,
                                      child: Icon(
                                        Icons.cancel,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    height: 55,
                    textColor: Colors.white,
                    color: MyColor.primaryColor,
                    onPressed: _done,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Done",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.done),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _done() async {
    bool noSelect = false;
    if (_selectedTags.isEmpty) noSelect = true;
    if (!noSelect) {
      ShowAlert.showLoadingDialog(context);
      bool success = await Database().addtags(
        uid: widget.uid,
        tags: _selectedTags,
        state: widget.state,
        city: widget.city,
      );
      ShowAlert.dismissLoadingDialog(context);
      if (!success) {
        Flushbar(
          title: "Error",
          message: "Something went wrong",
          duration: Duration(seconds: 3),
        ).show(context);
        return;
      }
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AuthManager(),
      ),
    );
  }

  _onTagSelect(String tag) {
    setState(() {
      _selectedTags.add(tag);
    });
  }

  _removeTag(int index) {
    setState(() {
      _selectedTags.removeAt(index);
    });
  }

  _getSuggestions(String text) {
    List<String?> _searchList = [];
    if (text.isEmpty) return _searchList;
    _tags.forEach((item) {
      // The tag should not be selected.
      if (!_selectedTags.contains(item) &&
          item.toLowerCase().contains(text.toLowerCase()))
        _searchList.add(item);
    });
    return _searchList;
  }
}
