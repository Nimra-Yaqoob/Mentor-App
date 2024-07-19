import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mentorapp/AppScreens/Mentee/home/Widgets/roundbutton.dart';
import 'package:mentorapp/AppScreens/Mentee/menteelogin.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Email'),
              validator: (value) {},
            ),
            SizedBox(height: 20),
            RoundButton(
              title: 'Forgot',
              onTap: () async {
                var forgetemail = emailController.text.trim();

                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: forgetemail);
                  print("Password reset email sent!");

                  // Navigate to MenteeLoginScreen after successful email sending
                  Get.off(() => MenteeLoginScreen()); //correction
                } on FirebaseAuthException catch (e) {
                  print("Error $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
