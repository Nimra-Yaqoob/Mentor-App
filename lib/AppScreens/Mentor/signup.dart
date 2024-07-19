// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:mentorapp/AppScreens/constant.dart';

// class MentorSignup extends StatefulWidget {
//   const MentorSignup({Key? key}) : super(key: key);

//   @override
//   State<MentorSignup> createState() => _MentorSignupState();
// }

// class _MentorSignupState extends State<MentorSignup> {
//   int currentStep = 0;

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   DateTime? _date;

//   List<String> items = ["Gender", "Male", "Female"];
//   String dropdownValue = 'Gender';
//   List<String> items2 = ["Category", "Acadmia", "Business"];
//   String dropdownValue2 = 'Category';

//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _experienceTextFieldController =
//       TextEditingController();
//   final TextEditingController _experienceDescriptionTextFieldController =
//       TextEditingController();
//   String? _experienceCategoryDropdownValue;

//   final TextEditingController _linkedinProfileLinkController =
//       TextEditingController();
//   final TextEditingController _twitterProfileLinkController =
//       TextEditingController();

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   List<String> selectedPassions = [];
//   List<String> passionCategories = [
//     "Blockchain",
//     "Cloud",
//     "AI/ML",
//     "Android Development",
//     "JavaScript",
//     "Backend",
//     "Frontend",
//     "Web",
//     "Graphic Designing",
//     "Marketing",
//   ];
//   bool validateCurrentStep() {
//     switch (currentStep) {
//       case 0:
//         // Validate fields on the first step
//         if (_fullNameController.text.isEmpty ||
//             _emailController.text.isEmpty ||
//             _passwordController.text.isEmpty ||
//             dropdownValue == 'Gender' ||
//             (_date == null)) {
//           // Show an error message or handle validation failure
//           return false;
//         }
//         break;

//       case 1:
//         // Validate fields on the second step
//         if (_experienceTextFieldController.text.isEmpty ||
//             _experienceDescriptionTextFieldController.text.isEmpty ||
//             dropdownValue2 == 'Category') {
//           // Show an error message or handle validation failure
//           return false;
//         }
//         break;

//       case 2:
//         // Validate fields on the third step if needed
//         if (selectedPassions.isEmpty) {
//           // Show an error message or handle validation failure
//           return false;
//         }
//         break;

//       default:
//         break;
//     }

