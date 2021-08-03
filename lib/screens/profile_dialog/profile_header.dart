import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_bridge/models/user/user_model.dart';
import 'package:task_bridge/others/loading_dialog/loading_dialog.dart';

class ProfileHeader extends StatefulWidget {
  final User? user;
  final String? photoUrl;
  final double radius;
  final Function? onTap;
  final String? state;
  final String? city;

  const ProfileHeader({
    this.user,
    required this.radius,
    this.onTap,
    this.photoUrl,
    this.state,
    this.city,
  });

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        width: widget.radius,
        height: widget.radius,
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
          onTap: () async {
            if (widget.user != null && widget.onTap == null)
              await _updateProfilePic(widget.user);
            else if (widget.onTap != null) widget.onTap!();
          },
          child: CircleAvatar(
            radius: widget.radius,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.user == null
                    ? widget.photoUrl!
                    : widget.user!.photoURL!,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                  value: downloadProgress.progress,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.contain,
                width: widget.radius,
                height: widget.radius,
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      print(e);
      return Container();
    }
  }

  _updateProfilePic(User? user) async {
    LoadingDialog.showLoadingDialog(context);
    final PickedFile? file =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (file != null) {
      bool success = await UserModel.updateProfilePhoto(
        File(file.path),
        user!,
        widget.state,
        widget.city,
      );
      if (!success) {
        print("Photo could not be updated");
      }
    }
    LoadingDialog.dismissLoadingDialog(context);
  }
}
