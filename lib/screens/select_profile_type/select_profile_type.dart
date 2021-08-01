import 'package:flutter/material.dart';
import 'package:task_bridge/others/my_colors.dart';
import 'package:task_bridge/screens/additional_info/additional_info.dart';
import 'package:task_bridge/screens/authentication/auth_manager.dart';

enum ProfileType { NORMAL, FREELANCER }

class SelectProfileType extends StatefulWidget {
  @override
  _SelectProfileTypeState createState() => _SelectProfileTypeState();
}

class _SelectProfileTypeState extends State<SelectProfileType> {
  Size? _size;

  ProfileType _selectedType = ProfileType.NORMAL;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile Type",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: MyColor.headingText,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Select your profile type.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "You can activate freelancer profile later too.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    _getTypeContainer(
                      title: "Normal",
                      message: "You want to hire",
                      type: ProfileType.NORMAL,
                      img: "assets/images/personal-trainer.png",
                    ),
                    SizedBox(width: 20),
                    _getTypeContainer(
                      title: "Freelancer",
                      message: "You want to work",
                      type: ProfileType.FREELANCER,
                      img: "assets/images/personal-trainer.png",
                    ),
                  ],
                ),
                SizedBox(height: 40),
                MaterialButton(
                  onPressed: _continue,
                  minWidth: double.infinity,
                  height: 55,
                  color: Colors.grey[200],
                  child: Text(
                    "Continue >",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColor.headingText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _continue() {
    if (_selectedType == ProfileType.NORMAL) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AuthManager(),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AdditionalInfo(),
      ),
    );
  }

  _getTypeContainer({
    required String title,
    required String message,
    required ProfileType type,
    required String img,
  }) {
    bool selected = (_selectedType == type);
    return Flexible(
      flex: 1,
      child: Material(
        elevation: selected ? 20 : 0,
        borderRadius: BorderRadius.circular(15),
        color: selected ? MyColor.primaryColor : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            setState(() {
              _selectedType = type;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            height: _size!.height * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: selected ? null : Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.asset(
                    "$img",
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  "$title",
                  style: TextStyle(
                    fontSize: 20,
                    color: selected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "$message",
                  style: TextStyle(
                    fontSize: 16,
                    color: selected ? Colors.white : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
