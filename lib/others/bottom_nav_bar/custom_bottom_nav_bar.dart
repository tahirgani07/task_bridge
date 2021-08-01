import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/bottom_nav_bar/bottom_nav_bar_model.dart';

class CustomBottomNavBar extends StatefulWidget {
  final bool isFreelancer;
  const CustomBottomNavBar({this.isFreelancer: false});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  Color selectedColor = Color(0xff4EC4FE);
  Color normalColor = Color(0xffA0A8B6);
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    BottomNavBarModel _bottomNavBarModel =
        Provider.of<BottomNavBarModel>(context);
    currentIndex = _bottomNavBarModel.getCurrentScreenIndex();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.fromLTRB(20, 0, 20, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: Color(0xff181818),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isFreelancer
              ? _getNavBarIconItem(
                  icon: Icons.dashboard,
                  onPressed: () => _bottomNavBarModel.changeScreen(-1),
                  index: -1,
                  size: 30,
                )
              : Container(),
          // _getNavBarImageItem(
          //   width: 25,
          //   height: 25,
          //   name: "assets/images/home-icon.svg",
          //   onPressed: () => _bottomNavBarModel.changeScreen(0),
          //   index: 0,
          // ),
          _getNavBarIconItem(
            icon: Icons.search,
            onPressed: () => _bottomNavBarModel.changeScreen(0),
            index: 0,
            size: 32,
          ),
          _getNavBarImageItem(
            width: 27,
            height: 27,
            name: "assets/images/message-icon.svg",
            onPressed: () => _bottomNavBarModel.changeScreen(1),
            index: 1,
          ),
          // _getNavBarIconItem(
          //   icon: Icons.event_outlined,
          //   onPressed: () => _bottomNavBarModel.changeScreen(2),
          //   index: 2,
          //   size: 30,
          // ),
          _getNavBarIconItem(
            icon: Icons.bookmark_outline,
            onPressed: () => _bottomNavBarModel.changeScreen(3),
            index: 3,
            size: 30,
          ),
        ],
      ),
    );
  }

  _getNavBarIconItem({
    IconData? icon,
    Color? color,
    Function()? onPressed,
    double size: 30,
    int? index,
  }) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        child: Icon(
          icon,
          size: size,
          color: currentIndex == index ? selectedColor : normalColor,
        ),
      ),
    );
  }

  _getNavBarImageItem({
    required String name,
    Color? color,
    Function()? onPressed,
    double? height,
    double? width,
    int? index,
  }) {
    bool setColor = false;
    // If the user is not a freelancer then at the start the current index will always be -1.
    if (!widget.isFreelancer && index == 0 && currentIndex == -1)
      setColor = true;
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        child: SizedBox(
          width: width,
          height: height,
          child: SvgPicture.asset(
            name,
            color: (setColor || currentIndex == index)
                ? selectedColor
                : normalColor,
          ),
        ),
      ),
    );
  }
}
