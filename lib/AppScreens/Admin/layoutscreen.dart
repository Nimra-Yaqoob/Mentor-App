import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/Admin/adminlogin.dart';
import 'package:mentorapp/AppScreens/startingScreens/loadingscreen.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.minWidth > 600) {
          return const AdminLogin();
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
