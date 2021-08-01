import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_bridge/models/chats/chat_model.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/others/my_colors.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  final String otherUid;
  final String otherName;
  final String otherEmail;
  final String otherPhotoUrl;

  const ChatScreen({
    required this.user,
    required this.otherUid,
    required this.otherName,
    required this.otherEmail,
    required this.otherPhotoUrl,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _combinedUid = "";
  ScrollController _scrollCtl = ScrollController();
  int _currentMax = 15;
  int _loadMore = 10;
  List<Chat> chats = [];
  bool _allChatsLoaded = false;
  bool _isMessageEmpty = true;

  Size? _size;

  TextEditingController _messageCtl = TextEditingController();

  bool _userIsAddedToMsgList = false;

  Database _db = Database();

  @override
  void initState() {
    _scrollCtl.addListener(() {
      if (_scrollCtl.position.pixels == _scrollCtl.position.maxScrollExtent) {
        setState(() {
          _currentMax += _loadMore;
        });
      }
    });
    _combinedUid = _getCombinedUid(widget.user.uid, widget.otherUid);
    super.initState();
  }

  @override
  void dispose() {
    _messageCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.subtleBg,
        appBar: AppBar(
          elevation: 10,
          toolbarHeight: 60,
          backgroundColor: MyColor.primaryColor,
          leading: MaterialButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
                child: Image.network(
                  "${widget.otherPhotoUrl}",
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: 10),
              Text("${widget.otherName}"),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Chat>>(
                stream: ChatModel.getChats(_combinedUid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    chats = snapshot.data!
                        .getRange(0, min(_currentMax, snapshot.data!.length))
                        .toList();
                    if (_currentMax >= snapshot.data!.length)
                      _allChatsLoaded = true;
                    return ListView.builder(
                      controller: _scrollCtl,
                      reverse: true,
                      itemCount: min(chats.length, snapshot.data!.length) + 1,
                      itemBuilder: (context, index) {
                        if (index == chats.length)
                          return _allChatsLoaded
                              ? Container()
                              : Center(
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                        bool curUsersMsg = chats[index].uid == widget.user.uid;
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: _size!.width * 0.8,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: curUsersMsg
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Material(
                                  elevation: 8,
                                  borderRadius: BorderRadius.circular(10),
                                  color: curUsersMsg
                                      ? MyColor.primaryColor
                                      : Colors.white,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 12),
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment: curUsersMsg
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            "${chats[index].message}",
                                            textAlign: curUsersMsg
                                                ? TextAlign.right
                                                : null,
                                            style: TextStyle(
                                              color: curUsersMsg
                                                  ? Colors.white
                                                  : null,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        // Sent Time
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${_formatTimeTo12Hr(chats[index].timestamp.hour, chats[index].timestamp.minute)}",
                                              style: TextStyle(
                                                color: curUsersMsg
                                                    ? null
                                                    : Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 5),
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 150),
                child: Row(
                  children: [
                    Flexible(
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(30),
                        child: TextField(
                          controller: _messageCtl,
                          style: TextStyle(fontSize: 18),
                          maxLines: null,
                          onChanged: (val) {
                            if (val.trim().isEmpty) {
                              setState(() {
                                _isMessageEmpty = true;
                              });
                            } else {
                              setState(() {
                                _isMessageEmpty = false;
                              });
                            }
                          },
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    _isMessageEmpty
                        ? SizedBox()
                        : GestureDetector(
                            onTap: _sendMessage,
                            child: Container(
                              width: 55,
                              height: 55,
                              padding: EdgeInsets.only(left: 3),
                              decoration: BoxDecoration(
                                color: MyColor.primaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _sendMessage() async {
    String msg = _messageCtl.text;
    _messageCtl.clear();

    setState(() {
      _isMessageEmpty = true;
    });

    await _db.sendMessage(
      combinedUid: _combinedUid,
      senderUid: widget.user.uid,
      message: msg,
    );
  }

  String _formatTimeTo12Hr(int hour, int minute) {
    String amOrPm = "AM";
    if (hour > 12) {
      hour = hour % 12;
      amOrPm = "PM";
    } else if (hour == 0) hour = 12;

    if (hour == 12) amOrPm = "PM";

    return hour.toString() + ":" + minute.toString() + " " + amOrPm;
  }

  Future<String> _checkIfUserIsAddedToMsgList() async {
    String error = "";
    await _db
        .checkIfUserIsAddedToMsgList(
          uid1: widget.user.uid,
          name1: widget.user.displayName!,
          email1: widget.user.email!,
          photoUrl1: widget.user.photoURL!,
          uid2: widget.otherUid,
          name2: widget.otherName,
          email2: widget.otherEmail,
          photoUrl2: widget.otherPhotoUrl,
        )
        .onError((err, stackTrace) => error = err.toString());
    return error;
  }

  String _getCombinedUid(String uid1, String uid2) {
    int i = 0;
    int minLen = min(uid1.length, uid2.length);
    while (i < minLen) {
      if (uid1.codeUnits[i] < uid2.codeUnits[i])
        return uid1 + uid2;
      else if (uid1.codeUnits[i] > uid2.codeUnits[i]) return uid2 + uid1;
      i++;
    }
    if (uid1.length < uid2.length) return uid1 + uid2;
    return uid2 + uid1;
  }
}
