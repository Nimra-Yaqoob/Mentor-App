import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorapp/AppScreens/Mentee/home/meprofile.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';

class BusnissMentorPage extends StatelessWidget {
  final String searchQuery;

  const BusnissMentorPage({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Business',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: SizedBox(
          height: 300,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream:
                FirebaseFirestore.instance.collection('mentors').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              // Filter mentors based on search query and category 'academia'
              final mentors = snapshot.data?.docs
                  .where((mentor) =>
                      mentor.data().containsKey('fullName') &&
                      mentor['fullName']
                          .toString()
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) &&
                      mentor.data()['category'] ==
                          'Business') // Filter by category 'academia'
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
                  return MentorsCard(
                    mentorId: mentors[index].id,
                    name: mentor['fullName'] ?? '',
                    specialty: mentor['category'] ?? '',
                    image: mentor['imageUrl'] ?? '',
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class MentorsCard extends StatefulWidget {
  final String mentorId;
  final String name;
  final String specialty;
  final String? image;

  const MentorsCard({
    Key? key,
    required this.mentorId,
    required this.name,
    required this.specialty,
    this.image,
  }) : super(key: key);

  @override
  _MentorsCardState createState() => _MentorsCardState();
}

class _MentorsCardState extends State<MentorsCard> {
  bool isEnrolled = false;

  @override
  void initState() {
    super.initState();
    _checkEnrollment();
  }

  Future<void> _checkEnrollment() async {
    String? userId = SessionManager.getUserId();
    if (userId == null) return;

    QuerySnapshot enrollmentsSnapshot = await FirebaseFirestore.instance
        .collection('mentors')
        .doc(widget.mentorId)
        .collection('enrollments')
        .where('userId', isEqualTo: userId)
        .get();

    setState(() {
      isEnrolled = enrollmentsSnapshot.docs.isNotEmpty;
    });
  }

  Future<void> _toggleEnrollment() async {
    String userId = SessionManager.getUserId();
    if (userId.isEmpty) return;

    DocumentSnapshot menteeSnapshot = await FirebaseFirestore.instance
        .collection('mentees')
        .doc(userId)
        .get();

    if (!menteeSnapshot.exists) return;

    String userImageUrl = menteeSnapshot['imageUrl'];

    if (isEnrolled) {
      // Unenroll logic
      QuerySnapshot enrollmentsSnapshot = await FirebaseFirestore.instance
          .collection('mentors')
          .doc(widget.mentorId)
          .collection('enrollments')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in enrollmentsSnapshot.docs) {
        await doc.reference.delete();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully unfollowed')),
      );
    } else {
      // Enroll logic
      await FirebaseFirestore.instance
          .collection('mentors')
          .doc(widget.mentorId)
          .collection('enrollments')
          .add({'userId': userId, 'imageUrl': userImageUrl});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mentee Successfully followed')),
      );
    }

    setState(() {
      isEnrolled = !isEnrolled;
    });
  }

  Future<void> _showEnrollmentCount() async {
    QuerySnapshot enrollmentsSnapshot = await FirebaseFirestore.instance
        .collection('mentors')
        .doc(widget.mentorId)
        .collection('enrollments')
        .get();

    int enrollmentCount = enrollmentsSnapshot.docs.length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Followers Count'),
          content: Text('This mentor has $enrollmentCount mentees Followed.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeProfile(mentorId: widget.mentorId),
                ),
              );
            },
            child: CircleAvatar(
              radius: 20.0,
              backgroundImage:
                  widget.image != null ? NetworkImage(widget.image!) : null,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name, // Swap name and specialty
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.specialty, // Swap specialty and name
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 3), // Adjust spacing as needed
          ElevatedButton(
            onPressed: isEnrolled ? null : _toggleEnrollment,
            child: Text(isEnrolled ? 'Unfollow' : 'Follow'),
          ),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'followers',
                child: Text('Followers'),
              ),
              const PopupMenuItem<String>(
                value: 'hide',
                child: Text('Unfollow'),
              ),
            ],
            onSelected: (String value) {
              if (value == 'followers') {
                _showEnrollmentCount();
              } else if (value == 'hide') {
                if (isEnrolled) {
                  _toggleEnrollment(); // Trigger unenroll when 'hide' is selected
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
