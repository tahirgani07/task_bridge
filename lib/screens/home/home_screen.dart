import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/bottom_nav_bar/bottom_nav_bar_model.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/models/user/my_user.dart';
import 'package:task_bridge/models/user/user_model.dart';
import 'package:task_bridge/screens/dashboard/dashboard.dart';
import 'package:task_bridge/screens/profile_dialog/profile_dialog.dart';
import 'package:task_bridge/screens/profile_dialog/profile_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Professions> professions = [
    Professions("Plumber", "assets/images/plumber-icon.png"),
    Professions("Electrician", "assets/images/electrician-icon.png"),
    Professions("Carpenter", "assets/images/carpenter-icon.png"),
    Professions("Personal Trainer", "assets/images/personal-trainer.png"),
    Professions("Beautician", "assets/images/beautician-icon.png"),
    Professions("Cleaner", "assets/images/cleaner-icon.png"),
    Professions("Event Manager", "assets/images/event-management-icon.png"),
  ];

  User? user;
  String _searchState = "";
  String _searchCity = "";
  List<MyUser> _freelancersList = [];
  List<MyUser> _searchList = [];
  MyUser? _curUser;
  bool loading = false;

  Size? _size;

  TextEditingController _searchCtl = TextEditingController();

  @override
  void didChangeDependencies() async {
    user = Provider.of<User?>(context);
    _curUser = await UserModel.getParticularUserDetails(user!.uid);
    _searchState = UserModel.isFreelancer ? _curUser!.state : "Maharashtra";
    _searchCity = UserModel.isFreelancer ? _curUser!.city : "Mumbai";
    _freelancersList = await UserModel.getAllUsersDetails(
      state: _searchState,
      city: _searchCity,
    );
    loading = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    BottomNavBarModel _bottomNavBarModel =
        Provider.of<BottomNavBarModel>(context);

    return loading
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (user != null)
                          ? ProfileHeader(
                              user: user,
                              radius: 60,
                              onTap: () {
                                if (UserModel.isFreelancer) {
                                  _bottomNavBarModel.changeScreen(-1);
                                  return;
                                }
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ProfileDialog();
                                  },
                                );
                              },
                            )
                          : Center(
                              child: Container(
                                child: Icon(Icons.person),
                              ),
                            ),
                      // Material(
                      //   borderRadius: BorderRadius.circular(18),
                      //   elevation: 5.0,
                      //   child: Container(
                      //     height: 55,
                      //     width: 55,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(18),
                      //     ),
                      //     child: Icon(
                      //       Icons.notifications_none_outlined,
                      //       size: 33,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color(0xffF0EFF2),
                    ),
                    child: TextField(
                      onChanged: _onSearch,
                      controller: _searchCtl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Color(0xffF0EFF2)),
                        ),
                        hintText: "Search by name or profession",
                        hintStyle: TextStyle(fontSize: 18),
                        prefixIcon: Icon(Icons.search, size: 32),
                        suffixIcon: _clearSearchFieldBtn(),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  _searchCtl.text.trim().isEmpty
                      ? _showAllProfessions()
                      : _showSearchView(),
                ],
              ),
            ),
          );
  }

  _onSearch(String text) {
    _searchList.clear();
    if (text.trim().isEmpty) {
      setState(() {});
      return;
    }
    _freelancersList.forEach((elem) {
      if (elem.uid == user!.uid || _searchList.contains(elem)) return;
      if (elem.name.toLowerCase().contains(text.toLowerCase())) {
        _searchList.add(elem);
      } else {
        elem.tags.forEach((tag) {
          if (tag.toString().toLowerCase().contains(text.toLowerCase())) {
            if (_searchList.contains(elem)) return;
            _searchList.add(elem);
          }
        });
      }
    });
    setState(() {});
  }

  _onClearSearchField() {
    _searchCtl.clear();
    _onSearch("");
  }

  _clearSearchFieldBtn() {
    if (_searchCtl.text.isNotEmpty)
      return InkWell(
        onTap: _onClearSearchField,
        child: Icon(Icons.cancel),
      );

    return SizedBox();
  }

  _showSearchView() {
    return Expanded(
      child: _searchList.isNotEmpty
          ? ListView.builder(
              itemCount: _searchList.length,
              itemBuilder: (context, ind) {
                MyUser cur = _searchList[ind];
                return Container(
                  height: 100,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Dashboard(
                            displayUsersUid: cur.uid,
                            loggedInUserUid: _curUser!.uid,
                          ),
                        ),
                      );
                    },
                    leading: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: _searchList[ind].photoUrl,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) {
                          return CircularProgressIndicator(
                            value: downloadProgress.progress,
                          );
                        },
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.contain,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cur.name),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${cur.rating}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 3),
                            Icon(
                              Icons.star,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: _size!.width / 2,
                          child: Wrap(
                              children: List.generate(
                            cur.tags.length,
                            (tagInd) {
                              return Text(
                                "${cur.tags[tagInd].toString()}"
                                "${(tagInd < cur.tags.length - 1) ? ', ' : ''}",
                              );
                            },
                          )),
                        ),
                        Text(
                          "Work Done:\n${cur.workDone}",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Text("No data found!"),
    );
  }

  _showAllProfessions() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Professions",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2.5,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              // + 2 in itemCount to compensate for the bottom NavBar, so that all the professionals are fully visible.
              itemCount: professions.length + 2,
              itemBuilder: (context, index) {
                if (index >= professions.length)
                  return Container();
                else
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffA0A8B6)),
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 10,
                          spreadRadius: -3,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(35),
                      child: InkWell(
                        onTap: () {
                          _searchCtl.text = professions[index].name;
                          _onSearch(_searchCtl.text);
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        splashColor: Color(0xff4EC4FE),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Image.asset(
                                professions[index].imgPath,
                                fit: BoxFit.fill,
                                width: 80,
                                height: 80,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              professions[index].name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Professions {
  final String name;
  final String imgPath;

  Professions(this.name, this.imgPath);
}
