import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/authentication/auth.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/models/user/user_model.dart';
import 'package:task_bridge/others/loading_dialog/loading_dialog.dart';
import 'package:task_bridge/others/my_colors.dart';
import 'package:task_bridge/screens/additional_info/tags_screen.dart';
import 'package:task_bridge/screens/authentication/auth_manager.dart';

class OtpDialog extends StatefulWidget {
  final String phoneNo;
  final String state;
  final String city;
  final DateTime dob;
  final String gender;
  String verificationId;
  OtpDialog({
    required this.verificationId,
    required this.phoneNo,
    required this.state,
    required this.city,
    required this.dob,
    required this.gender,
  });

  @override
  _OtpDialogState createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  TextEditingController _otpCtl = TextEditingController();
  User? _user;
  bool _resendOtp = false;
  Duration _countDown = Duration(minutes: 3);

  AuthService? _auth;

  Timer? _timer;
  int _start = 175;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _resendOtp = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            _countDown = Duration(seconds: _start);
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<User?>(context);
    _auth = Provider.of<AuthService>(context);

    return AlertDialog(
      scrollable: true,
      title: Text(
        "Enter OTP",
        style: TextStyle(
          color: MyColor.headingText,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "An OTP is sent on +91 ${widget.phoneNo}",
            style: TextStyle(color: Colors.grey),
          ),
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
          Row(
            children: [
              TextButton(
                onPressed: _resendOtp ? _resendOtpBtn : null,
                child: Text("Resend OTP"),
              ),
              Text("${_countDown.toString().substring(3, 7)}"),
            ],
          ),
        ],
      ),
    );
  }

  _resendOtpBtn() async {
    setState(() {
      _resendOtp = false;
    });
    await _auth!.firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91${widget.phoneNo}",
      verificationCompleted: (PhoneAuthCredential credential) {
        print("VERIFICATION COMPLETE");
      },
      verificationFailed: (err) {
        print(err);
      },
      codeSent: (vID, _) async {
        Flushbar(
          message: "OTP Resent.",
          duration: Duration(seconds: 3),
        ).show(context);
        widget.verificationId = vID;

        // Reset timer
        _start = 175;
        startTimer();
      },
      codeAutoRetrievalTimeout: (_) {},
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
      await Database().addAdditionalInfoAndSwitchToFreelancer(
        uid: _user!.uid,
        name: _user?.displayName ?? "",
        photoUrl: _user?.photoURL ?? UserModel.defaultPhotoUrl,
        state: widget.state,
        city: widget.city,
        dob: widget.dob,
        gender: widget.gender,
      );
      UserModel.isFreelancer = true;
      Navigator.popUntil(context, (route) => false);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TagsScreen(
            uid: _user!.uid,
            state: widget.state,
            city: widget.city,
          ),
        ),
      );
    }
  }
}
