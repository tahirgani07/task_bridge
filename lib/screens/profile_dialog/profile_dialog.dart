import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController? _nameCt;
  FocusNode _nameFc = new FocusNode();
  bool _showEditNameTextField = false;

  @override
  void initState() {
    String name = Provider.of<User?>(context, listen: false)?.displayName ?? "";
    _nameCt = new TextEditingController(text: name);
    super.initState();
  }

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
                          child: _showEditNameTextField
                              ? _getEditNameColumn(
                                  nameCt: _nameCt!,
                                  nameFc: _nameFc,
                                  user: user!,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
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
                                    _getButton(
                                      title: "Activate Freelancer account",
                                      onPressed: () =>
                                          _activateFreelancerAccount(),
                                      color: Color(0xff4C7EFF),
                                    ),
                                    SizedBox(height: 20),
                                    _getButton(
                                        title: "Logout",
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          AuthService().signOut();
                                        },
                                        color: Color(0xffFF4C4C)),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: _getDisplayName(user!),
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
        builder: (context) {
          // Using WillPopScope so that pressing backbutton does not dismiss the alertbox
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
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
        });
  }

  _activateFreelancerAccount() async {}

  _updateDisplayName(User user) async {
    String newName = _nameCt?.text ?? "";
    newName = newName.trimLeft();
    newName = newName.trimRight();
    if (newName.trim() == "" || newName == user.displayName) {
      _nameCt!.clear();
      _updateShowEditNameTextField(false);
      return;
    }

    String title = "Successfull", message = "Name updated";
    _showLoadingAlertDialog();
    await user.updateDisplayName(newName).onError((error, stackTrace) {
      title = "Error";
      try {
        message = error.toString();
      } catch (e) {
        print(e);
      }
    });
    _updateShowEditNameTextField(false);
    // Get rid of the loading popup
    Navigator.of(context).pop();
    Flushbar(
      title: "$title",
      message: "$message",
      duration: Duration(seconds: 3),
    ).show(context);
  }

  _updateShowEditNameTextField(bool val) {
    setState(() {
      _showEditNameTextField = val;
    });
    if (val) _nameFc.requestFocus();
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

  _getButton({
    required String title,
    required Function() onPressed,
    Color color: Colors.blueAccent,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          "$title",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  _getEditNameColumn({
    required TextEditingController nameCt,
    required User user,
    required FocusNode nameFc,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Edit Name",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 10),
        TextField(
          controller: nameCt,
          focusNode: nameFc,
          decoration: InputDecoration(
            border: _getBorder(),
            enabledBorder: _getBorder(),
          ),
        ),
        SizedBox(height: 25),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: MaterialButton(
                onPressed: () => _updateShowEditNameTextField(false),
                color: Colors.red,
                height: 50,
                child: Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: MaterialButton(
                onPressed: () => _updateDisplayName(user),
                color: Colors.blueAccent,
                height: 50,
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _getDisplayName(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${user.displayName ?? ''}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 10),
        _showEditNameTextField
            ? Container()
            : Material(
                color: Color(0xffDDDDDD),
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  onTap: () => _updateShowEditNameTextField(true),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(Icons.edit_outlined, size: 18),
                  ),
                ),
              ),
      ],
    );
  }

  _getBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black, width: 1.5),
    );
  }
}
