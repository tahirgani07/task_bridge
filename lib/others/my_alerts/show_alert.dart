import 'package:flutter/material.dart';
import 'package:task_bridge/others/my_alerts/my_alerts.dart';

class ShowAlert {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MyAlerts(
          MyAlertType.LOADING,
          message: "Please wait...",
          allowBackBtn: false,
        );
      },
    );
  }

  static void dismissLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void showSuccessDialog({
    required BuildContext context,
    String? title,
    String? message,
    String? primaryBtnTitle,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlerts(
          MyAlertType.SUCCESS,
          title: "${title ?? 'SUCCESS'}",
          message: "$message ?? ''",
          primaryBtnTitle: "${primaryBtnTitle ?? 'OK'}",
        );
      },
    );
  }

  static void showErrorDialog({
    required BuildContext context,
    String? title,
    String? message,
    String? primaryBtnTitle,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlerts(
          MyAlertType.ERROR,
          title: "${title ?? 'ERROR'}",
          message: "$message ?? ''",
          primaryBtnTitle: "${primaryBtnTitle ?? 'OK'}",
        );
      },
    );
  }

  static void showWarningDialog({
    required BuildContext context,
    String? title,
    String? message,
    String? primaryBtnTitle,
    Function? primaryBtnFunction,
    String? secondaryBtnTitle,
    Function? secondaryBtnFunction,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlerts(
          MyAlertType.WARNING,
          title: "${title ?? 'WARNING'}",
          message: "${message ?? ''}",
          primaryBtnTitle: "${primaryBtnTitle ?? 'OK'}",
          primaryBtnFunction: primaryBtnFunction,
          secondaryBtnTitle: "${secondaryBtnTitle ?? 'Cancel'}",
          secondaryBtnFunction: secondaryBtnFunction,
        );
      },
    );
  }
}
