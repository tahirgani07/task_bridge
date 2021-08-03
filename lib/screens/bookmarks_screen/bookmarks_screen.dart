import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/models/user/my_user.dart';
import 'package:task_bridge/models/user/user_model.dart';
import 'package:task_bridge/others/my_colors.dart';
import 'package:task_bridge/others/testpage.dart';
import 'package:task_bridge/screens/dashboard/dashboard.dart';

class BookmarksScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  User? _user;

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<User?>(context);
    return SafeArea(
      child: Container(
        color: MyColor.subtleBg,
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
                    SizedBox(width: 40),
                    Text(
                      "Bookmarks",
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
            StreamBuilder<List<String>>(
                stream: UserModel.getBookmarks(_user!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<String> _bookmarkIds = snapshot.data!;

                    if (_bookmarkIds.length == 0) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "No Bookmarks yet!",
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
                        itemCount: _bookmarkIds.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<MyUser>(
                              future: UserModel.getParticularUserDetails(
                                  _bookmarkIds[index]),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  MyUser curUser = snap.data!;
                                  return ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => Dashboard(
                                            displayUsersUid:
                                                _bookmarkIds[index],
                                            loggedInUserUid: _user!.uid,
                                          ),
                                        ),
                                      );
                                    },
                                    leading: ClipOval(
                                      child: Material(
                                        color: Colors.white,
                                        child: CachedNetworkImage(
                                          imageUrl: "${curUser.photoUrl}",
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.contain,
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                    title: Text("${curUser.name}"),
                                    subtitle: Text("${curUser.email}"),
                                    trailing: InkWell(
                                      onTap: () async {
                                        await Database().deleteBookmark(
                                          userUid: _user!.uid,
                                          bookmarkUserUid: _bookmarkIds[index],
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                } else {
                                  return ListTile(
                                    title: LinearProgressIndicator(),
                                  );
                                }
                              });
                        },
                      ),
                    );
                  } else {
                    return Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
