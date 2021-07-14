import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_bridge/models/authentication/auth.dart';

class ProfileDialog extends StatefulWidget {
  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  TextEditingController? _emailController;

  TextEditingController? _panController = new TextEditingController();

  double circleRadius = 100.0;

  bool imageLoaded = false;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    _emailController = new TextEditingController(text: user?.email ?? "");
    Size _size = MediaQuery.of(context).size;
    return AlertDialog(
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: Container(
        width: _size.width,
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: circleRadius / 2.8,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                            top: circleRadius + 20,
                            left: 15,
                            right: 15,
                            bottom: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                readOnly: true,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: _getBorder(),
                                  enabledBorder: _getBorder(),
                                ),
                              ),
                              // SizedBox(height: 20),
                              // Text(
                              //   "Pan CRN",
                              //   style: TextStyle(fontWeight: FontWeight.w800),
                              // ),
                              // SizedBox(height: 10),
                              // TextField(
                              //   controller: _panController,
                              //   decoration: InputDecoration(
                              //     border: _getBorder(),
                              //     enabledBorder: _getBorder(),
                              //     labelText: "Enter Pan No.",
                              //     floatingLabelBehavior:
                              //         FloatingLabelBehavior.never,
                              //   ),
                              // ),
                              SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xff4C7EFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  onPressed: _activateFreelancerAccount,
                                  child: Text(
                                    "Activate Freelancer account",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xffFF4C4C),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    AuthService().signOut();
                                  },
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: circleRadius,
                            height: circleRadius,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: imageLoaded
                                  ? Colors.transparent
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 5.0),
                                )
                              ],
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () async {
                                final PickedFile? file = await ImagePicker()
                                    .getImage(source: ImageSource.gallery);
                                if (file != null) {}
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: (user != null)
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          user.photoURL ??
                                              "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.i3A68YOaeKJvLzd9fe3C7AHaEo%26pid%3DApi&f=1",
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            int expectedTotalBytes =
                                                loadingProgress
                                                        ?.expectedTotalBytes ??
                                                    1;
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        expectedTotalBytes
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Center(
                                        child: Container(
                                          child: Icon(Icons.person),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${user?.displayName ?? ''}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10),
                              Material(
                                color: Color(0xffDDDDDD),
                                borderRadius: BorderRadius.circular(5),
                                child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.edit_outlined, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black, width: 1.5),
    );
  }

  _activateFreelancerAccount() async {
    // String _panNo = _panController?.text ?? "";
    // if (_panNo == "") {
    //   await Flushbar(
    //     title: "Error",
    //     message: "Pan No is required to activate Freelancer account!",
    //     messageSize: 16,
    //     duration: Duration(seconds: 3),
    //   ).show(context);
    //   return;
    // }
  }
}
