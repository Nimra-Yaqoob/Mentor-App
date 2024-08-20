////////same organization
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';
import 'package:mentorapp/AppScreens/Mentee/home/meprofile.dart'; // Import the file where MeProfile class is defined

class OrganizationMentors extends StatefulWidget {
  const OrganizationMentors({Key? key}) : super(key: key);

  @override
  State<OrganizationMentors> createState() => _OrganizationMentorsState();
}

class _OrganizationMentorsState extends State<OrganizationMentors> {
  late Future<List<Map<String, dynamic>>> mentorsData;

  @override
  void initState() {
    super.initState();
    mentorsData = fetchMentorsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: mentorsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final mentorData = snapshot.data![index];
                  return MentorCard(
                    fullName: mentorData['fullName'],
                    organization: mentorData['inviteCode'],
                    mentorId: mentorData['mentorId'], // Pass mentorId
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text('No data found.');
            }
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchMentorsData() async {
    try {
      String username = await getOrganizationName();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('mentors')
          .where('inviteCode', isEqualTo: username)
          .get();

      List<Map<String, dynamic>> mentorsData = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        if (doc.exists) {
          Map<String, dynamic> mentorData = {
            'mentorId': doc.id, // Use document ID as mentor ID
            'fullName': doc['fullName'],
            'inviteCode': doc['inviteCode'],
          };
          mentorsData.add(mentorData);
        }
      }
      return mentorsData;
    } catch (e) {
      print('Error fetching invite code: $e');
      return [];
    }
  }

  Future<String> getOrganizationName() async {
    try {
      String currentUserId = SessionManager.getUserId();
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('organizations')
          .doc(currentUserId)
          .get();

      if (snapshot.exists) {
        return snapshot['uniqueCode'];
      } else {
        return 'uniqueCode not found';
      }
    } catch (e) {
      print('Error fetching uniqueCode : $e');
      return 'Error';
    }
  }
}

class MentorCard extends StatelessWidget {
  final String fullName;
  final String organization;
  final String mentorId; // Add mentorId parameter

  const MentorCard({
    required this.fullName,
    required this.organization,
    required this.mentorId, // Receive mentorId here
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(fullName),
        subtitle: Text(organization),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MeProfile(
                  mentorId: mentorId, // Pass mentorId to MeProfile
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: secondaryColor, // Set background color to blue
            onPrimary: Colors.white, // Set text color to white
          ),
          child: Text('Track'),
        ),
      ),
    );
  }
}
