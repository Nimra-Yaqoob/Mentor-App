import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorapp/AppScreens/Admin/pending.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);
  static const String id = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  child: Card(
                    elevation: 3,
                    color: Colors.lightBlue[100], // Change card color
                    child: SizedBox(
                      width: 150, // Adjust width as needed
                      height: 100, // Adjust height as needed
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.people,
                                    size: 30, color: Colors.blue), // Add icon
                                SizedBox(width: 10),
                                Text(
                                  'Total Users',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('mentors')
                                  .snapshots(),
                              builder: (context, mentorsSnapshot) {
                                if (mentorsSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                final mentorsCount =
                                    mentorsSnapshot.data!.docs.length;
                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('mentees')
                                      .snapshots(),
                                  builder: (context, menteesSnapshot) {
                                    if (menteesSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    final menteesCount =
                                        menteesSnapshot.data!.docs.length;
                                    return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('organizations')
                                          .snapshots(),
                                      builder:
                                          (context, organizationsSnapshot) {
                                        if (organizationsSnapshot
                                                .connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        final organizationsCount =
                                            organizationsSnapshot
                                                .data!.docs.length;
                                        final totalUsersCount = mentorsCount +
                                            menteesCount +
                                            organizationsCount;
                                        return Row(
                                          children: [
                                            Icon(Icons.group,
                                                size: 20,
                                                color: Colors.blue), // Add icon
                                            SizedBox(width: 5),
                                            Text(totalUsersCount.toString()),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to pending organization screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PendingOrganizationList(),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    color: Colors.lightGreen[100], // Change card color
                    child: SizedBox(
                      width: 150, // Adjust width as needed
                      height: 100, // Adjust height as needed
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.pending,
                                    size: 30, color: Colors.green), // Add icon
                                SizedBox(width: 10),
                                Text(
                                  'Pending Users',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('pending')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Text('0');
                                }
                                final pendingUsers = snapshot.data!.docs.length;
                                return Row(
                                  children: [
                                    Icon(Icons.timer,
                                        size: 20,
                                        color: Colors.green), // Add icon
                                    SizedBox(width: 5),
                                    Text(pendingUsers.toString()),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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
