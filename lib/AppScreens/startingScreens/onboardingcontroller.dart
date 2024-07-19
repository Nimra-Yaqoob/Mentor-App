import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentorapp/AppScreens/startingScreens/roleselection.dart';

// class OnBoardinController extends GetxController {
//   static OnBoardinController get instance => Get.find();

//   // Variables
//   final pageController = PageController();
//   // final PageController pageController = PageController();
//   // change state of process without satefull widget
//   Rx<int> currentPageIndex = 0.obs;

//   // Update Current index when page scroll
//   void updatePageIndicator(index) => currentPageIndex.value = index;

//   // Jump specific dot selected page
//   void dotNavigationClick(index) {
//     currentPageIndex.value = index;
//     pageController.jumpTo(index);
//   }

//   // Update Current index & jump to next Page
//   void nextPage() {
//     if (currentPageIndex.value == 2) {
//       Get.to(RoleSelection());
//     } else {
//       int page = currentPageIndex.value + 1;
//       pageController.jumpToPage(page);
//     }
//   }

//   // Update Current index & jump to last Page
//   void skipPage() {
//     currentPageIndex.value = 2;
//     pageController.jumpTo(2);
//   }
// }

class OnBoardinController extends GetxController {
  static OnBoardinController get instance => Get.find();

  final PageController pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index.toDouble());
  }

  void nextPage(BuildContext context) {
    if (currentPageIndex.value == 2) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const RoleSelection(),
      ));
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpTo(2.toDouble());
  }
}
