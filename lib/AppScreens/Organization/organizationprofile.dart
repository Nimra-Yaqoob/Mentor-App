import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:mentorapp/AppScreens/Organization/organizationhome.dart';
import 'package:mentorapp/AppScreens/constant.dart';

class OrganizationProfile extends StatefulWidget {
  final String userId;

  const OrganizationProfile({Key? key, required this.userId}) : super(key: key);

  @override
  _OrganizationProfileState createState() => _OrganizationProfileState();
}

class _OrganizationProfileState extends State<OrganizationProfile> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> organizationData;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchOrganizationData();
  }

  void fetchOrganizationData() {
    organizationData = FirebaseFirestore.instance
        .collection('organizations')
        .doc(widget.userId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        return snapshot;
      } else {
        throw Exception('Organization not found.');
      }
    });
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
                  builder: (context) => OrganizationHome(),
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
        future: organizationData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Organization not found.'));
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
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
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 24,
                            color: secondaryColor,
                          ),
                          SizedBox(width: 7),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Name : ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data['username'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 300,
                        child: Divider(
                          color: Colors.grey.withOpacity(0.5),
                          height: 10,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.email_rounded,
                            size: 24,
                            color: secondaryColor,
                          ),
                          SizedBox(width: 7),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Email : ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  data['email'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 300,
                        child: Divider(
                          color: Colors.grey.withOpacity(0.5),
                          height: 10,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Make the domain link row scrollable
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Icon(
                              Icons.link_rounded,
                              size: 24,
                              color: secondaryColor,
                            ),
                            SizedBox(width: 7),
                            Text(
                              'Domain Link : ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              data['domainLink'],
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 300,
                        child: Divider(
                          color: Colors.grey.withOpacity(0.5),
                          height: 10,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.numbers_rounded,
                            size: 24,
                            color: secondaryColor,
                          ),
                          SizedBox(width: 7),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Registration Number : ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data['registrationNumber'].toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
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
        String fileName = 'organization_$userId.jpg';

        // Upload the image to Firebase Storage
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(_image!);

        // Get the download URL after the image is uploaded
        String imageUrl = await ref.getDownloadURL();

        // Get the current organization data
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('organizations')
                .doc(userId)
                .get();
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // If there was a previous image, delete it from Firebase Storage
        if (data.containsKey('imageUrl') && data['imageUrl'] != null) {
          String previousImageUrl = data['imageUrl'];
          await firebase_storage.FirebaseStorage.instance
              .refFromURL(previousImageUrl)
              .delete();
        }

        // Update the organization data in Firestore with the new image URL
        await FirebaseFirestore.instance
            .collection('organizations')
            .doc(userId)
            .update({'imageUrl': imageUrl});

        // Notify the user about the successful image upload
        Fluttertoast.showToast(
          msg: 'Image uploaded successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Fetch the updated organization data and update the local variable
        snapshot = await FirebaseFirestore.instance
            .collection('organizations')
            .doc(userId)
            .get();

        // Update the local organizationData variable
        setState(() {
          organizationData = Future.value(snapshot);
        });
      } catch (error) {
        // Notify the user about the error during image upload
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
}
