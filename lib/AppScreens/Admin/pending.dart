import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PendingOrganizationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('pending').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No organizations found'));
        }
        final organizations = snapshot.data!.docs;
        return ListView.builder(
          itemCount: organizations.length,
          itemBuilder: (context, index) {
            final org = organizations[index].data() as Map<String, dynamic>;
            final docId = organizations[index].id;
            return OrganizationCard(
              documentId: docId, // Pass document ID
              username: org['username'],
              email: org['email'],
              domainLink: org['domainLink'],
              registrationNumber: org['registrationNumber'],
              documentUrl: org['documentUrl'],
              status: org['status'], // Pass status field
              userId: org['userId'], // Pass userId field
              password: org['password'], // Pass password field
            );
          },
        );
      },
    );
  }
}

// ignore: must_be_immutable
class OrganizationCard extends StatefulWidget {
  final String documentId; // Add document ID field
  final String username;
  final String email;
  final String domainLink;
  final int registrationNumber;
  final String documentUrl;
  String status; // Update status field
  String userId; // Add userId field
  String password; // Add password field

  OrganizationCard({
    required this.documentId, // Initialize document ID field
    required this.username,
    required this.email,
    required this.domainLink,
    required this.registrationNumber,
    required this.documentUrl,
    required this.status, // Initialize status field
    required this.userId, // Initialize userId field
    required this.password, // Initialize password field
  });

  @override
  _OrganizationCardState createState() => _OrganizationCardState();
}

class _OrganizationCardState extends State<OrganizationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.username),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${widget.email}'),
            Text('Domain: ${widget.domainLink}'),
            Text('Registration Number: ${widget.registrationNumber}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Read User Document'),
                      content: Text(
                          'Please read the user document from your Firestore.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (widget.status == 'pending') {
                  // Store organization data in 'organizations' collection
                  await FirebaseFirestore.instance
                      .collection('organizations')
                      .doc(widget.username)
                      .set({
                    'username': widget.username,
                    'email': widget.email,
                    'domainLink': widget.domainLink,
                    'registrationNumber': widget.registrationNumber,
                    'documentUrl': widget.documentUrl,
                    'status': 'approved',
                    'userId': widget.userId, // Store userId
                    'password': widget.password, // Store password
                  });

                  // Delete organization data from 'pending' collection
                  await FirebaseFirestore.instance
                      .collection('pending')
                      .doc(widget.documentId) // Use documentId for deletion
                      .delete();

                  // Update UI
                  setState(() {
                    widget.status = 'approved';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: widget.status == 'pending'
                    ? Theme.of(context).secondaryHeaderColor
                    : Colors.grey, // Change button color based on status
                onPrimary: Colors.black, // Change text color to black
              ),
              child: Text(widget.status == 'pending'
                  ? 'Pending'
                  : 'Verified'), // Display status
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                // Delete organization data from 'pending' collection
                await FirebaseFirestore.instance
                    .collection('pending')
                    .doc(widget.documentId) // Use documentId for deletion
                    .delete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
