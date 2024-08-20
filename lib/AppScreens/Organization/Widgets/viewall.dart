import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/Organization/Widgets/mentorcard.dart';
import 'package:mentorapp/AppScreens/constant.dart';

class ViewAllMentors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Mentors',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                OrganizationMentors(), // Reuse the existing OrganizationMentors widget
          ),
        ],
      ),
    );
  }
}
