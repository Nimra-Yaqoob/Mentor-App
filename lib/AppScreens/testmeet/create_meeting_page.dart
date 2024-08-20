import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:mentorapp/AppScreens/testmeet/meeting_list.dart';
import 'package:mentorapp/AppScreens/testmeet/meeting_service.dart';
import 'package:mentorapp/AppScreens/testmeet/zego_service.dart';
import 'package:uuid/uuid.dart'; // For generating unique meeting IDs

class CreateMeetingPage extends StatefulWidget {
  @override
  _CreateMeetingPageState createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  final _titleController = TextEditingController();
  late String _meetingID;

  @override
  void initState() {
    super.initState();
    _meetingID = Uuid()
        .v4(); // Generate unique meeting ID when the widget is initialized
  }

  void _createMeeting() async {
    final title = _titleController.text;

    if (title.isNotEmpty) {
      try {
        // Create the meeting in Firestore
        await MeetingService().createMeeting(title, _meetingID);

        // Navigate to the meeting page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FutureBuilder<Widget>(
              future: ZegoService().joinMeeting(_meetingID),
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
                        child:
                            Text('Error joining meeting: ${snapshot.error}')),
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
      } catch (e) {
        print(
            "Error creating meeting: $e"); // Print error message for debugging
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Meeting',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Meeting Title',
                labelStyle: TextStyle(color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Meeting ID: $_meetingID',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Changed to black
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: _createMeeting,
                icon: Icon(Icons.add_circle),
                label: Text(
                  'Create Meeting',
                  style:
                      TextStyle(color: Colors.white), // Text color set to white
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green, // Changed button color to green
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MeetingList(), // Navigate to MeetingList
                    ),
                  );
                },
                icon: Icon(Icons.list),
                label: Text('View Meeting List'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Changed button color to blue
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
