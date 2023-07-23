import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'CameraPage.dart';
import 'dataPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _showSplash =
      true; // Add a boolean flag to control the splash screen visibility

  final List<Widget> _pages = [
    dataPage(),
    CameraPage(),
    Container(
      color: Colors.white,
      child: Center(
        child: Text('Settings Page'),
      ),
    ),
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 6), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash
        ? SplashScreen()
        : Scaffold(
            body: _pages[_selectedIndex],
            bottomNavigationBar: GNav(
              gap: 8,
              activeColor: Colors.black,
              color: Colors.grey[300],
              backgroundColor: Color(0xFF398378),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.camera_enhance_outlined,
                  text: 'Camera',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: _onTabChange,
            ),
          );
  }
}

class SplashScreen extends StatelessWidget {
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
