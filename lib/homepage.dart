import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'CameraPage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        gap: 8,
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
        selectedIndex: 0,
        onTabChange: (index) {
          if (index == 1) {
            // Navigate to the CameraPage when the second button is pressed.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CameraPage()),
            );
          }
        },
      ),
    );
  }
}
