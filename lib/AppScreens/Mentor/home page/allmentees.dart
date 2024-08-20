import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';

class EnrolledMentees extends StatefulWidget {
  const EnrolledMentees({super.key});

  @override
  State<EnrolledMentees> createState() => _EnrolledMenteesState();
}

class _EnrolledMenteesState extends State<EnrolledMentees> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Retrieve the mentor ID from SessionManager
    final mentorId = SessionManager.getUserId();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mentees'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: mentorId == null
            ? Center(child: Text('Mentor ID not available.'))
            : StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('mentors')
                    .doc(mentorId)
                    .collection('enrollments')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No mentees found.'));
                  }
                  final mentees = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: mentees.length,
                    itemBuilder: (context, index) {
                      final mentee =
                          mentees[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        elevation: 4,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(mentee['imageUrl'] ??
                                'https://via.placeholder.com/150'),
                          ),
                          title: Text(mentee['userName'] ?? 'No Name'),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
