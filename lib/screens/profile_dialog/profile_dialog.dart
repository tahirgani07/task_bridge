import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/authentication/auth.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/models/user/user_model.dart';
import 'package:task_bridge/others/my_alerts/show_alert.dart';
import 'package:task_bridge/screens/additional_info/additional_info.dart';
import 'package:task_bridge/screens/profile_dialog/profile_header.dart';

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
    User? tempUser = Provider.of<User?>(context, listen: false);
    String name = tempUser?.displayName ?? "";
    _nameCt = new TextEditingController(text: name);
    _emailController = new TextEditingController(text: tempUser?.email ?? "");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    AuthService _auth = Provider.of<AuthService>(context);
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
                                    UserModel.isFreelancer
                                        ? Container()
                                        : SizedBox(height: 20),
                                    UserModel.isFreelancer
                                        ? Container()
                                        : _getButton(
                                            title:
                                                "Activate Freelancer account",
                                            onPressed: () =>
                                                _activateFreelancerAccount(),
                                            color: Color(0xff4C7EFF),
                                          ),
                                    SizedBox(height: 20),
                                    _getButton(
                                        title: "Logout",
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await _auth.signOut();
                                        },
                                        color: Color(0xffFF4C4C)),
                                  ],
                                ),
                        ),
                      ),

                      //// Profile Picture
                      Column(
                        children: [
                          ProfileHeader(
                            user: user,
                            radius: circleRadius,
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: _getDisplayName(user),
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

  _activateFreelancerAccount() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AdditionalInfo(),
      ),
    );
  }

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
    ShowAlert.showLoadingDialog(context);

    bool success = await Database().updateDisplayName(user, newName);
    if (!success) {
      title = "Error";
      message = "Something went wrong";
    }

    _updateShowEditNameTextField(false);
    // Get rid of the loading popup
    ShowAlert.dismissLoadingDialog(context);
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

  _getDisplayName(User? user) {
    return user == null
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${user.displayName}",
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
