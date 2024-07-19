import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';

class MeProfile extends StatefulWidget {
  final String mentorId;

  const MeProfile({Key? key, required this.mentorId}) : super(key: key);

  @override
  _MeProfileState createState() => _MeProfileState();
}

class _MeProfileState extends State<MeProfile> {
  Future<int> _getMenteeCount() async {
    QuerySnapshot menteesSnapshot = await FirebaseFirestore.instance
        .collection('mentors')
        .doc(widget.mentorId)
        .collection('enrollments')
        .get();
    return menteesSnapshot.docs.length;
  }

  Future<void> _showMenteeCountDialog(BuildContext context) async {
    int menteeCount = await _getMenteeCount();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mentee Count'),
          content: Text('This mentor has $menteeCount mentees enrolled.'),
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

  void _saveReview(String mentorId, String comment) async {
    String userId = SessionManager.getUserId();

    // Fetch enrolled mentees IDs
    QuerySnapshot mentorEnrollmentsSnapshot = await FirebaseFirestore.instance
        .collection('mentors')
        .doc(mentorId)
        .collection('enrollments')
        .get();

    List<String> enrolledMenteeIds = mentorEnrollmentsSnapshot.docs
        .map((doc) => doc['userId'] as String)
        .toList();

    // Check if the user is an enrolled mentee
    if (userId.isNotEmpty && enrolledMenteeIds.contains(userId)) {
      // Save review in Firestore and increment review count
      WriteBatch batch = FirebaseFirestore.instance.batch();

      DocumentReference reviewRef = FirebaseFirestore.instance
          .collection('mentors')
          .doc(mentorId)
          .collection('reviews')
          .doc(userId);

      DocumentReference mentorRef =
          FirebaseFirestore.instance.collection('mentors').doc(mentorId);

      batch.set(reviewRef, {
        'comment': comment,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      batch.update(mentorRef, {
        'reviewCount': FieldValue.increment(1),
      });

      await batch.commit();
    }
  }

  Future<Map<String, dynamic>> _getUserData(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('mentees')
        .doc(userId)
        .get();
    return userDoc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentor'),
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('mentors')
            .doc(widget.mentorId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No mentor found'));
          }

          var mentorData = snapshot.data!.data() as Map<String, dynamic>;
          String imageUrl = mentorData['imageUrl'] ?? '';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(mentorData, imageUrl),
                _buildFollowerButton(context),
                _buildMentorDetails(mentorData),
                _buildReviewsSection(),
                _buildEnrolledMenteesSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> mentorData, String imageUrl) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mentorData['fullName'],
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                mentorData['email'],
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFollowerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () => _showMenteeCountDialog(context),
            icon: Icon(Icons.people, color: Colors.white),
            label: Text(
              'Followers',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
          ),
          SizedBox(width: 8.0),
        ],
      ),
    );
  }

  Widget _buildMentorDetails(Map<String, dynamic> mentorData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bio',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            mentorData['experience']?['description'] ?? 'No bio available',
          ),
          SizedBox(height: 16.0),
          Text(
            'Skills',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: mentorData['passions']?.length ?? 0,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: primaryColor),
                    SizedBox(width: 8.0),
                    Text(mentorData['passions'][index]),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    TextEditingController reviewController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: reviewController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Write your review',
              contentPadding: EdgeInsets.all(10.0),
            ),
            maxLines: 2,
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              _saveReview(widget.mentorId, reviewController.text);
            },
            child: Text('Submit Review'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              minimumSize: Size(double.infinity, 36),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('mentors')
                .doc(widget.mentorId)
                .collection('reviews')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No reviews yet'));
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var reviewData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return FutureBuilder<Map<String, dynamic>>(
                    future: _getUserData(reviewData['userId']),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (userSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${userSnapshot.error}'));
                      }
                      if (!userSnapshot.hasData) {
                        return Center(child: Text('User not found'));
                      }

                      var userData = userSnapshot.data!;
                      return ListTile(
                        title: Text(userData['username'] ?? ''),
                        subtitle: Text(reviewData['comment'] ?? ''),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEnrolledMenteesSection() {
    return Column(
      children: [
        SizedBox(height: 20),
        SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('mentors')
              .doc(widget.mentorId)
              .collection('enrollments')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No mentees enrolled'));
            }

            return Column(
              children: snapshot.data!.docs.map<Widget>((document) {
                var menteeData = document.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(menteeData['fullName'] ?? ''),
                  subtitle: Text(menteeData['email'] ?? ''),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
