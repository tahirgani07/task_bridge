import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LoadingDialog();
      },
    );
  }

  static void dismissLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
