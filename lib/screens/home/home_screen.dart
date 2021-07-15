import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/models/user/user_model.dart';
import 'package:task_bridge/screens/profile_dialog/profile_dialog.dart';

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
    Professions("Plumber", "assets/images/plumber-icon.png"),
    Professions("Electrician", "assets/images/electrician-icon.png"),
    Professions("Carpenter", "assets/images/carpenter-icon.png"),
  ];

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    User? user = Provider.of<User?>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (user != null)
                  ? InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ProfileDialog();
                          },
                        );
                      },
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0.0, 5.0),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            user.photoURL ?? UserModel.defaultPhotoUrl,
                            loadingBuilder: (context, child, loadingProgress) {
                              int expectedTotalBytes =
                                  loadingProgress?.expectedTotalBytes ?? 1;
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        child: Icon(Icons.person),
                      ),
                    ),
              Material(
                borderRadius: BorderRadius.circular(18),
                elevation: 5.0,
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.notifications_none_outlined,
                    size: 33,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Color(0xffF0EFF2),
            ),
            child: TextField(
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
              ),
            ),
          ),
          SizedBox(height: 30),
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
                        onTap: () {},
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
