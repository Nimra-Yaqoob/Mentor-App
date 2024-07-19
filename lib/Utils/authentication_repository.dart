// import 'dart:js';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:mentorapp/AppScreens/Mentor/mentorlogin.dart';

// class Authentication extends GetxController {
//   static Authentication get instance => Get.find();

// //   // late final Rx<User?> _firebaseUser;
// //   // final _auth = FirebaseAuth.instance;

// //   Future<UserCredential> signInWithGoogle() async {

// //     try{

// //     } on FirebaseAuthException catch(e){
// //       // final ex
// //     }
// //     // Trigger the authentication flow
// //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

// //     // Obtain the auth details from the request
// //     final GoogleSignInAuthentication? googleAuth =
// //         await googleUser?.authentication;

// //     // Create a new credential
// //     final credential = GoogleAuthProvider.credential(
// //       accessToken: googleAuth?.accessToken,
// //       idToken: googleAuth?.idToken,
// //     );

// //     // Once signed in, return the UserCredential
// //     return await FirebaseAuth.instance.signInWithCredential(credential);
//   // }

//   // FirebaseAuth auth = FirebaseAuth.instance;
//   // auth.sig

//   Widget googleSignInButton(BuildContext context) {
//     return Column(
//       children: [
//         Text("or"),
//         MaterialButton(
//           onPressed: () async {
//             GoogleSignIn gSn = GoogleSignIn();
//             await gSn.signIn();
//             if (gSn.currentUser != null) {
//               print(gSn.currentUser!.displayName);
//               Navigator.pushNamedAndRemoveUntil(
//                   context, MenteeHomePage.id, (route) => false);
//             }
//           },
//         ),
//       ],
//     );
//   }

//   // googleSignInButton(context),

//   // main
//   // initialRoute: LoginScreen.id,
//   // home Page

// }

// class MenteeHomePage extends StatefulWidget {
//   const MenteeHomePage({super.key});

//   @override
//   State<MenteeHomePage> createState() => _MenteeHomePageState();
// }

// class _MenteeHomePageState extends State<MenteeHomePage> {
//   static final id = 'home';
//   GoogleSignIn gSn = GoogleSignIn();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Text("Home Page"),
//           Image.network(gSn.currentUser.photoUrl),
//           ElevatedButton(
//               onPressed: () async {
//                 FirebaseAuth auth = FirebaseAuth.instance;
//                 await auth.signOut();
//                 await gSn.signOut();
//                 Navigator.pushNamedAndRemoveUntil(
//                     context, LoginScreen.id, (route) => false);
//               },
//               child: Text('Log Out'))
//         ],
//       ),
//     );
//   }
// }