//     return true; // Validation passed
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Theme(
//         data: ThemeData(
//           colorScheme: ColorScheme.light().copyWith(primary: primaryColor),
//         ),
//         child: Stepper(
//           physics: ClampingScrollPhysics(),
//           type: StepperType.horizontal,
//           currentStep: currentStep,
//           onStepContinue: continueStep,
//           onStepCancel: cancelStep,
//           onStepTapped: onStepTapped,
//           controlsBuilder: controlsBuilder,
//           steps: [
//             Step(
//               title: const Text("Profile"),
//               content: Container(
//                 child: _buildProfilePage(),
//               ),
//               isActive: currentStep >= 0,
//               state: currentStep >= 0 ? StepState.complete : StepState.disabled,
//             ),
//             Step(
//               title: Text("Experience"),
//               content: Container(
//                 child: _buildExperiencePage(),
//               ),
//               isActive: currentStep >= 1,
//               state: currentStep >= 1 ? StepState.complete : StepState.disabled,
//             ),
//             Step(
//               title: Text("Passion"),
//               content: Container(
//                 child: _buildPassionPage(),
//               ),
//               state: currentStep >= 2 ? StepState.complete : StepState.disabled,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfilePage() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Sign Up to MentorSpark",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 4),
//           Wrap(
//             children: [
//               Text(
//                 "Already have an account? ",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   // Navigate to the login screen
//                 },
//                 child: Text(
//                   "Login",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     color: primaryColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 24),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.blueGrey.shade100,
//                   spreadRadius: 1,
//                   blurRadius: 8,
//                   offset: Offset(4, 4),
//                 ),
//               ],
//             ),
//             child: _getTextField(
//               hint: "Full Name",
//               controller: _fullNameController,
//             ),
//           ),
//           SizedBox(height: 16),
//           Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blueGrey.shade100,
//                     spreadRadius: 1,
//                     blurRadius: 8,
//                     offset: Offset(4, 4),
//                   ),
//                 ],
//               ),
//               child:
//                   _getTextField(hint: "Email", controller: _emailController)),
//           SizedBox(height: 16),
//           Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blueGrey.shade100,
//                     spreadRadius: 1,
//                     blurRadius: 8,
//                     offset: Offset(4, 4),
//                   ),
//                 ],
//               ),
//               child: _genderDropdown()),
//           SizedBox(height: 16),
//           Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blueGrey.shade100,
//                     spreadRadius: 1,
//                     blurRadius: 8,
//                     offset: Offset(4, 4),
//                   ),
//                 ],
//               ),
//               child: _stackedDateOfBirthTextField()),
//           SizedBox(height: 16),
//           Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blueGrey.shade100,
//                     spreadRadius: 1,
//                     blurRadius: 8,
//                     offset: Offset(4, 4),
//                   ),
//                 ],
//               ),
//               child: _getTextField(
//                 hint: "Password",
//                 controller: _passwordController,
//               )),

//           SizedBox(height: 16),
//           // ElevatedButton(
//           //   onPressed: _signUpWithEmailAndPassword,
//           //   child: Text('Sign Up'),
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExperiencePage() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Sign Up to MentorSpark",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(
//             height: 4,
//           ),
//           Wrap(
//             children: [
//               Text(
//                 "Tell us about Your Experience",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 24,
//           ),
//           _experienceTextField(
//               "Organization Name", _experienceTextFieldController),
//           SizedBox(
//             height: 16,
//           ),
//           _experienceDescriptionTextField(
//               "Description", _experienceDescriptionTextFieldController),
//           SizedBox(
//             height: 10,
//           ),
//           _experienceCategoryDropdown(),
//           SizedBox(
//             height: 16,
//           ),
//           _experienceProfileLinks(),
//           SizedBox(
//             height: 16,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPassionPage() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 52,
//           ),
//           Text(
//             "Sign Up to MentorSpark",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(
//             height: 4,
//           ),
//           Wrap(
//             children: [
//               Text(
//                 "Tell us about Your Passion",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           _passionButtons(),
//           SizedBox(
//             height: 10,
//           ),
//           _passionButtonsRows(),
//           SizedBox(
//             height: 24,
//           ),
//           // Container(
//           //   child: _getTextField(hint: "Referral Link / Code"),
//           // ),
//           SizedBox(
//             height: 16,
//           ),
//           ElevatedButton(
//             onPressed: _signUpWithEmailAndPassword,
//             style: ElevatedButton.styleFrom(
//               padding: EdgeInsets.all(20),
//               minimumSize: Size(double.infinity, 40),
//               textStyle: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//               ),
//               primary: primaryColor,
//               onPrimary: Colors.white,
//             ),
//             child: Text("Confirm"),
//           ),

//           SizedBox(
//             height: 16,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _getTextField({
//     required String hint,
//     TextEditingController? controller,
//     bool showPassword = false, // Add a parameter to identify password fields
//   }) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextFormField(
//         // obscureText: !showPassword,
//         keyboardType: TextInputType.text,
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: hint,
//           border: InputBorder.none,
//           suffixIcon: controller == _passwordController
//               ? IconButton(
//                   color: Colors.grey,
//                   icon: Icon(
//                     showPassword ? Icons.visibility : Icons.visibility_off,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       showPassword = !showPassword;
//                     });
//                   },
//                 )
//               : null,
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter $hint';
//           }

//           // Check password length
//           if (controller == _passwordController &&
//               showPassword &&
//               value.length < 7) {
//             return 'Password must be at least 7 characters';
//           }

//           return null;
//         },
//       ),
//     );
//   }

//   Widget _stackedDateOfBirthTextField() {
//     return Stack(
//       children: [
//         _getTextField(
//           hint: "DOB",
//           controller: TextEditingController(
//             text: _date != null
//                 ? "${_date?.day}-${_date?.month}-${_date?.year}"
//                 : "Date of Birth",
//           ),
//         ),
//         Positioned(
//           top: 10,
//           right: 0,
//           child: Padding(
//             padding: EdgeInsets.all(9.0),
//             child: InkWell(
//               onTap: () async {
//                 DateTime? datePicked = await showDatePicker(
//                   context: context,
//                   initialDate: _date ?? DateTime.now(),
//                   firstDate: DateTime(1940),
//                   lastDate: DateTime(2050),
//                 );
//                 if (datePicked != null) {
//                   print(
//                       'Date selected: ${datePicked.day}${datePicked.month}${datePicked.year}');
//                   setState(() {
//                     _date = datePicked;
//                   });
//                 }
//               },
//               child: Icon(
//                 Icons.calendar_today,
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _genderDropdown() {
//     return Container(
//       height: 50,
//       width: 90,
//       decoration: BoxDecoration(
//         color: dropdownValue == 'Gender' ? Colors.white : primaryColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Center(
//         child: DropdownButton<String>(
//           onChanged: (String? newValue) {
//             setState(() {
//               dropdownValue = newValue!;
//             });
//           },
//           value: dropdownValue,
//           underline: Container(),
//           items: items.map<DropdownMenuItem<String>>(
//             (String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color:
//                         dropdownValue == 'Gender' ? Colors.black : Colors.white,
//                   ),
//                 ),
//               );
//             },
//           ).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _experienceTextField(String hint, TextEditingController controller) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blueGrey.shade100,
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: Offset(4, 4),
//           ),
//         ],
//       ),
//       child: _getTextField(hint: hint, controller: controller),
//     );
//   }

//   Widget _experienceDescriptionTextField(
//       String hint, TextEditingController controller) {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blueGrey.shade100,
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: Offset(4, 4),
//           ),
//         ],
//       ),
//       child: _getTextField(hint: hint, controller: controller),
//     );
//   }

//   Widget _experienceCategoryDropdown() {
//     return Container(
//       height: 50,
//       width: 90,
//       decoration: BoxDecoration(
//         color: dropdownValue2 == 'Category' ? Colors.white : primaryColor,
//         // color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blueGrey.shade100,
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: Offset(4, 4),
//           ),
//         ],
//       ),
//       child: Center(
//         child: DropdownButton<String>(
//           onChanged: (String? newValue) {
//             setState(() {
//               dropdownValue2 = newValue!;
//             });
//           },
//           value: dropdownValue2,
//           underline: Container(),
//           items: items2.map<DropdownMenuItem<String>>(
//             (String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: dropdownValue2 == 'Category'
//                         ? Colors.black
//                         : Colors.white,
//                   ),
//                 ),
//               );
//             },
//           ).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _experienceProfileLinks() {
//     return Column(
//       children: [
//         _profileLinkTextField("Linkedin Profile (Enter Profile Link)",
//             controller: _linkedinProfileLinkController),
//         SizedBox(
//           height: 16,
//         ),
//         _profileLinkTextField("Twitter Profile (Enter Profile Link)",
//             controller: _twitterProfileLinkController),
//         SizedBox(
//           height: 16,
//         ),
//       ],
//     );
//   }

//   Widget _profileLinkTextField(String hint,
//       {TextEditingController? controller}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blueGrey.shade100,
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: Offset(4, 4),
//           ),
//         ],
//       ),
//       child: _getTextField(hint: hint, controller: controller),
//     );
//   }

//   void continueStep() {
//     if (validateCurrentStep()) {
//       if (currentStep < 2) {
//         setState(() {
//           currentStep = currentStep + 1;
//         });
//       }
//     } else {
//       // Show an error message or perform any other action on validation failure
//     }
//   }

//   void cancelStep() {
//     if (currentStep > 0) {
//       setState(() {
//         currentStep = currentStep - 1;
//       });
//     }
//   }

//   void onStepTapped(int value) {
//     setState(() {
//       currentStep = value;
//     });
//   }

//   Widget controlsBuilder(context, details) {
//     if (currentStep == 2) {
//       // If it's the third step, don't show the controls (Next and Back buttons)
//       return Container();
//     } else {
//       // For other steps, use the default controls
//       return Row(
//         children: [
//           Expanded(
//             child: ElevatedButton(
//               onPressed: details.onStepContinue,
//               child: Text('Next'),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.all(20),
//                 fixedSize: Size(90, 40),
//                 textStyle: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white, // Set text color to white
//                 ),
//                 primary: primaryColor,
//                 onPrimary: Colors.white,
//               ),
//             ),
//           ),
//           SizedBox(width: 8),
//           if (currentStep != 0)
//             Expanded(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.all(20),
//                   fixedSize: Size(90, 40),
//                   textStyle: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white, // Set text color to white
//                   ),
//                   primary: primaryColor,
//                   onPrimary: Colors.white,
//                 ),
//                 onPressed: details.onStepCancel,
//                 child: Text('Back'),
//               ),
//             ),
//         ],
//       );
//     }
//   }

//   Widget _passionButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         for (var category in passionCategories.take(2))
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: MediaQuery.of(context).size.width * 0.02,
//             ),
//             child: _passionButton(category),
//           ),
//       ],
//     );
//   }

//   Widget _passionButtonsRows() {
//     List<Widget> rows = [];
//     for (int i = 2; i < passionCategories.length; i += 2) {
//       List<String> rowCategories = passionCategories.sublist(
//         i,
//         i + 2 > passionCategories.length ? passionCategories.length : i + 2,
//       );
//       rows.add(
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             for (var category in rowCategories)
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: MediaQuery.of(context).size.width * 0.02,
//                 ),
//                 child: _passionButton(category),
//               ),
//           ],
//         ),
//       );
//     }

//     return Column(children: rows);
//   }

//   Widget _passionButton(String category) {
//     bool isSelected = selectedPassions.contains(category);

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blueGrey.shade100,
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: Offset(4, 4),
//           ),
//         ],
//       ),
//       child: ElevatedButton(
//         onPressed: () {
//           setState(() {
//             if (isSelected) {
//               selectedPassions.remove(category);
//             } else {
//               selectedPassions.add(category);
//             }
//           });
//         },
//         style: ElevatedButton.styleFrom(
//           primary: isSelected ? primaryColor : Colors.white,
//           onPrimary: isSelected ? Colors.white : Colors.black,
//         ),
//         child: Text(category),
//       ),
//     );
//   }

  // Future<void> _signUpWithEmailAndPassword() async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text,
  //     );

  //     String mentorUid = userCredential.user!.uid;
  //     await writeData(mentorUid); // Call the function to store mentor data

  //     // Do something after successful sign-up.
  //     // Example: Navigate to the next screen.
  //     // Navigator.of(context).pushReplacement(MaterialPageRoute(
  //     //   builder: (context) => NextScreen(),
  //     // ));
  //   } catch (e) {
  //     // Handle errors, e.g., display an error message to the user.
  //     print("Error during sign up: $e");
  //   }
  // }

  // Future<void> writeData(String uid) async {
  //   var mentorsUrl =
  //       "https://mentorapp-d2091-default-rtdb.firebaseio.com/mentors.json";

  //   try {
  //     final checkResponse = await http.get(Uri.parse(mentorsUrl));

  //     if (checkResponse.statusCode == 200) {
  //       final Map<String, dynamic>? data = json.decode(checkResponse.body);

  //       if (data == null) {
  //         await http.put(
  //           Uri.parse(mentorsUrl),
  //           body: json.encode({}),
  //         );
  //       }
  //     }

  //     var mentorUrl =
  //         "https://mentorapp-d2091-default-rtdb.firebaseio.com/mentors/$uid.json";
  //     final response = await http.put(
  //       Uri.parse(mentorUrl),
  //       body: json.encode({
  //         "email": _emailController.text.trim(),
  //         "fullName": _fullNameController.text.trim(),
  //         "dateOfBirth": _date != null
  //             ? "${_date?.day}-${_date?.month}-${_date?.year}"
  //             : null,
  //         "password": _passwordController.text,
  //         "gender": dropdownValue,
  //         "experience": {
  //           "organizationName": _experienceTextFieldController.text.trim(),
  //           "description":
  //               _experienceDescriptionTextFieldController.text.trim(),
  //           "category": dropdownValue2,
  //           "profileLinks": {
  //             "linkedin": _linkedinProfileLinkController.text.trim(),
  //             "twitter": _twitterProfileLinkController.text.trim(),
  //           },
  //         },

  //         "passions": selectedPassions,
  //         // Add other fields as needed
  //       }),
  //     );

  //     print('Data written: $response');

  //     // Clear text controllers after data is saved
  //     _fullNameController.clear();
  //     _emailController.clear();
  //     _passwordController.clear();
  //     _date = null;
  //     _experienceTextFieldController.clear();
  //     _experienceDescriptionTextFieldController.clear();
  //     _experienceCategoryDropdownValue = null;
  //     _linkedinProfileLinkController.clear();
  //     _twitterProfileLinkController.clear();
  //     // Clear other controllers as needed

  //     // Navigate to the next screen or perform any other actions here
  //   } catch (error) {
  //     print('Error writing data: $error');
  //     // Handle errors, e.g., display an error message to the user
  //   }
  // }

// }





























































































// import 'package:flutter/material.dart';
// import 'package:mentorapp/AppScreens/Mentor/first_page.dart';
// import 'package:mentorapp/AppScreens/Mentor/second_page.dart';
// import 'package:mentorapp/AppScreens/Mentor/third_page.dart';
// import 'package:mentorapp/AppScreens/constant.dart';

// class MentorSignup extends StatefulWidget {
//   const MentorSignup({Key? key}) : super(key: key);

//   @override
//   State<MentorSignup> createState() => _StepperWidgetState();
// }

// class _StepperWidgetState extends State<MentorSignup> {
//   int currentStep = 0;

//   continueStep() {
//     if (currentStep < 2) {
//       setState(() {
//         currentStep = currentStep + 1;
//       });
//     }
//   }

//   cancelStep() {
//     if (currentStep > 0) {
//       setState(() {
//         currentStep = currentStep - 1;
//       });
//     }
//   }

//   onStepTapped(int value) {
//     setState(() {
//       currentStep = value;
//     });
//   }

//   Widget controlsBuilder(context, details) {
//     if (currentStep == 2) {
//       // If it's the third step, don't show the controls (Next and Back buttons)
//       return Container();
//     } else {
//       // For other steps, use the default controls
//       return Row(
//         children: [
//           Expanded(
//             child: ElevatedButton(
//               onPressed: details.onStepContinue,
//               child: const Text('Next'),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.all(20),
//                 fixedSize: Size(90, 40),
//                 textStyle: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                 ),
//                 primary: primaryColor,
//                 onPrimary: Colors.white,
//               ),
//             ),
//           ),
//           SizedBox(width: 8),
//           if (currentStep != 0)
//             Expanded(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.all(20),
//                   fixedSize: Size(90, 40),
//                   textStyle: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                   ),
//                   onPrimary: Colors.white,
//                   primary: primaryColor,
//                 ),
//                 onPressed: details.onStepCancel,
//                 child: Text('Back'),
//               ),
//             ),
//         ],
//       );
//     }
//   }

//   Widget getTextField({required String hint}) {
//     return TextField(
//       decoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.transparent, width: 0),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.transparent, width: 0),
//           ),
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           filled: true,
//           fillColor: Colors.white,
//           hintText: hint,
//           hintStyle: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//           )),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Theme(
//         data: ThemeData(
//             colorScheme: ColorScheme.light().copyWith(primary: primaryColor)),
//         child: Stepper(
//           physics: ClampingScrollPhysics(),
//           type: StepperType.horizontal,
//           currentStep: currentStep,
//           onStepContinue: continueStep,
//           onStepCancel: cancelStep,
//           onStepTapped: onStepTapped,
//           controlsBuilder: controlsBuilder,
//           steps: [
//             Step(
//               title: const Text("Profile"),
//               content: Container(
//                 child: FirstPage(),
//               ),
//               isActive: currentStep >= 0,
//               state: currentStep >= 0 ? StepState.complete : StepState.disabled,
//             ),
//             Step(
//               title: Text("Experience"),
//               content: Container(
//                 child: SecondPage(),
//               ),
//               isActive: currentStep >= 1,
//               state: currentStep >= 1 ? StepState.complete : StepState.disabled,
//             ),
//             Step(
//               title: Text("Passion"),
//               content: Container(
//                 child: ThirdPage(),
//               ),
//               state: currentStep >= 2 ? StepState.complete : StepState.disabled,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }