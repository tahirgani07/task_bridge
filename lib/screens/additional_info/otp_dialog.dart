import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/models/user/user_model.dart';
import 'package:task_bridge/others/loading_dialog/loading_dialog.dart';
import 'package:task_bridge/others/my_colors.dart';
import 'package:task_bridge/screens/authentication/auth_manager.dart';

class OtpDialog extends StatefulWidget {
  final String verificationId;
  OtpDialog(this.verificationId);

  @override
  _OtpDialogState createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  TextEditingController _otpCtl = TextEditingController();
  User? _user;

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<User?>(context);
    return AlertDialog(
      scrollable: true,
      title: Text(
        "Enter OTP",
        style: TextStyle(
          color: MyColor.headingText,
        ),
      ),
      content: Column(
        children: [
          TextField(
            controller: _otpCtl,
            maxLength: 6,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              counterText: "",
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              letterSpacing: 15,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          SizedBox(height: 20),
          MaterialButton(
            height: 55,
            minWidth: double.infinity,
            color: MyColor.primaryColor,
            onPressed: _verifyAndLink,
            child: Text(
              "Proceed",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _verifyAndLink() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: _otpCtl.text);
    bool success = true;
    LoadingDialog.showLoadingDialog(context);
    try {
      await _user!.linkWithCredential(credential);
    } catch (err) {
      success = false;
      LoadingDialog.dismissLoadingDialog(context);
      Flushbar(
        title: "ERROR",
        message: "${err.toString()}",
        duration: Duration(seconds: 3),
      ).show(context);
    }
    if (success) {
      LoadingDialog.dismissLoadingDialog(context);
      await Database().switchUserToFreelancer(_user!.uid);
      UserModel.isFreelancer = true;
      Navigator.popUntil(context, (route) => false);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AuthManager()));
    }
  }
}
