import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:grow_buddy/constants/global_variables.dart';
import 'package:grow_buddy/features/crop_screen/crops_screen.dart';
import 'package:grow_buddy/features/profile_screen/profile_screen.dart';
import 'package:grow_buddy/features/disease_prediction_screen/disease_prediction_screen.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  List<Widget> pages = [
    const CropsScreen(),
    const DiseasePredictionScreen(),
    const ProfileScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // Home
          BottomNavigationBarItem(
            icon: SizedBox(
              width: bottomBarWidth,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: _page == 0
                    ? Image.asset(
                        "assets/images/money.png",
                        fit: BoxFit.fitHeight,
                        height: height * .04,
                      )
                    : Image.asset(
                        "assets/images/mon.png",
                        fit: BoxFit.fitHeight,
                        height: height * .04,
                      ),
              ),
            ),
            label: "Crops",
          ),
          // Account
          BottomNavigationBarItem(
            icon: SizedBox(
              width: bottomBarWidth,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: _page == 1
                    ? Image.asset(
                        "assets/images/selected_scanner.png",
                        fit: BoxFit.fitHeight,
                        height: height * .04,
                      )
                    : Image.asset(
                        "assets/images/scanner.png",
                        fit: BoxFit.fitHeight,
                        height: height * .04,
                      ),
              ),
            ),
            label: "Disease Detection",
          ),
          // Cart
          BottomNavigationBarItem(
            icon: SizedBox(
              width: bottomBarWidth,
              child: const badges.Badge(
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Colors.white,
                ),
                child: Icon(
                  Icons.person_outline_outlined,
                  size: 35,
                ),
              ),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
