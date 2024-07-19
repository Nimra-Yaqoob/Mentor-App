import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Mentee extends StatelessWidget {
  const Mentee({Key? key}) : super(key: key);

  static const String id = "Mentee";

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
                'List of Mentees',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: MenteeList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenteeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('mentees').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final mentees = snapshot.data!.docs;

        return ListView.builder(
          itemCount: mentees.length,
          itemBuilder: (context, index) {
            final mentee = mentees[index];
            return MenteeCard(mentee: mentee);
          },
        );
      },
    );
  }
}

class MenteeCard extends StatelessWidget {
  final QueryDocumentSnapshot mentee;

  const MenteeCard({Key? key, required this.mentee}) : super(key: key);

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
              radius: 30.0,
              backgroundImage: NetworkImage(
                  mentee['imageUrl'] ?? 'https://via.placeholder.com/150'),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mentee['username'] ?? 'Name not available',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    mentee['email'] ?? 'Email not available',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteMentee(context, mentee.id),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMentee(BuildContext context, String id) {
    FirebaseFirestore.instance.collection('mentees').doc(id).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mentee deleted')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete mentee: $error')),
      );
    });
  }
}
