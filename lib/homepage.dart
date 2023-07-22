import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'CameraPage.dart';
import 'dataPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // Add the widgets for your different pages here
    // For example:
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: GNav(
        gap: 8,
        activeColor: Colors.black,
        color: Colors.grey[300],
        backgroundColor: Colors.green,
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
