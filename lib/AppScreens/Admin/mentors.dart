import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Mentor extends StatelessWidget {
  const Mentor({Key? key}) : super(key: key);

  static const String id = "Mentor";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'List of Mentors',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: MentorList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MentorList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('mentors').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final mentors = snapshot.data!.docs;

        return ListView.builder(
          itemCount: mentors.length,
          itemBuilder: (context, index) {
            final mentor = mentors[index];
            return MentorCard(mentor: mentor);
          },
        );
      },
    );
  }
}

class MentorCard extends StatelessWidget {
  final QueryDocumentSnapshot mentor;

  const MentorCard({Key? key, required this.mentor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey, // Gray color for the placeholder
              backgroundImage: mentor['imageUrl'] != null &&
                      mentor['imageUrl'].isNotEmpty
                  ? NetworkImage(mentor['imageUrl'])
                  : null, // Set to null if imageUrl is not available or empty
              radius: 40.0,
              child: mentor['imageUrl'] == null || mentor['imageUrl'].isEmpty
                  ? Icon(Icons.person,
                      size: 40.0) // Show person icon if no image
                  : null,
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mentor['fullName'] ?? 'Name not available',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Email: ${mentor['email'] ?? 'Email not available'}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Date of Birth: ${mentor['dateOfBirth'] ?? 'Date not available'}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Gender: ${mentor['gender'] ?? 'Gender not available'}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Category: ${mentor['category'] ?? 'Category not available'}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Organization: ${mentor['organization'] ?? 'Organization not available'}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Passions: ${mentor['passions']?.join(', ') ?? 'Passions not available'}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 5.0),
                  mentor['experience'] != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Experience:',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            ...mentor['experience']
                                .entries
                                .map<Widget>((entry) {
                              return Text(
                                '${entry.key}: ${entry.value}',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey[700]),
                              );
                            }).toList(),
                          ],
                        )
                      : Text(
                          'Experience: Not available',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[700]),
                        ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('mentors')
                    .doc(mentor.id)
                    .delete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
