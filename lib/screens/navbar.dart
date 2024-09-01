import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newsapp/controllers/headlines_controller.dart';
import 'package:newsapp/controllers/network_controller.dart';
import 'package:newsapp/screens/explore.dart';
import 'package:newsapp/screens/headlines.dart';
import 'package:newsapp/screens/saved.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    Headlines(controller: HeadlinesController()),
    Explore(controller: HeadlinesController()),
    const Saved(),
  ];

  late NetworkController controller;

  @override
  Widget build(BuildContext context) {
    controller = NetworkController(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        margin: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
        onTap: (int i) {
          setState(() {
            _currentIndex = i;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: SvgPicture.asset('assets/navbar/headlines.svg'),
            activeIcon:
                SvgPicture.asset('assets/navbar/headlines_selected.svg'),
            title: Text(
              'Headlines',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.24,
              ),
            ),
          ),
          SalomonBottomBarItem(
            icon: SvgPicture.asset('assets/navbar/explore.svg'),
            activeIcon: SvgPicture.asset('assets/navbar/explore_selected.svg'),
            title: Text(
              'Explore',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.24,
              ),
            ),
          ),
          SalomonBottomBarItem(
            icon: SvgPicture.asset('assets/navbar/saved.svg'),
            activeIcon: SvgPicture.asset('assets/navbar/saved_selected.svg'),
            title: Text(
              'Saved',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
