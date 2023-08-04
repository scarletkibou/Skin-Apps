import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'CameraPage.dart';
import 'dataPage.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showSplash = true;
  late PersistentTabController _controller;

  List<Widget> _buildScreens() {
    return [
      dataPage(),
      CameraPage(),
      Container(
        color: Colors.white,
        child: Center(
          child: Text('Settings Page'),
        ),
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey.shade100,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.camera_alt,
          color: Colors.grey.shade100,
        ),
        inactiveIcon: Icon(
          Icons.camera_alt_outlined,
          color: Colors.grey.shade100,
        ),
        activeColorPrimary: Colors.red,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("setting"),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey.shade100,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
    _controller = PersistentTabController();
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash
        ? SplashScreen()
        : Scaffold(
            bottomNavigationBar: PersistentTabView(
              context,
              controller: _controller,
              screens: _buildScreens(),
              items: _navBarsItems(),
              confineInSafeArea: true,
              backgroundColor: Color(0xFF398378), // Default is Colors.white.
              handleAndroidBackButtonPress: true, // Default is true.
              resizeToAvoidBottomInset:
                  true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: true, // Default is true.
              hideNavigationBarWhenKeyboardShows:
                  true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(10.0),
                colorBehindNavBar: Color.fromARGB(255, 45, 3, 3),
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: const ItemAnimationProperties(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle
                  .style15, // Choose the nav bar style with this property.
            ),
          );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF398378),
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
