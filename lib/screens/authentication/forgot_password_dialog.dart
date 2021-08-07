import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/authentication/auth.dart';
import 'package:task_bridge/others/my_alerts/show_alert.dart';

class ForgotPasswordDialog extends StatefulWidget {
  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailCtl = TextEditingController();
  AuthService? _auth;
  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthService>(context);

    return AlertDialog(
      scrollable: true,
      title: Text("Enter your email to reset your password"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailCtl,
              autofocus: true,
              validator: _emailValidator,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _sendResetLink,
                child: Text("Send link"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;
    ShowAlert.showLoadingDialog(context);
    await _auth!.sendResetLink(_emailCtl.text);
    ShowAlert.dismissLoadingDialog(context);
    String er = _auth!.errorMessage;
    if (er.isNotEmpty) {
      Flushbar(
        title: "Error",
        message: er,
        duration: Duration(seconds: 3),
      ).show(context);
    } else {
      Navigator.of(context).pop();
      Flushbar(
        title: "Success",
        message: "Reset link sent! Check your email",
        duration: Duration(seconds: 3),
      ).show(context);
    }
  }

  String? _emailValidator(String? val) {
    val = val!.trim();
    val = val.trimLeft();
    val = val.trimRight();
    if (val.isEmpty) return "Please enter an email";

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(val)) return "Email is invalid";

    return null;
  }
}
