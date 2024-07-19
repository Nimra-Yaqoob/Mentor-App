import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorapp/AppScreens/Mentee/home/mentorcard.dart';

class AllMentors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Mentors'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('mentors').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Combine top mentors and all mentors
          List<DocumentSnapshot<Map<String, dynamic>>> allMentors = [];
          allMentors.addAll(snapshot.data!.docs);

          // Display all mentors
          return ListView.builder(
            itemCount: allMentors.length,
            itemBuilder: (context, index) {
              final mentor = allMentors[index].data();
              return MentorsCard(
                mentorId: allMentors[index].id,
                name: mentor?['fullName'] ?? '',
                specialty: mentor?['category'] ?? '',
                image: mentor?['imageUrl'] ?? '',
              );
            },
          );
        },
      ),
    );
  }
}
