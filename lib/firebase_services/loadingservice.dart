import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/Mentee/home/menteehomepage.dart';
import 'package:mentorapp/AppScreens/startingScreens/onboarding.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';

class LoadingServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    Timer(
        Duration(seconds: 3),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => OnBoardingScreen())));
    // if (user != null) {
    //   SessionController().userId = user.uid.toString();
    //   Timer(
    //       const Duration(seconds: 3),
    //       () => Navigator.push(
    //           context, MaterialPageRoute(builder: (context) => MenteeHome())));
    // } else {

    // }
  }
}
