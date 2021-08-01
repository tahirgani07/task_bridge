import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/chats/chat_user_model.dart';
import 'package:task_bridge/others/my_colors.dart';
import 'package:task_bridge/screens/chats_screen/chat_screen.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({Key? key}) : super(key: key);

  @override
  _AllChatsScreenState createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  User? _user;
  String otherUid = "";

  int _currentMax = 15;
  int _loadMore = 10;
  ScrollController _scrollCtl = ScrollController();
  bool _allUsersLoaded = false;

  List<ChatUser> _chatUsers = [];

  @override
  void initState() {
    _scrollCtl.addListener(() {
      if (_scrollCtl.position.pixels == _scrollCtl.position.maxScrollExtent) {
        setState(() {
          _currentMax += _loadMore;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<User?>(context);

    return SafeArea(
      child: Column(
        children: [
          // AppBar
          Material(
            elevation: 10,
            color: MyColor.primaryColor,
            child: Container(
              height: 70,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TextButton(
                  //   onPressed: () => Navigator.of(context).pop(),
                  //   child: Icon(Icons.arrow_back_ios_new_rounded),
                  // ),
                  SizedBox(width: 40),
                  Text(
                    "Messages",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: MyColor.textColorOnPrimaryBg,
                    ),
                  ),
                ],
              ),
            ),
          ),

          StreamBuilder<List<ChatUser>>(
              stream: ChatUserModel.getChats(_user!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _chatUsers = snapshot.data!
                      .getRange(0, min(_currentMax, snapshot.data!.length))
                      .toList();
                  if (_currentMax >= snapshot.data!.length)
                    _allUsersLoaded = true;

                  if (_chatUsers.length == 0) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          "No Chats Yet!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      controller: _scrollCtl,
                      itemCount:
                          min(_chatUsers.length, snapshot.data!.length) + 1,
                      itemBuilder: (context, index) {
                        if (index == _chatUsers.length)
                          return _allUsersLoaded
                              ? Container()
                              : Center(
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                        ChatUser curUser = _chatUsers[index];
                        return ListTile(
                          onTap: () {
                            _goToChatScreen(
                              otherUid: curUser.uid,
                              otherName: curUser.name,
                              otherPhotoUrl: curUser.photoUrl,
                              otherEmail: curUser.email,
                            );
                          },
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                            child: Image.network(
                              "${curUser.photoUrl}",
                              fit: BoxFit.fill,
                            ),
                          ),
                          title: Text("${curUser.name}"),
                          subtitle: Text("${curUser.email}"),
                        );
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ],
      ),
    );
  }

  _goToChatScreen({
    required String otherUid,
    required String otherName,
    required String otherPhotoUrl,
    required String otherEmail,
  }) {
    if (_user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            user: _user!,
            otherUid: otherUid,
            otherName: otherName,
            otherPhotoUrl: otherPhotoUrl,
            otherEmail: otherEmail,
          ),
        ),
      );
    }
  }
}