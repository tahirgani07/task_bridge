import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/authentication/auth.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/models/services/service_model.dart';
import 'package:task_bridge/models/user/my_user.dart';
import 'package:task_bridge/models/user/user_model.dart';
import 'package:task_bridge/others/my_colors.dart';
import 'package:task_bridge/screens/chats_screen/chat_screen.dart';
import 'package:task_bridge/screens/dashboard/create_service_dialog.dart';
import 'package:task_bridge/screens/profile_dialog/profile_header.dart';

class Dashboard extends StatefulWidget {
  final String displayUsersUid;
  final String loggedInUserUid;

  Dashboard({required this.displayUsersUid, required this.loggedInUserUid});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User? _loggedInUser;
  int selectedRadio = 0;
  int descMaxDisplayLength = 85;
  AuthService? _auth;
  bool loggedInUsersDashboard = false;

  @override
  void didChangeDependencies() async {
    _loggedInUser = Provider.of<User?>(context);
    _auth = Provider.of<AuthService>(context);

    if (widget.displayUsersUid == widget.loggedInUserUid) {
      loggedInUsersDashboard = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            color: MyColor.subtleBg,
            child: FutureBuilder<MyUser>(
                future:
                    UserModel.getParticularUserDetails(widget.displayUsersUid),
                builder: (context, snap) {
                  if (snap.hasData) {
                    String curTags = "";
                    for (int i = 0; i < snap.data!.tags.length; i++) {
                      curTags += snap.data!.tags[i];
                      if (i < snap.data!.tags.length - 1) curTags += ", ";
                    }
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          forceElevated: true,
                          automaticallyImplyLeading: false,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          floating: false,
                          expandedHeight: 80,
                          flexibleSpace: FlexibleSpaceBar(
                            title: Row(
                              mainAxisAlignment: loggedInUsersDashboard
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.spaceAround,
                              children: [
                                loggedInUsersDashboard
                                    ? SizedBox()
                                    : InkWell(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Icon(
                                            Icons.arrow_back_ios_new_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                Text(
                                    "${loggedInUsersDashboard ? 'Dashboard' : 'View Profile'}"),
                                SizedBox(width: 10),
                                loggedInUsersDashboard
                                    ? InkWell(
                                        onTap: () => _auth!.signOut(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 5,
                                          ),
                                          child: Text(
                                            "Logout",
                                            style: TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                user: _loggedInUser!,
                                                otherUid: snap.data!.uid,
                                                otherName: snap.data!.name,
                                                otherEmail: snap.data!.email,
                                                otherPhotoUrl:
                                                    snap.data!.photoUrl,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 5,
                                          ),
                                          child: Text(
                                            "Message",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: MyColor.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            centerTitle: true,
                          ),
                          backgroundColor: MyColor.primaryColor,
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Material(
                              elevation: 5,
                              color: MyColor.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 15,
                                    top: 15,
                                    child: StreamBuilder<List<String>>(
                                      stream: UserModel.getBookmarks(
                                          widget.loggedInUserUid),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          List<String> bookmarks =
                                              snapshot.data!;
                                          if (bookmarks.contains(
                                              widget.displayUsersUid)) {
                                            return InkWell(
                                              onTap: () async {
                                                bool success = await Database()
                                                    .deleteBookmark(
                                                  userUid:
                                                      widget.loggedInUserUid,
                                                  bookmarkUserUid:
                                                      widget.displayUsersUid,
                                                );
                                                if (!success) {
                                                  print(
                                                      "Something went wrong while deleting the bookmark");
                                                } else {
                                                  Flushbar(
                                                          message:
                                                              "Bookmark deleted successfully")
                                                      .show(context);
                                                }
                                              },
                                              child: Icon(
                                                Icons.bookmark_added,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                            );
                                          } else {
                                            return InkWell(
                                              onTap: () async {
                                                bool success = await Database()
                                                    .bookmarkUser(
                                                  userUid:
                                                      widget.loggedInUserUid,
                                                  bookmarkUserUid:
                                                      widget.displayUsersUid,
                                                );
                                                if (!success) {
                                                  print(
                                                      "Something went wrong while bookmarking");
                                                } else {
                                                  Flushbar(
                                                          message:
                                                              "Bookmark added successfully")
                                                      .show(context);
                                                }
                                              },
                                              child: Icon(
                                                Icons.bookmark_add,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                            );
                                          }
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: ProfileHeader(
                                            user: loggedInUsersDashboard
                                                ? _loggedInUser
                                                : null,
                                            photoUrl: snap.data!.photoUrl,
                                            radius: 100,
                                            state: loggedInUsersDashboard
                                                ? snap.data!.state
                                                : null,
                                            city: loggedInUsersDashboard
                                                ? snap.data!.city
                                                : null,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Container(
                                          child: Text(
                                            "${snap.data!.name}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${snap.data!.state}, ${snap.data!.city}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          "${snap.data!.email}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Tags:",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "$curTags",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Material(
                                          color: Colors.white38,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Padding(
                                            padding: EdgeInsets.all(30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _getComponent(
                                                  "${snap.data!.rating.toStringAsPrecision(2)}",
                                                  "Rating",
                                                  Icons.star,
                                                  24,
                                                ),
                                                _getComponent(
                                                  "${snap.data!.workDone}",
                                                  "Works Completed",
                                                  Icons.work,
                                                  22,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
          // SERVICES
          // Positioned.fill(
          //   child: DraggableScrollableSheet(
          //     initialChildSize: 0.24,
          //     minChildSize: 0.23,
          //     maxChildSize: 1,
          //     builder: (context, scrollctl) {
          //       return Material(
          //         color: Colors.transparent,
          //         elevation: 20,
          //         child: Container(
          //           margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //           child: CustomScrollView(
          //             controller: scrollctl,
          //             slivers: [
          //               SliverAppBar(
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.only(
          //                     topLeft: Radius.circular(20),
          //                     topRight: Radius.circular(20),
          //                   ),
          //                 ),
          //                 backgroundColor: Colors.white,
          //                 floating: true,
          //                 title: Container(
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(40),
          //                   ),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Text(
          //                         "Services",
          //                         style: TextStyle(
          //                           fontSize: 24,
          //                           color: MyColor.primaryColor,
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //                         maxLines: 1,
          //                       ),
          //                       SizedBox(width: 10),
          //                       MaterialButton(
          //                         shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(100),
          //                         ),
          //                         padding: EdgeInsets.all(5),
          //                         minWidth: 20,
          //                         height: 20,
          //                         color: MyColor.primaryColor,
          //                         onPressed: () async {
          //                           await showDialog(
          //                             barrierDismissible: false,
          //                             context: context,
          //                             builder: (context) {
          //                               return CreateService(widget.showUser!.uid);
          //                             },
          //                           );
          //                         },
          //                         child: Icon(
          //                           Icons.add,
          //                           color: Colors.white,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //               SliverToBoxAdapter(
          //                 child: StreamBuilder<List<Service>>(
          //                     stream: ServiceModel.getServices(widget.showUser!.uid),
          //                     builder: (context, snapshot) {
          //                       if (snapshot.hasData &&
          //                           snapshot.data!.length > 0) {
          //                         return Padding(
          //                           padding: EdgeInsets.all(15.0),
          //                           child: Column(
          //                             children: List.generate(
          //                               snapshot.data!.length,
          //                               (ind) {
          //                                 Service curService =
          //                                     snapshot.data![ind];
          //                                 return Padding(
          //                                   padding:
          //                                       EdgeInsets.only(bottom: 10),
          //                                   child: Material(
          //                                     color: curService.active
          //                                         ? Colors.white
          //                                         : Colors.grey[200],
          //                                     elevation: 5,
          //                                     borderRadius:
          //                                         BorderRadius.circular(20),
          //                                     child: InkWell(
          //                                       borderRadius:
          //                                           BorderRadius.circular(20),
          //                                       onTap: !curService.active
          //                                           ? null
          //                                           : () async {
          //                                               print("WORKS");
          //                                             },
          //                                       child: Padding(
          //                                         padding: EdgeInsets.all(20),
          //                                         child: Column(
          //                                           children: [
          //                                             Row(
          //                                               mainAxisAlignment:
          //                                                   MainAxisAlignment
          //                                                       .spaceBetween,
          //                                               children: [
          //                                                 Flexible(
          //                                                   child: Container(
          //                                                     width:
          //                                                         _size.width /
          //                                                             2,
          //                                                     child: Text(
          //                                                       "${curService.name}",
          //                                                       style:
          //                                                           TextStyle(
          //                                                         fontSize: 20,
          //                                                         fontWeight:
          //                                                             FontWeight
          //                                                                 .bold,
          //                                                       ),
          //                                                     ),
          //                                                   ),
          //                                                 ),
          //                                                 Switch(
          //                                                   value: curService
          //                                                       .active,
          //                                                   onChanged:
          //                                                       (val) async {
          //                                                     await ServiceModel
          //                                                         .changeServiceState(
          //                                                       widget.showUser!.uid,
          //                                                       curService
          //                                                           .timestamp
          //                                                           .millisecondsSinceEpoch
          //                                                           .toString(),
          //                                                       val,
          //                                                     );
          //                                                   },
          //                                                 ),
          //                                               ],
          //                                             ),
          //                                             Row(
          //                                               mainAxisAlignment:
          //                                                   MainAxisAlignment
          //                                                       .spaceBetween,
          //                                               children: [
          //                                                 Flexible(
          //                                                   flex: 5,
          //                                                   child: Container(
          //                                                     child: Text(
          //                                                       "${curService.desc.substring(0, min(descMaxDisplayLength, curService.desc.length))}${curService.desc.length > descMaxDisplayLength ? '....' : ''}",
          //                                                       style:
          //                                                           TextStyle(
          //                                                         fontSize: 15,
          //                                                         fontWeight:
          //                                                             FontWeight
          //                                                                 .w500,
          //                                                         color: Colors
          //                                                                 .grey[
          //                                                             600],
          //                                                       ),
          //                                                     ),
          //                                                   ),
          //                                                 ),
          //                                                 Flexible(
          //                                                   flex: 3,
          //                                                   child: Text(
          //                                                     "Rs.\n${curService.price.toStringAsFixed(2)}",
          //                                                     textAlign:
          //                                                         TextAlign
          //                                                             .center,
          //                                                     style: TextStyle(
          //                                                       fontSize: 20,
          //                                                       fontWeight:
          //                                                           FontWeight
          //                                                               .bold,
          //                                                     ),
          //                                                   ),
          //                                                 ),
          //                                               ],
          //                                             ),
          //                                           ],
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 );
          //                               },
          //                             ),
          //                           ),
          //                         );
          //                       }
          //                       return Container(
          //                         height: _size.height / 2,
          //                         child: Center(
          //                           child: Text(
          //                             "No Services Added yet!",
          //                             textAlign: TextAlign.center,
          //                             style: TextStyle(
          //                               fontSize: 20,
          //                               color: Colors.grey,
          //                               fontWeight: FontWeight.w500,
          //                             ),
          //                           ),
          //                         ),
          //                       );
          //                     }),
          //               ),
          //               SliverToBoxAdapter(
          //                 child: SizedBox(height: 60),
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  _getComponent(String value, String title, IconData icon, double size) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "$value",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 3),
            Icon(
              icon,
              color: Colors.white,
              size: size,
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          "$title",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
