import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _nameState();
}

class _nameState extends State<Profilescreen> {
  final ref = FirebaseDatabase.instance.ref('mentees');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: StreamBuilder(
            stream: ref.child(SessionController().userId.toString()).onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 5)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://marketplace.canva.com/EAFSZhFumYM/1/0/1600w/canva-dark-red-neon-futuristic-instagram-profile-picture-MUPA4np8in0.jpg'),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, Object, stack) {
                              return Container(
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.amber,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    ReusableRow(
                      title: 'Username',
                      value: map['username'],
                      iconData: Icons.person_outline,
                    ),
                    ReusableRow(
                      title: 'Email',
                      value: map['email'],
                      iconData: Icons.email_outlined,
                    ),
                    ReusableRow(
                      title: 'Password',
                      value: map['password'],
                      iconData: Icons.password,
                    ),
                  ],
                );
              } else {
                return Center(
                    child: Text(
                  "Something went wrong",
                  style: Theme.of(context).textTheme.subtitle1,
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  final IconData iconData;
  const ReusableRow({
    Key? key,
    required this.title,
    required this.value,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: Icon(iconData),
          trailing: Text(value),
        ),
        Divider(color: Colors.grey.withOpacity(0.5)),
      ],
    );
  }
}


 // void _showErrorDialog(String title, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(title),
  //         content: Text(message),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
