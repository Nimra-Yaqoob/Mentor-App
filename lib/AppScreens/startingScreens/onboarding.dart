import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:mentorapp/AppScreens/startingScreens/onboardingcontroller.dart';
import 'package:mentorapp/AppScreens/startingScreens/roleselection.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.put(OnBoardinController());
    final dotcontroller = OnBoardinController.instance;

    return Scaffold(
      body: Stack(
        children: [
          //  Horizontal scrollable Page
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                screenWidth: screenWidth,
                image: 'image/Choose_mentor.gif',
                title: "Choose Your Mentor",
                subTitle:
                    " Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...",
              ),
              OnBoardingPage(
                screenWidth: screenWidth,
                image: 'image/online_session.gif',
                title: "Join Online Sessions",
                subTitle:
                    " Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...",
              ),
              OnBoardingPage(
                screenWidth: screenWidth,
                image: 'image/video-conference.gif',
                title: "Chat with Your Mentor",
                subTitle:
                    " Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...",
              ),
            ],
          ),

          //  Skip Button

          Positioned(
            top: 15,
            right: 24.0,
            child: TextButton(
              // onPressed: () => OnBoardinController.instance.skipPage(),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const RoleSelection()));
              },
              child: Text(
                'Skip',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ),

          //  Dot Navigation Smooth Page Indicator

          Positioned(
            bottom: 36,
            left: 24.0,
            child: SmoothPageIndicator(
              count: 3,
              controller: dotcontroller.pageController,
              onDotClicked: dotcontroller.dotNavigationClick,
              effect: ExpandingDotsEffect(
                  activeDotColor: Colors.black, dotHeight: 6),
            ),
          ),

          //  Circular Button

          Positioned(
            right: 24.0,
            bottom: 36,
            child: ElevatedButton(
              onPressed: () => OnBoardinController.instance.nextPage(context),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: primaryColor,
                padding: EdgeInsets.all(20),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.screenWidth,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final double screenWidth;

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Image.asset(
            image,
            width: screenWidth * 0.8,
            height: screenWidth * 0.9,
          ),
          // Image.network(image),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
