import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_bridge/models/bottom_nav_bar/bottom_nav_bar_model.dart';
import 'package:task_bridge/others/bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:task_bridge/screens/home/home_screen.dart';
import 'package:task_bridge/screens/test2.dart';

class ScreenManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => BottomNavBarModel(),
        builder: (context, _) {
          int currentScreenIndex =
              Provider.of<BottomNavBarModel>(context).getCurrentScreenIndex();

          Widget currentScreen;

          switch (currentScreenIndex) {
            case 0:
              currentScreen = HomeScreen();
              break;
            default:
              currentScreen = Test2();
              break;
          }
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        top: 0,
                        left: 0,
                        child: currentScreen,
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: CustomBottomNavBar(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
