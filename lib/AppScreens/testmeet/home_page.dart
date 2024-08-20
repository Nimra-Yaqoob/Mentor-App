import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/testmeet/join_meeting_page.dart';
import 'package:mentorapp/AppScreens/testmeet/meeting_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeetingList(),
                ),
              );
            },
            child: Text('View Meetings'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JoinMeetingPage(),
                ),
              );
            },
            child: Text('Join a Meeting'),
          ),
        ],
      ),
    );
  }
}
