import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mentorapp/AppScreens/Mentor/Calender/sessioncalender.dart';
import 'package:mentorapp/AppScreens/Mentor/home%20page/introslider.dart';
import 'package:mentorapp/AppScreens/Mentor/home%20page/mentorprofile.dart';
import 'package:mentorapp/AppScreens/Mentor/home%20page/mentorsetting.dart';
import 'package:mentorapp/AppScreens/Mentor/home%20page/navdrawer.dart';
import 'package:mentorapp/AppScreens/chat/chathome.dart';
import 'package:mentorapp/AppScreens/constant.dart';

import 'package:mentorapp/firebase_services/session_manager.dart';

class MentorHomePage extends StatefulWidget {
  const MentorHomePage({Key? key}) : super(key: key);

  @override
  State<MentorHomePage> createState() => _MentorHomePageState();
}

class _MentorHomePageState extends State<MentorHomePage> {
  String _profilePictureUrl = '';
  String _userId = '';
  String _userName = ''; // Add a variable to store the user's name
  List<String> enrolledMenteesImages = []; // List to store mentees' images

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  void _fetchUserId() async {
    _userId = SessionManager.getUserId();
    _fetchProfilePictureAndName(); // Fetch profile picture and name here
    _fetchEnrolledMenteesImages();
  }

  void _fetchProfilePictureAndName() async {
    DocumentSnapshot? userDoc = await _fetchUserDetailsFromFirestore(_userId);
    if (userDoc != null && userDoc.exists) {
      setState(() {
        _profilePictureUrl = userDoc['imageUrl'] ?? '';
        _userName = userDoc['fullName'] ?? 'user';

        // Save to SessionManager
        SessionManager.setUserImageUrl(_profilePictureUrl);
        SessionManager.setUserName(_userName);
      });
    }
  }

  Future<DocumentSnapshot?> _fetchUserDetailsFromFirestore(
      String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('mentors')
          .doc(userId)
          .get();
      return documentSnapshot;
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  Future<void> _fetchEnrolledMenteesImages() async {
    QuerySnapshot enrollmentsSnapshot = await FirebaseFirestore.instance
        .collection('mentors')
        .doc(_userId) // Assuming mentor ID is the same as user ID
        .collection('enrollments')
        .get();

    setState(() {
      enrolledMenteesImages = enrollmentsSnapshot.docs
          .map((doc) => doc['imageUrl'] as String)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu, color: Colors.black),
            );
          },
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MentorProfile(userId: _userId),
                ),
              );
            },
            child: CircleAvatar(
              radius: 25,
              backgroundImage: _profilePictureUrl.isNotEmpty
                  ? NetworkImage(_profilePictureUrl)
                  : null,
              child: _profilePictureUrl.isEmpty
                  ? Icon(Icons.person, color: Colors.white)
                  : null,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello ${SessionManager.getUserName()} !', // Display the user's name from SessionManager
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Furnish your skills with MentorSpark',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mentees Profiles',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    Icon(Icons.arrow_forward, color: secondaryColor),
                  ],
                ),
                SizedBox(height: 12),
                Container(
                  height: 60,
                  child: enrolledMenteesImages.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: enrolledMenteesImages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(enrolledMenteesImages[index]),
                                backgroundColor: Colors.grey,
                                child: null,
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'No mentees enrolled yet.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                ),
                SizedBox(height: 16),
                SliderWidget(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
          child: GNav(
            padding: EdgeInsets.all(9),
            backgroundColor: Colors.white,
            color: Colors.black54,
            activeColor: Colors.white,
            tabBackgroundColor: primaryColor,
            gap: 8,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MentorHomePage(),
                  ),
                ),
              ),
              GButton(
                icon: Icons.event_available,
                text: 'Sessions',
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CalendarPage(),
                  ),
                ),
              ),
              GButton(
                icon: Icons.message_rounded,
                text: 'Inbox',
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ChatHome(),
                  ),
                ),
              ),
              GButton(
                icon: Icons.settings_outlined,
                text: 'Setting',
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MentorSetting(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
