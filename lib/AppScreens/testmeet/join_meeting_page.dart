import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/testmeet/zego_service.dart';

class JoinMeetingPage extends StatefulWidget {
  @override
  _JoinMeetingPageState createState() => _JoinMeetingPageState();
}

class _JoinMeetingPageState extends State<JoinMeetingPage> {
  final _meetingIDController = TextEditingController();

  Future<Widget> _getMeetingWidget(String meetingID) async {
    // Initialize ZegoService and call joinMeeting
    return await ZegoService().joinMeeting(meetingID);
  }

  void _joinMeeting() {
    final meetingID = _meetingIDController.text;

    if (meetingID.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FutureBuilder<Widget>(
            future: _getMeetingWidget(meetingID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  appBar: AppBar(title: Text('Joining Meeting')),
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Scaffold(
                  appBar: AppBar(title: Text('Error')),
                  body: Center(
                      child: Text('Error joining meeting: ${snapshot.error}')),
                );
              } else if (snapshot.hasData) {
                return snapshot.data!;
              } else {
                return Scaffold(
                  appBar: AppBar(title: Text('Error')),
                  body: Center(child: Text('No data available')),
                );
              }
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Join Meeting')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _meetingIDController,
              decoration: InputDecoration(labelText: 'Enter Meeting ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinMeeting,
              child: Text('Join Meeting'),
            ),
          ],
        ),
      ),
    );
  }
}
