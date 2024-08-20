import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/Mentor/Chat(Mentor)/Chat(Mentor)/chatlist.dart';
import 'package:mentorapp/AppScreens/Mentor/home%20page/mentorhomepage.dart';
import 'package:mentorapp/AppScreens/Mentor/home%20page/mentorsetting.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:mentorapp/AppScreens/startingScreens/roleselection.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'mentorprofile.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final auth = FirebaseAuth.instance;
  Map<String, dynamic>? mentorData;

  @override
  void initState() {
    super.initState();
    fetchMentorData();
  }

  void fetchMentorData() {
    String userId = SessionManager.getUserId();
    FirebaseFirestore.instance
        .collection('mentors')
        .doc(userId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          mentorData = snapshot.data() as Map<String, dynamic>?;
        });
      } else {
        throw Exception('Mentor not found.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(mentorData?['fullName'] ?? ''),
            accountEmail: Text(mentorData?['email'] ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(mentorData?['imageUrl'] ?? ''),
            ),
            decoration: BoxDecoration(
              color: secondaryColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const MentorHomePage(),
            )),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Profile"),
            onTap: () {
              String userId = SessionManager.getUserId();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MentorProfile(userId: userId),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.wechat),
            title: Text("Messages"),
            onTap: () {
              String userId = SessionManager.getUserId();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ChatsListPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text("Settings"),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MentorSetting(),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text("Help"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Help"),
                    content: Text(
                      "Need assistance? Contact our support team at support@example.com.",
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("About Us"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("About Us"),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Our App",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "We are dedicated to providing a platform for mentors and mentees to connect and grow together.",
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Contact Information",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Email: info@example.com\nPhone: +123456789",
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              auth.signOut().then((value) {
                SessionController().userId = "";
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RoleSelection()));
              });
            },
          ),
        ],
      ),
    );
  }
}
