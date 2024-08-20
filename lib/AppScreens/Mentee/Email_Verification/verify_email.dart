import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorapp/AppScreens/Mentee/Email_Verification/sucess_Screen.dart';
import 'package:mentorapp/AppScreens/Mentee/menteelogin.dart';
import 'package:mentorapp/AppScreens/constant.dart';

class VerifyEmailScreen extends StatelessWidget {
  final String userId;

  const VerifyEmailScreen({super.key, required this.userId});

  Future<String> _fetchEmail() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('mentees')
          .doc(userId)
          .get();
      return userDoc['email'] ?? 'No email found';
    } catch (e) {
      print('Error fetching email: $e');
      return 'Error fetching email';
    }
  }

  Future<void> _checkEmailVerified(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    await user?.reload();
    if (user != null && user.emailVerified) {
      // Navigate to success screen if email is verified
      Get.to(() => SuccessScreen(
            subtitle:
                "Congratulations! Your Account Awaits: Verify Your Email to Start Exploring and Furnish Your Skills with the Mentor Help.",
            image: 'image/Verification.gif',
            title: 'Your Account Successfully Created!',
            onPressed: () => Get.to(() => const MenteeLoginScreen()),
          ));
    } else {
      // Show error message if email is not verified
      _showErrorSnackBar(
          context, "Email not verified. Please check your inbox.");
    }
  }

  Future<void> _deleteUserFromFirestore(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('mentees')
          .doc(userId)
          .delete();
      Get.offAll(() => MenteeLoginScreen());
    } catch (e) {
      _showErrorSnackBar(context, "Failed to delete user. Please try again.");
    }
  }

  void _showErrorSnackBar(BuildContext context, String errorMessage) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => _deleteUserFromFirestore(context),
            icon: Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: FutureBuilder<String>(
            future: _fetchEmail(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No email found'));
              }

              String email = snapshot.data!;

              return Column(
                children: [
                  Image.asset(
                    "image/verify_process.gif",
                    width: 300,
                  ),
                  Text(
                    "Verify Your Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    email,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Congratulations! Your Account Awaits: Verify Your Email to Start Exploring and Furnish Your Skills with the Mentor Help.",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _checkEmailVerified(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 10, // Add elevation for 3D effect
                        primary: primaryColor, // Button background color
                        onPrimary: Colors.white, // Button text color
                        shadowColor: secondaryColor, // Shadow color
                      ),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
