import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentorapp/AppScreens/Mentor/home%20page/allmentees.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'mentorhomepage.dart';

class MentorProfile extends StatefulWidget {
  final String userId;

  const MentorProfile({Key? key, required this.userId}) : super(key: key);

  @override
  _MentorProfileState createState() => _MentorProfileState();
}

class _MentorProfileState extends State<MentorProfile> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> mentorData;
  TextEditingController _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    mentorData = FirebaseFirestore.instance
        .collection('mentors')
        .doc(widget.userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        return doc;
      } else {
        throw Exception('Mentor not found.');
      }
    });
  }

  Future<void> _showEnrollmentCount() async {
    QuerySnapshot enrollmentsSnapshot = await FirebaseFirestore.instance
        .collection('mentors')
        .doc(widget.userId)
        .collection('enrollments')
        .get();

    int enrollmentCount = enrollmentsSnapshot.docs.length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enrollment Count'),
          content:
              Text('You have currently $enrollmentCount mentees enrolled.'),
          actions: [
            TextButton(
              child: Text('Show Mentees'), // Add new button text
              onPressed: () {
                Navigator.of(context).pop(); // Close the current dialog
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      EnrolledMentees(), // Navigate to new page
                ));
              },
            ),
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

  Future<void> updateMentorBio(
      String newBio, DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    try {
      await FirebaseFirestore.instance
          .collection('mentors')
          .doc(snapshot.id)
          .update({
        'experience': {
          'description': newBio,
        },
      });
    } catch (e) {
      print('Error updating bio: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      try {
        String userId = widget.userId;
        String fileName = 'mentor_$userId.jpg';

        await FirebaseFirestore.instance
            .collection('mentors')
            .doc(userId)
            .update({
          'imageUrl': fileName,
        });

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(_image!);

        String imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('mentors')
            .doc(userId)
            .update({
          'imageUrl': imageUrl,
        });

        Fluttertoast.showToast(
          msg: 'Image uploaded successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('mentors')
                .doc(userId)
                .get();

        setState(() {
          mentorData = Future.value(snapshot);
        });
      } catch (error) {
        Fluttertoast.showToast(
          msg: 'Error uploading image: $error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MentorHomePage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: mentorData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Mentor not found.'));
          } else {
            Map<String, dynamic>? data = snapshot.data!.data();

            if (data == null) {
              return Center(child: Text('Mentor data is null.'));
            }

            String bioDescription = data['experience']?['description'] ?? '';
            num reviewCount =
                data['reviewCount'] ?? 0; // Handle both int and double

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 110,
                              height: 110,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: _image != null
                                    ? Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                      )
                                    : (data['imageUrl'] != null &&
                                            data['imageUrl']!.isNotEmpty
                                        ? Image.network(
                                            data['imageUrl']!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(Icons.account_circle,
                                                  size: 110,
                                                  color: Colors.grey);
                                            },
                                          )
                                        : Icon(Icons.account_circle,
                                            size: 110, color: Colors.grey)),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: primaryColor,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt_rounded,
                                    size: 18.0,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _pickImage();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 25,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '${reviewCount.toInt()}', // Display the review count as int
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 20),
                                InkWell(
                                  onTap: _showEnrollmentCount,
                                  child: Row(
                                    children: [
                                      Icon(Icons.group),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(data['fullName'], // Replace with the actual field
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      data['email'],
                      style: TextStyle(
                          fontSize: 16,
                          color: secondaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      data['category'], // Replace with the actual field
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bio',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: secondaryColor,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Edit Your Bio'),
                                      content: Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          controller: _bioController,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            hintText: 'Enter new bio',
                                          ),
                                          validator: (value) {
                                            // Add your validation logic if needed
                                            return null;
                                          },
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              String newBio =
                                                  _bioController.text;
                                              if (newBio.isNotEmpty) {
                                                await updateMentorBio(
                                                    newBio, snapshot.data!);
                                                Navigator.pop(context);
                                                setState(() {
                                                  // Update the local state if needed
                                                });
                                              }
                                            }
                                          },
                                          child: Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      bioDescription,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 16),
                    Text('Skills',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        )),
                    SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: data['passions'] != null
                          ? data['passions'].length
                          : 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline,
                                  color: primaryColor), // or any other icon
                              SizedBox(width: 8.0),
                              Text(data['passions'][index]),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
