// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mentorapp/AppScreens/Admin/adminhome.dart';
// import 'package:mentorapp/AppScreens/Mentee/home/Widgets/roundbutton.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sizer/sizer.dart';

// class AdminLogin extends StatefulWidget {
//   static const String id = "weblogin";
//   const AdminLogin({Key? key}) : super(key: key);

//   @override
//   _AdminLoginState createState() => _AdminLoginState();
// }

// class _AdminLoginState extends State<AdminLogin> {
//   bool showPassword = false;
//   bool loading = false;
//   final _formKey = GlobalKey<FormState>();
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   void dispose() {
//     super.dispose();
//     usernameController.dispose();
//     passwordController.dispose();
//   }

//   static Future<DocumentSnapshot> adminSignIn(id) async {
//     var result = FirebaseFirestore.instance.collection("admin").doc(id).get();
//     return result;
//   }

//   void login(BuildContext context) {
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() {
//         loading = true;
//       });
//       adminSignIn(usernameController.text).then((value) async {
//         if (value.exists) {
//           if (value['username'] == usernameController.text &&
//               value['password'] == passwordController.text) {
//             try {
//               UserCredential user =
//                   await FirebaseAuth.instance.signInAnonymously();
//               if (user != null) {
//                 Navigator.pushReplacementNamed(context, AdminPanel.id);
//               }
//             } catch (e) {
//               setState(() {
//                 loading = false;
//               });
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(e.toString())),
//               );
//             }
//           } else {
//             setState(() {
//               loading = false;
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Invalid username or password')),
//             );
//           }
//         } else {
//           // Admin not found in Firestore
//           setState(() {
//             loading = false;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Admin not found in Firestore')),
//           );
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         SystemNavigator.pop();
//         return true;
//       },
//       child: Scaffold(
//         body: Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Card(
//               elevation: 8,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       "Login to MentorSpark",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           Container(
//                             width: 200.w,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.blueGrey.shade100,
//                                   spreadRadius: 1,
//                                   blurRadius: 8,
//                                   offset: Offset(4, 4),
//                                 ),
//                               ],
//                             ),
//                             child: TextFormField(
//                               keyboardType: TextInputType.text,
//                               controller: usernameController,
//                               decoration: InputDecoration(
//                                 hintText: 'Username',
//                                 hintStyle: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                                 border: InputBorder.none,
//                                 prefixIcon: Icon(Icons.person_rounded),
//                               ),
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return '   Username should not be empty';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           Container(
//                             width: 200.w,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.blueGrey.shade100,
//                                   spreadRadius: 1,
//                                   blurRadius: 8,
//                                   offset: Offset(4, 4),
//                                 ),
//                               ],
//                             ),
//                             child: TextFormField(
//                               obscureText: !showPassword,
//                               keyboardType: TextInputType.text,
//                               controller: passwordController,
//                               decoration: InputDecoration(
//                                 hintText: 'Password',
//                                 border: InputBorder.none,
//                                 hintStyle: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                                 prefixIcon: Icon(Icons.lock, size: 20),
//                                 suffixIcon: IconButton(
//                                   color: Colors.grey,
//                                   icon: Icon(
//                                     showPassword
//                                         ? Icons.visibility
//                                         : Icons.visibility_off,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       showPassword = !showPassword;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return '   Password should not be empty';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       width: 200.w,
//                       child: RoundButton(
//                         title: 'Login',
//                         loading: loading,
//                         onTap: () {
//                           login(context);
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
