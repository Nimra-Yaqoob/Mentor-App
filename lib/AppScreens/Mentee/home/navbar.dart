import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mentorapp/AppScreens/Mentee/Chat(Mentee)/chatlist.dart';
import 'package:mentorapp/AppScreens/Mentee/home/menteeprofilepage.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:mentorapp/AppScreens/startingScreens/roleselection.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';

import 'menteehomepage.dart';
import 'settingpage.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final auth = FirebaseAuth.instance;
  Map<String, dynamic>? menteeData;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null &&
        auth.currentUser!.providerData[0].providerId == 'google.com') {
      // If the user logged in using Google, fetch Google user data
      fetchGoogleUserData();
    } else {
      // Otherwise, fetch regular Mentee data
      fetchMenteeData();
    }
  }

  Future<void> fetchGoogleUserData() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        setState(() {
          menteeData = {
            'username': googleSignInAccount.displayName,
            'email': googleSignInAccount.email,
            // Add other necessary details
          };
        });
      }
    } catch (e) {
      print('Error fetching Google user data: $e');
    }
  }

  void fetchMenteeData() {
    String userId = SessionManager.getUserId();
    FirebaseFirestore.instance
        .collection('mentees')
        .doc(userId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          menteeData = snapshot.data() as Map<String, dynamic>?;
        });
      } else {
        // Handle the case where the document doesn't exist
        print('Mentee not found.');
      }
    }).catchError((error) {
      // Handle errors that occurred during the fetch operation
      print('Error fetching Mentee data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(menteeData?['username'] ?? ''),
            accountEmail: Text(menteeData?['email'] ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(menteeData?['imageUrl'] ?? ''),
            ),
            decoration: BoxDecoration(
              color: GreenColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MenteeHome(),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Profile"),
            onTap: () {
              String userId = SessionManager.getUserId();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userId: userId),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.wechat),
            title: Text("Messages"),
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ChatsListPage(),
            )),
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text("Settings"),
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const SettingPage(),
            )),
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
                _googleSignIn.signOut();
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
