import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/authentication/auth.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/models/services/service_model.dart';
import 'package:task_bridge/models/user/my_user.dart';
import 'package:task_bridge/models/user/user_model.dart';
import 'package:task_bridge/others/my_colors.dart';
import 'package:task_bridge/screens/dashboard/create_service_dialog.dart';
import 'package:task_bridge/screens/profile_dialog/profile_header.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User? _user;
  int selectedRadio = 0;
  int descMaxDisplayLength = 85;
  AuthService? _auth;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    _user = Provider.of<User?>(context);
    _auth = Provider.of<AuthService>(context);

    return SafeArea(
      child: Stack(
        children: [
          Container(
            color: MyColor.subtleBg,
            child: FutureBuilder<MyUser>(
                future: UserModel.getCurrentUserDetails(_user!.uid),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Dashboard"),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () => _auth!.signOut(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
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
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Container(
                                      child: ProfileHeader(
                                          user: _user, radius: 100),
                                    ),
                                    SizedBox(height: 15),
                                    Container(
                                      child: Text(
                                        "${_user?.displayName ?? ''}",
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
                                      "${_user!.email}",
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
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: EdgeInsets.all(30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
          //                               return CreateService(_user!.uid);
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
          //                     stream: ServiceModel.getServices(_user!.uid),
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
          //                                                       _user!.uid,
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
