import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'menteehomepage.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId, String? profileImageUrl})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> userData;
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    fetchUserData();
  }

  void fetchUserData() {
    userData = FirebaseFirestore.instance
        .collection('mentees')
        .doc(widget.userId)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot;
      } else {
        throw Exception('User not found.');
      }
    });
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
        String fileName = 'mentee_$userId.jpg';

        // Upload the image to Firebase Storage
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(_image!);

        // Get the download URL after the image is uploaded
        String imageUrl = await ref.getDownloadURL();

        // Update the data in Firestore with the correct image URL
        await FirebaseFirestore.instance
            .collection('mentees')
            .doc(userId)
            .update({
          'imageUrl': imageUrl,
        });

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

        // Fetch the updated data and update the local variable
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('mentees')
                .doc(userId)
                .get();

        // Update the local Data variable
        setState(() {
          userData = Future.value(snapshot);
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

  Future<void> _deleteImage() async {
    if (_image != null) {
      try {
        String userId = widget.userId;
        String fileName = 'mentee_$userId.jpg';

        // Delete the image from Firebase Storage
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(fileName);
        await ref.delete();

        // Update the data in Firestore to remove the image URL
        await FirebaseFirestore.instance
            .collection('mentees')
            .doc(userId)
            .update({
          'imageUrl': FieldValue.delete(),
        });

        // Notify the user about the successful image deletion
        Fluttertoast.showToast(
          msg: 'Image deleted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Update the local Data variable
        setState(() {
          _image = null; // Remove the image from the UI
        });
      } catch (error) {
        // Notify the user about the error during image deletion
        Fluttertoast.showToast(
          msg: 'Error deleting image: $error',
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
        title: Text('My Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MenteeHome(),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MenteeHome(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Save',
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
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User not found.'));
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            _userNameController.text = data['username'];
            _emailController.text = data['email'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
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
                                    ? Image.file(_image!)
                                    : (data['imageUrl'] != null
                                        ? Image.network(data['imageUrl'])
                                        : Image.asset(
                                            'assets/placeholder_image.png')),
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
                                  icon: _image != null
                                      ? Icon(
                                          Icons.delete,
                                          size: 18.0,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          Icons.camera_alt_rounded,
                                          size: 18.0,
                                          color: Colors.white,
                                        ),
                                  onPressed: () {
                                    if (_image != null) {
                                      _deleteImage(); // Call the delete image function
                                    } else {
                                      _pickImage(); // Call the image picker method if no image is selected
                                    }
                                  },
                                ),
                              ),
                            ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name : ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      data['username'],
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: secondaryColor,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Edit Your Name'),
                                              content: TextField(
                                                controller: _userNameController,
                                                decoration: InputDecoration(
                                                  hintText: 'Enter new name',
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
                                                    String newName =
                                                        _userNameController
                                                            .text;
                                                    if (newName.isNotEmpty) {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('mentees')
                                                          .doc(
                                                              snapshot.data!.id)
                                                          .update({
                                                        'username': newName,
                                                      });
                                                      Navigator.pop(context);
                                                      fetchUserData(); // Fetch updated data
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 270,
                        child: Divider(
                          color: Colors.grey.withOpacity(0.5),
                          height: 10,
                        ),
                      ),
                      SizedBox(height: 5),
                      Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Icon(
                              Icons.email_rounded,
                              size: 24,
                              color: secondaryColor,
                            ),
                            SizedBox(width: 7),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Email : ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        data['email'],
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: secondaryColor,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Edit Your Email'),
                                                content: TextFormField(
                                                  controller: _emailController,
                                                  decoration: InputDecoration(
                                                    hintText: 'Enter new email',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter a valid email';
                                                    }
                                                    if (!RegExp(
                                                            r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                                                        .hasMatch(value)) {
                                                      return 'Please enter a valid email';
                                                    }
                                                    return null;
                                                  },
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
                                                        String newEmail =
                                                            _emailController
                                                                .text;
                                                        if (newEmail
                                                            .isNotEmpty) {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'mentees')
                                                              .doc(snapshot
                                                                  .data!.id)
                                                              .update({
                                                            'email': newEmail,
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          fetchUserData(); // Fetch updated data
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 270,
                        child: Divider(
                          color: Colors.grey.withOpacity(0.5),
                          height: 10,
                        ),
                      ),
                      SizedBox(height: 16),
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
}
