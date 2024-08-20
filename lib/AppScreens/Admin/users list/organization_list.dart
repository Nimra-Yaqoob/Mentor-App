import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorapp/AppScreens/constant.dart';

class OrganizationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Organizations',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('organizations').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No organizations found'));
          }
          final organizations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: organizations.length,
            itemBuilder: (context, index) {
              final orgData =
                  organizations[index].data() as Map<String, dynamic>;
              final orgUniqueCode = orgData['uniqueCode'];
              final orgId = organizations[index].id;

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('mentors')
                    .where('inviteCode', isEqualTo: orgUniqueCode)
                    .snapshots(),
                builder: (context, mentorSnapshot) {
                  if (mentorSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!mentorSnapshot.hasData ||
                      mentorSnapshot.data!.docs.isEmpty) {
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
                          orgData['username'] ?? 'No Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orgData['email'] ?? 'No email',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No mentors available',
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
                  final mentors = mentorSnapshot.data!.docs;
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15),
                      title: Text(
                        orgData['username'] ?? 'No Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orgData['email'] ?? 'No email',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          ...mentors.map((mentorDoc) {
                            final mentorData =
                                mentorDoc.data() as Map<String, dynamic>;
                            return ListTile(
                              leading: mentorData['profileImage'] != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          mentorData['profileImage']),
                                    )
                                  : CircleAvatar(child: Icon(Icons.person)),
                              title: Text(mentorData['fullName'] ?? 'Unknown'),
                              subtitle: Text(
                                mentorData['email'] ?? 'No Email',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                _showMentorDetailsDialog(context, mentorData);
                              },
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

  void _showMentorDetailsDialog(
      BuildContext context, Map<String, dynamic> mentorData) {
    FirebaseFirestore.instance
        .collection('mentors')
        .doc(mentorData['id']) // Ensure you have the mentor ID here
        .collection('meetings')
        .get()
        .then((meetingSnapshot) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Mentor Details'),
            content: meetingSnapshot.docs.isEmpty
                ? _noMeetingsContent()
                : _meetingDetailsContent(meetingSnapshot),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    });
  }

  Widget _noMeetingsContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('No meetings created by this mentor.'),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _meetingDetailsContent(QuerySnapshot meetingSnapshot) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: meetingSnapshot.docs.map((doc) {
        final meetingData = doc.data() as Map<String, dynamic>;
        final createdAt = (meetingData['createdAt'] as Timestamp).toDate();
        final participants = (meetingData['participants'] as List)
            .map((p) => p['userName'])
            .toList();
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Meeting ID: ${meetingData['meetingID'] ?? 'No Meeting ID'}'),
              SizedBox(height: 5),
              Text('Created By: ${meetingData['createdByName'] ?? 'Unknown'}'),
              SizedBox(height: 5),
              Text('Created At: ${createdAt.toLocal()}'),
              SizedBox(height: 5),
              Text('Participants: ${participants.join(', ')}'),
              SizedBox(height: 5),
              Text(
                  'Session History: ${meetingData['sessionHistory'].isEmpty ? 'No Sessions' : meetingData['sessionHistory'].map((s) => s['title']).join(', ')}'),
            ],
          ),
        );
      }).toList(),
    );
  }
}
