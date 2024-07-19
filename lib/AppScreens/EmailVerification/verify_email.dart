import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentorapp/AppScreens/EmailVerification/sucessscreen.dart';
import 'package:mentorapp/AppScreens/Mentor/mentorlogin.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.offAll(
              () => MentorLoginScreen(),
            ),
            icon: Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset(
                "image/verify_process.gif",
                width: 300,
              ),
              // SizedBox(
              //   height: 22,
              // ),

              // Title and Subtitle
              Text(
                "Verify Your Email",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "henery@gmail.com",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Congratulations! Your Accout Awaits: Verify Your Email to Start Exploring and Furnish Your Skills with the Mentor Help.",
                textAlign: TextAlign.center,
              ),

              //  Buttons

              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Get.to(
                          () => SuccessScreen(
                              subtitle:
                                  "Congratulations! Your Accout Awaits: Verify Your Email to Start Exploring and Furnish Your Skills with the Mentor Help.",
                              image: 'image/Verification.gif',
                              title: 'Your Account Successfully Created!',
                              onPressed: () =>
                                  Get.to(() => const MentorLoginScreen())),
                        ),
                    child: const Text("Continue")),
              ),

              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Resend Email"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
