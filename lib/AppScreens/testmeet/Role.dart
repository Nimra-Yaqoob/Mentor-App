import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorapp/AppScreens/testmeet/joinButton.dart';
import 'package:mentorapp/AppScreens/testmeet/meeting_list.dart';
import 'package:mentorapp/AppScreens/testmeet/create_meeting_page.dart'; // Import CreateMeetingPage
import 'package:mentorapp/firebase_services/session_manager.dart';

class Role extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Role> {
  bool _isMentee = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    String userID = SessionManager.getUserId();

    try {
      // Check if the user is a mentee
      DocumentSnapshot menteeDoc = await FirebaseFirestore.instance
          .collection('mentees')
          .doc(userID)
          .get();
      if (menteeDoc.exists) {
        setState(() {
          _isMentee = true;
          _loading = false; // Loading complete
        });
        // Redirect to MeetingList directly
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => JoinMeetingButton(),
          ),
        );
        return;
      }

      // Check if the user is a mentor
      DocumentSnapshot mentorDoc = await FirebaseFirestore.instance
          .collection('mentors')
          .doc(userID)
          .get();
      if (mentorDoc.exists) {
        setState(() {
          _isMentee = false;
          _loading = false; // Loading complete
        });
        // Redirect to CreateMeetingPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CreateMeetingPage(),
          ),
        );
        return;
      }

      // Check if the user is in organizations (if needed)
      DocumentSnapshot organizationDoc = await FirebaseFirestore.instance
          .collection('organizations')
          .doc(userID)
          .get();
      if (organizationDoc.exists) {
        setState(() {
          _isMentee = false;
          _loading = false; // Loading complete
        });
        // Redirect to CreateMeetingPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CreateMeetingPage(),
          ),
        );
        return;
      }

      // Default to loading state if role is not found
      setState(() {
        _isMentee = false;
        _loading = false; // Loading complete
      });
    } catch (e) {
      print("Error fetching user role: $e");
      setState(() {
        _loading = false; // Stop loading even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Container(), // Empty container since redirection happens in initState
    );
  }
}
