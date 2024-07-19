import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/Mentee/home/menteehomepage.dart';
import 'package:mentorapp/AppScreens/Mentee/home/mentorcard.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnrolledMentorsList extends StatelessWidget {
  final String searchQuery;

  const EnrolledMentorsList({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? currentUserId = SessionManager.getUserId(); // Fetch current user ID

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MenteeHome(),
            ),
          ),
        ),
        title: Text(
          'Following', // Yaha 'Following' ka text diya gaya hai
          style: TextStyle(
            color: Colors.black,
            fontSize: 18, // Font size ko apni pasand ke hisab se adjust karein
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        height: 300,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('mentors').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            // Filter mentors based on search query
            final mentors = snapshot.data?.docs
                .where((mentor) =>
                    mentor.data().containsKey('fullName') &&
                    mentor['fullName']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                .toList();

            // Check if mentor is found or not
            if (mentors == null || mentors.isEmpty) {
              return Center(
                child: Text('User not found.'),
              );
            }

            return ListView.builder(
              itemCount: mentors.length,
              itemBuilder: (context, index) {
                final mentor = mentors[index].data();
                return FutureBuilder<bool>(
                  future: _isEnrolled(currentUserId,
                      mentors[index].id), // Check if current user is enrolled
                  builder: (BuildContext context,
                      AsyncSnapshot<bool> enrollmentSnapshot) {
                    if (enrollmentSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator while checking enrollment
                    }
                    if (enrollmentSnapshot.hasError) {
                      return Text('Error: ${enrollmentSnapshot.error}');
                    }
                    final isEnrolled = enrollmentSnapshot.data ?? false;
                    if (isEnrolled) {
                      return MentorsCard(
                        mentorId: mentors[index].id,
                        name: mentor['fullName'] ?? '',
                        specialty: mentor['category'] ?? '',
                        image: mentor['imageUrl'] ?? '',
                      );
                    } else {
                      return SizedBox
                          .shrink(); // Return an empty widget if not enrolled
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<bool> _isEnrolled(String? userId, String mentorId) async {
    if (userId == null) return false;
    QuerySnapshot enrollmentsSnapshot = await FirebaseFirestore.instance
        .collection('mentors')
        .doc(mentorId)
        .collection('enrollments')
        .where('userId', isEqualTo: userId)
        .get();
    return enrollmentsSnapshot.docs.isNotEmpty;
  }
}
