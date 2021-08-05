import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:task_bridge/models/services/service_model.dart';
import 'package:task_bridge/others/my_alerts/show_alert.dart';
import 'package:task_bridge/others/my_colors.dart';
import 'package:task_bridge/screens/rating/rating_dialog.dart';

class ShowService extends StatefulWidget {
  final String combinedUid;
  final String loggedInUser;
  final String otherName;
  final Service service;
  ShowService({
    required this.service,
    required this.loggedInUser,
    required this.otherName,
    required this.combinedUid,
  });
  @override
  _ShowServiceState createState() => _ShowServiceState();
}

class _ShowServiceState extends State<ShowService> {
  bool serviceActive = true;
  bool curUserIsCreator = true;
  @override
  void didChangeDependencies() {
    serviceActive = widget.service.active;
    curUserIsCreator = widget.service.creatorUid == widget.loggedInUser;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              Text("${widget.service.name}"),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "\(${!serviceActive ? 'Not Active' : 'Active'}\)",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          Text(
            "Price - ${(widget.service.price < 0) ? 'Not set' : 'Rs.${widget.service.price}'}",
          ),
        ],
      ),
      actions: [
        if (!serviceActive && curUserIsCreator)
          // show Delete button
          MaterialButton(
            onPressed: _deleteService,
            color: Colors.red,
            textColor: Colors.white,
            child: Text(
              "Delete",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (serviceActive && !curUserIsCreator)
          // show completed button
          MaterialButton(
            onPressed: _serviceComplete,
            color: MyColor.primaryColor,
            textColor: Colors.white,
            child: Text(
              "Completed",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (!serviceActive && !curUserIsCreator)
          // show reject button
          MaterialButton(
            onPressed: () => _serviceComplete(rejected: true),
            color: Colors.red,
            textColor: Colors.white,
            child: Text(
              "Reject",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (!serviceActive && !curUserIsCreator)
          // show confirm button
          MaterialButton(
            onPressed: _onAccept,
            color: MyColor.primaryColor,
            textColor: Colors.white,
            child: Text(
              "Accept",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${widget.service.desc}"),
        ],
      ),
    );
  }

  _onAccept() async {
    ShowAlert.showLoadingDialog(context);
    await ServiceModel.acceptService(widget.combinedUid, widget.service);
    ShowAlert.dismissLoadingDialog(context);
    Navigator.of(context).pop();
    Flushbar(
      message: "Service accepted!",
      duration: Duration(seconds: 3),
    ).show(context);
  }

  _serviceComplete({bool rejected: false}) async {
    ShowAlert.showLoadingDialog(context);
    await ServiceModel.serviceCompleted(widget.combinedUid, widget.service);
    ShowAlert.dismissLoadingDialog(context);
    Navigator.of(context).pop();
    Flushbar(
      message: "Service completed!",
      duration: Duration(seconds: 3),
    ).show(context);
    if (!rejected) {
      // Rating
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => RatingDailog(
          widget.service.creatorUid,
          widget.otherName,
        ),
      );
    }
  }

  _deleteService() async {
    ShowAlert.showLoadingDialog(context);
    await ServiceModel.deleteService(widget.combinedUid, widget.service);
    ShowAlert.dismissLoadingDialog(context);
    Navigator.of(context).pop();
    Flushbar(
      message: "Service deleted successfully!",
      duration: Duration(seconds: 3),
    ).show(context);
  }
}
