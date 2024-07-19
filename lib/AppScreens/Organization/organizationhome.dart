// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:flutter/services.dart';
// import 'package:mentorapp/AppScreens/Organization/mentorcard.dart';
// import 'dart:math';

// import 'package:mentorapp/firebase_services/session_manager.dart';
// import 'package:mentorapp/AppScreens/Organization/organizationavdrawer.dart';
// import 'package:mentorapp/AppScreens/Organization/organizationprofile.dart';
// import 'package:mentorapp/AppScreens/chat/chathome.dart';
// import 'package:mentorapp/AppScreens/constant.dart';

// class OrganizationHome extends StatefulWidget {
//   @override
//   State<OrganizationHome> createState() => _OrganizationHomeState();
// }

// class _OrganizationHomeState extends State<OrganizationHome> {
//   String? profileImageUrl;
//   String? organizationName;
//   String? userName;
//   String? userId;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   // Function to fetch user's data
//   void fetchUserData() async {
//     try {
//       // Retrieve the user ID using SessionManager
//       userId = SessionManager.getUserId();

//       if (userId != null && userId!.isNotEmpty) {
//         // Retrieve the user's document from Firestore
//         DocumentSnapshot<Map<String, dynamic>> snapshot =
//             await FirebaseFirestore.instance
//                 .collection('organizations')
//                 .doc(userId)
//                 .get();

//         // Check if the document exists and contains the organization's name
//         if (snapshot.exists && snapshot.data()?['organizationName'] != null) {
//           setState(() {
//             // Update the organizationName variable
//             organizationName = snapshot.data()?['organizationName'];
//           });
//         }

//         // Fetch user's name using SessionManager
//         userName = await SessionManager.getUserName();
//       } else {
//         print('Error: User ID not found in SessionManager');
//       }
//     } catch (error) {
//       print('Error fetching user data: $error');
//     }
//   }

//   // Function to generate a random alphanumeric code
//   String generateRandomCode(int length) {
//     const chars =
//         'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
//     Random rnd = Random();
//     return String.fromCharCodes(Iterable.generate(
//         length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
//   }

