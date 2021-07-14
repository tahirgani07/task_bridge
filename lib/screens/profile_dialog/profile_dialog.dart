import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/authentication/auth.dart';
import 'package:task_bridge/models/user/user_model.dart';

class ProfileDialog extends StatefulWidget {
  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  TextEditingController? _emailController;
  double circleRadius = 100.0;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
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

                      //// Profile Picture
                      Column(
                        children: [
                          Container(
                            width: circleRadius,
                            height: circleRadius,
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
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () async => await _updateProfilePic(user),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: (user != null)
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          user.photoURL ??
                                              UserModel.defaultPhotoUrl,
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

  _showLoadingAlertDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 200,
          width: 200,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: CircularProgressIndicator(),
                height: 30,
                width: 30,
              ),
              SizedBox(height: 10),
              Text("Please wait...")
            ],
          ),
        ),
      ),
    );
  }

  _updateProfilePic(User? user) async {
    _showLoadingAlertDialog();
    final PickedFile? file =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (file != null) {
      bool success = await UserModel.updateProfilePhoto(File(file.path), user!);

      if (success) {
        Navigator.of(context).pop();
        return;
      }
    }
    Navigator.of(context).pop();
  }

  _getBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black, width: 1.5),
    );
  }

  _activateFreelancerAccount() async {}
}
