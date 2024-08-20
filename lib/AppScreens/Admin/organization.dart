import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Organization extends StatelessWidget {
  const Organization({super.key});
  static const String id = "Organization";

  Stream<QuerySnapshot> _fetchOrganizationsStream() {
    return FirebaseFirestore.instance.collection('organizations').snapshots();
  }

  void _deleteDocument(String docId) async {
    await FirebaseFirestore.instance
        .collection('organizations')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Organizations"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchOrganizationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No data found"));
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String docId = document.id;
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Organization Name: ${data['username']}"),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteDocument(docId);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("Email: ${data['email']}"),
                        SizedBox(height: 8),
                        Text("Domain Link: ${data['domainLink']}"),
                        SizedBox(height: 8),
                        Text(
                            "Registration Number: ${data['registrationNumber']}"),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
