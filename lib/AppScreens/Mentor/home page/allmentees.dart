import 'package:flutter/material.dart';

class EnrolledMentees extends StatefulWidget {
  const EnrolledMentees({super.key});

  @override
  State<EnrolledMentees> createState() => _EnrolledMenteesState();
}

class _EnrolledMenteesState extends State<EnrolledMentees> {
  final List<Map<String, String>> mentees = [
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'image':
          'https://via.placeholder.com/150', // Replace with actual image URL
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'image':
          'https://via.placeholder.com/150', // Replace with actual image URL
    },
    // Add more mentees here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentees'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: mentees.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(mentees[index]['image']!),
                ),
                title: Text(mentees[index]['name']!),
                subtitle: Text(mentees[index]['email']!),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    // Handle more button pressed
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
