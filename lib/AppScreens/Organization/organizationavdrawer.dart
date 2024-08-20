import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/Organization/organizationhome.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:mentorapp/AppScreens/startingScreens/roleselection.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';
import 'organizationprofile.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  final auth = FirebaseAuth.instance;
  Map<String, dynamic>? organizationData;

  @override
  void initState() {
    super.initState();
    fetchOrganizationData();
  }

  void fetchOrganizationData() {
    String userId = SessionManager.getUserId();
    FirebaseFirestore.instance
        .collection('organizations')
        .doc(userId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          organizationData = snapshot.data() as Map<String, dynamic>?;
        });
      } else {
        throw Exception('Organization not found.');
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
            accountName: Text(organizationData?['username'] ?? ''),
            accountEmail: Text(organizationData?['email'] ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  NetworkImage(organizationData?['imageUrl'] ?? ''),
            ),
            decoration: BoxDecoration(
              color: GreenColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => OrganizationHome(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Profile"),
            onTap: () {
              String userId = SessionManager.getUserId();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => OrganizationProfile(userId: userId),
                ),
              );
            },
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

          // Other ListTiles for different navigation options...
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              auth.signOut().then((value) {
                SessionController().userId = '';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoleSelection(),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
