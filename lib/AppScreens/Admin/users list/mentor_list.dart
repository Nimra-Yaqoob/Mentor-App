import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorapp/AppScreens/constant.dart';

class MentorsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mentors',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('mentors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No mentors found'));
          }
          final mentors = snapshot.data!.docs;
          return ListView.builder(
            itemCount: mentors.length,
            itemBuilder: (context, index) {
              final mentorData = mentors[index].data() as Map<String, dynamic>;
              final mentorId = mentors[index].id; // Get the mentor ID

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('mentors')
                    .doc(mentorId)
                    .collection('enrollments')
                    .snapshots(),
                builder: (context, menteeSnapshot) {
                  if (menteeSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!menteeSnapshot.hasData ||
                      menteeSnapshot.data!.docs.isEmpty) {
                    return Card(
                      elevation: 4,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        title: Text(
                          mentorData['fullName'] ?? 'No Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mentorData['email'] ?? 'No Email',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No mentees enrolled',
                              style: TextStyle(
                                color: Colors.red[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  final mentees = menteeSnapshot.data!.docs;
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15),
                      title: Text(
                        mentorData['fullName'] ?? 'No Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mentorData['email'] ?? 'No Email',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          ...mentees.map((menteeDoc) {
                            final menteeData =
                                menteeDoc.data() as Map<String, dynamic>;
                            return ListTile(
                              leading: menteeData['imageUrl'] != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(menteeData['imageUrl']),
                                    )
                                  : CircleAvatar(child: Icon(Icons.person)),
                              title: Text(menteeData['userName'] ?? 'Unknown'),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
