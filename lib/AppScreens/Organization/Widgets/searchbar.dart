import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/Organization/Widgets/mentorprofile.dart';

class MentorSearchBar extends StatefulWidget {
  @override
  _MentorSearchBarState createState() => _MentorSearchBarState();
}

class _MentorSearchBarState extends State<MentorSearchBar> {
  TextEditingController _searchController = TextEditingController();
  String searchResult = '';
  List<Map<String, dynamic>> mentorList = [];

  void searchMentor(String query) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('mentors')
          .where('fullName', isEqualTo: query)
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          searchResult = 'No mentor found';
          mentorList.clear();
        });
      } else {
        setState(() {
          mentorList =
              snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
          searchResult = ''; // Clear any previous error message
        });
      }
    } catch (error) {
      print('Error searching mentor: $error');
      setState(() {
        searchResult = 'An error occurred. Please try again.';
        mentorList.clear();
      });
    }
  }

  void navigateToProfile(String mentorId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeProfile(mentorId: mentorId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search mentors',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                searchMentor(value);
              } else {
                setState(() {
                  searchResult = '';
                  mentorList.clear();
                });
              }
            },
          ),
        ),
        SizedBox(height: 10),
        if (searchResult.isNotEmpty)
          Text(
            searchResult,
            style: TextStyle(
              color: searchResult == 'No mentor found' ||
                      searchResult.contains('error')
                  ? Colors.red
                  : Colors.black,
              fontSize: 16,
            ),
          ),
        if (mentorList.isNotEmpty)
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: mentorList.length,
              itemBuilder: (context, index) {
                final mentor = mentorList[index];
                return GestureDetector(
                  onTap: () =>
                      navigateToProfile(mentor['id']), // Use 'id' for mentor ID
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(mentor['imageUrl'] ??
                              ''), // Handle cases where 'imageUrl' might be null
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mentor['fullName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                mentor['email'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
