import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mentorapp/AppScreens/Meeting/meetinghome.dart';
import 'package:mentorapp/AppScreens/Mentee/home/Widgets/actionbutton.dart';
import 'package:mentorapp/AppScreens/Mentee/home/Widgets/allmentors.dart';
import 'package:mentorapp/AppScreens/Mentee/home/Widgets/navdrawer.dart';
import 'package:mentorapp/AppScreens/Mentee/home/followed.dart';
import 'package:mentorapp/AppScreens/chat/chathome.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';
import 'Widgets/slider.dart';
import 'categories/academiapage.dart';
import 'categories/businesspage.dart';
import 'menteeprofilepage.dart';
import 'mentorcard.dart';

class MenteeHome extends StatefulWidget {
  const MenteeHome({Key? key}) : super(key: key);

  @override
  State<MenteeHome> createState() => _MenteeHomeState();
}

class _MenteeHomeState extends State<MenteeHome> {
  String _searchQuery = '';
  late String _profilePictureUrl = '';
  late String _userId = '';

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  // Function to initialize user data
  void _initializeUserData() async {
    _userId = await SessionManager.getUserId();
    _fetchProfilePictureAndName();
  }

  // Function to fetch profile picture and name
  void _fetchProfilePictureAndName() async {
    DocumentSnapshot? userDoc = await _fetchUserDetailsFromFirestore(_userId);
    if (userDoc != null && userDoc.exists) {
      setState(() {
        _profilePictureUrl = userDoc['imageUrl'] ?? '';
      });
    }
  }

  // Function to fetch user details from Firestore
  Future<DocumentSnapshot?> _fetchUserDetailsFromFirestore(
      String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('mentees')
          .doc(userId)
          .get();
      return documentSnapshot;
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu, color: Colors.black),
          );
        }),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userId: _userId),
                ),
              );
            },
            child: CircleAvatar(
              radius: 25, // Adjust the radius as needed
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
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to MentorSpark',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                SliderWidget(),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search Mentors',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ActionButton(
                      iconData: Icons.school,
                      label: 'Academia',
                      backgroundColor: secondaryColor,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AcademiaMentorPage(
                            searchQuery: '',
                          ),
                        ));
                      },
                    ),
                    ActionButton(
                      iconData: Icons.business,
                      label: 'Business',
                      backgroundColor: secondaryColor!,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BusnissMentorPage(
                            searchQuery: '',
                          ),
                        ));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Mentors',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AllMentors(),
                          ),
                        );
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                MentorsList(searchQuery: _searchQuery),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: GNav(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: Colors.white,
          color: Colors.black,
          activeColor: Colors.white,
          tabBackgroundColor: primaryColor,
          gap: 8,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MenteeHome(),
                ),
              ),
            ),
            GButton(
              icon: Icons.event_available,
              text: 'Sessions',
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
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
              icon: Icons.group_add_outlined,
              text: 'Setting',
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => EnrolledMentorsList(
                    searchQuery: '',
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