//   // Function to handle share button press
//   void handleShare() {
//     if (userId != null) {
//       String randomCode =
//           generateRandomCode(10); // Generate a random code of length 10
//       String uniqueCode =
//           '$userId-$randomCode'; // Concatenate userId and random code
//       Clipboard.setData(
//           ClipboardData(text: uniqueCode)); // Copy the code to clipboard
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               'Unique code copied to clipboard: $uniqueCode. Use this code to share your organization details.'),
//           action: SnackBarAction(
//             label: 'OK',
//             onPressed: () {},
//           ),
//         ),
//       ); // Show a snackbar with the code
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: User ID not found. Please try again.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: NavDrawer(),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: Builder(
//           builder: (context) {
//             return IconButton(
//               onPressed: () => Scaffold.of(context).openDrawer(),
//               icon: Icon(Icons.menu, color: Colors.black),
//             );
//           },
//         ),
//         actions: [
//           // Share button
//           IconButton(
//             icon: Icon(Icons.share, color: Colors.black),
//             onPressed: handleShare,
//           ),
//           // Wrap the CircleAvatar with GestureDetector for navigation
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: GestureDetector(
//               onTap: () {
//                 String userId = SessionManager.getUserId();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => OrganizationProfile(
//                       userId: userId,
//                     ), // Navigate to profile page
//                   ),
//                 );
//               },
//               child: CircleAvatar(
//                 backgroundColor:
//                     Colors.grey, // Background color for the circular avatar
//                 child: profileImageUrl != null
//                     ? ClipOval(
//                         child: Image.network(
//                           profileImageUrl!,
//                           fit: BoxFit.cover,
//                           width: 36,
//                           height: 36,
//                         ),
//                       )
//                     : Icon(Icons.person, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: EdgeInsets.all(16.0),
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Welcome to MentorSpark, ${organizationName ?? ""}', // Display the organization's name
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(height: 16.0),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               'Mentors',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: OrganizationMentors(),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         margin: EdgeInsets.all(8),
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 8,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: GNav(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           backgroundColor: Colors.white,
//           color: Colors.black,
//           activeColor: Colors.white,
//           tabBackgroundColor: primaryColor,
//           gap: 8,
//           tabs: [
//             GButton(
//               icon: Icons.home,
//               text: 'Home',
//               onPressed: () => Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (context) => OrganizationHome(),
//                 ),
//               ),
//             ),
//             GButton(
//               icon: Icons.message_rounded,
//               text: 'Inbox',
//               onPressed: () => Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (context) => ChatHome(),
//                 ),
//               ),
//             ),
//             GButton(
//               icon: Icons.person,
//               text: 'Profile',
//               onPressed: () {
//                 String userId = SessionManager.getUserId();
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => OrganizationProfile(userId: userId),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
////////////
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/services.dart';
import 'package:mentorapp/AppScreens/Organization/mentorcard.dart';
import 'dart:math';

import 'package:mentorapp/firebase_services/session_manager.dart';
import 'package:mentorapp/AppScreens/Organization/organizationavdrawer.dart';
import 'package:mentorapp/AppScreens/Organization/organizationprofile.dart';
import 'package:mentorapp/AppScreens/chat/chathome.dart';
import 'package:mentorapp/AppScreens/constant.dart';

class OrganizationHome extends StatefulWidget {
  @override
  State<OrganizationHome> createState() => _OrganizationHomeState();
}

class _OrganizationHomeState extends State<OrganizationHome> {
  String? profileImageUrl;
  String? organizationName;
  String? userName;
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Function to fetch user's data
  void fetchUserData() async {
    try {
      // Retrieve the user ID using SessionManager
      userId = SessionManager.getUserId();

      if (userId != null && userId!.isNotEmpty) {
        // Retrieve the user's document from Firestore
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('organizations')
                .doc(userId)
                .get();

        // Check if the document exists and contains the organization's name
        if (snapshot.exists && snapshot.data()?['organizationName'] != null) {
          setState(() {
            // Update the organizationName variable
            organizationName = snapshot.data()?['organizationName'];
          });
        }

        // Fetch user's name using SessionManager
        userName = await SessionManager.getUserName();
      } else {
        print('Error: User ID not found in SessionManager');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  // Function to generate a random alphanumeric code
  String generateRandomCode(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  // Function to handle share button press
  void handleShare() async {
    if (userId != null) {
      try {
        // Check if the unique code already exists in Firestore
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('organizations')
                .doc(userId)
                .get();

        String? uniqueCode = snapshot.data()?['uniqueCode'];

        // If the unique code does not exist, generate and save a new one
        if (uniqueCode == null) {
          String randomCode =
              generateRandomCode(10); // Generate a random code of length 10
          uniqueCode =
              '$userId-$randomCode'; // Concatenate userId and random code

          await FirebaseFirestore.instance
              .collection('organizations')
              .doc(userId)
              .update({'uniqueCode': uniqueCode});
        }

        // Copy the unique code to clipboard
        Clipboard.setData(ClipboardData(text: uniqueCode));

        // Show a snackbar with the code
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Unique code copied to clipboard: $uniqueCode. Use this code to share your organization details.'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      } catch (error) {
        print('Error checking/saving unique code in Firestore: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error saving unique code. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: User ID not found. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
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
          // Share button
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: handleShare,
          ),
          // Wrap the CircleAvatar with GestureDetector for navigation
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                String userId = SessionManager.getUserId();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrganizationProfile(
                      userId: userId,
                    ), // Navigate to profile page
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor:
                    Colors.grey, // Background color for the circular avatar
                child: profileImageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          profileImageUrl!,
                          fit: BoxFit.cover,
                          width: 36,
                          height: 36,
                        ),
                      )
                    : Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Welcome to MentorSpark, ${organizationName ?? ""}', // Display the organization's name
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Mentors',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: OrganizationMentors(),
          ),
        ],
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
                  builder: (context) => OrganizationHome(),
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
              icon: Icons.person,
              text: 'Profile',
              onPressed: () {
                String userId = SessionManager.getUserId();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => OrganizationProfile(userId: userId),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
