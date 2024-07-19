// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:mentorapp/firebase_services/session_manager.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final ref = FirebaseDatabase.instance.ref('data');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: StreamBuilder(
//             stream: ref.child(SessionController().userId.toString()).onValue,
//             builder: (context, AsyncSnapshot snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (snapshot.hasData) {
//                 Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 20),
//                     Center(
//                       child: Container(
//                         height: 130,
//                         width: 130,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.grey, width: 3),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(100),
//                           child: Image(
//                               fit: BoxFit.cover,
//                               image: AssetImage('image/Image'),
//                               loadingBuilder:
//                                   (context, child, loadingProgress) {
//                                 if (loadingProgress == null) return child;
//                                 return Center(
//                                   child: CircularProgressIndicator(),
//                                 );
//                               },
//                               errorBuilder: (context, Object, Stack) {
//                                 return Container(
//                                     child: Icon(
//                                   Icons.error_outline,
//                                   color: Colors.black,
//                                 ));
//                               }),
//                         ),
//                       ),
//                     ),
//                     ReusableRow(
//                         title: 'Name',
//                         value: map['name'],
//                         iconData: Icons.person),
//                     ReusableRow(
//                         title: 'Email',
//                         value: map['email'],
//                         iconData: Icons.person),
//                     ReusableRow(
//                         title: 'Password',
//                         value: map['password'],
//                         iconData: Icons.person),
//                   ],
//                 );
//               } else {
//                 return Center(
//                   child: Text(
//                     'Something went wrong',
//                     style: Theme.of(context).textTheme.subtitle1,
//                   ),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ReusableRow extends StatelessWidget {
//   final String title, value;
//   final IconData iconData;
//   const ReusableRow(
//       {super.key,
//       required this.title,
//       required this.value,
//       required this.iconData});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text(title),
//           leading: Icon(iconData),
//           trailing: Text(value),
//         ),
//         Divider(color: Colors.grey.withOpacity(0.5)),
//       ],
//     );
//   }
// }
