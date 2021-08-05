import 'package:flutter/material.dart';
import 'package:task_bridge/others/my_colors.dart';

enum MyAlertType { LOADING, WARNING, SUCCESS, ERROR }

class MyAlerts extends StatefulWidget {
  final MyAlertType myAlertType;
  final String title;
  final String message;
  final String secondaryBtnTitle;
  final Function? secondaryBtnFunction;
  final String primaryBtnTitle;
  final Function? primaryBtnFunction;
  final bool allowBackBtn;
  MyAlerts(
    this.myAlertType, {
    this.title: "",
    this.message: "",
    this.secondaryBtnTitle: "",
    this.secondaryBtnFunction,
    this.primaryBtnTitle: "",
    this.primaryBtnFunction,
    this.allowBackBtn: true,
  });

  @override
  _MyAlertsState createState() => _MyAlertsState();
}

class _MyAlertsState extends State<MyAlerts> {
  Color? statusColor;
  IconData? statusIcon;

  @override
  void initState() {
    statusColor = _getStatusColor(widget.myAlertType);
    statusIcon = _getStatusIcon(widget.myAlertType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    // Using WillPopScope so that pressing backbutton does not dismiss the alertbox
    return WillPopScope(
      onWillPop: () => Future.value(widget.allowBackBtn),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: _size.width * 0.13,
                ),
                padding: EdgeInsets.fromLTRB(16, 32, 16, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 12),
                    if (widget.myAlertType == MyAlertType.LOADING)
                      CircularProgressIndicator(),
                    Text(
                      "${widget.title}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "${widget.message}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (widget.secondaryBtnTitle.isNotEmpty)
                          Flexible(
                            flex: 1,
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: () {
                                if (widget.secondaryBtnFunction != null)
                                  widget.secondaryBtnFunction!();
                                else {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text(
                                "${widget.secondaryBtnTitle}",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        if (widget.primaryBtnTitle.isNotEmpty)
                          Flexible(
                            flex: 1,
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: () {
                                if (widget.primaryBtnFunction != null)
                                  widget.primaryBtnFunction!();
                                else {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text(
                                "${widget.primaryBtnTitle}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: MyColor.primaryColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (widget.myAlertType != MyAlertType.LOADING)
              Positioned(
                top: -24,
                child: CircleAvatar(
                  minRadius: 16,
                  maxRadius: 28,
                  backgroundColor: statusColor,
                  child: Icon(
                    statusIcon,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _getStatusColor(MyAlertType myAlertType) {
    switch (myAlertType) {
      case MyAlertType.ERROR:
        return MyColor.kcRed;
      case MyAlertType.SUCCESS:
        return Colors.green;
      case MyAlertType.WARNING:
        return MyColor.kcOrange;
      default:
        return Colors.white;
    }
  }

  IconData _getStatusIcon(MyAlertType myAlertType) {
    switch (myAlertType) {
      case MyAlertType.ERROR:
        return Icons.close;
      case MyAlertType.WARNING:
        return Icons.warning_amber;
      default:
        return Icons.check;
    }
  }
}
