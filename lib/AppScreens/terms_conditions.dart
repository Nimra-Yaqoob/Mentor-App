import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/constant.dart';

import 'startingScreens/roleselection.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool isPressed = false;
  Color acceptButtonColor = Colors.white;
  Color declineButtonColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const RoleSelection()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Terms of Service',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              const Text(
                'Last updated on January 2024',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                '1. Terms',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'By accessing our app, Vlad Grama APP, you are agreeing to be bound by these terms of service, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing Vlad Grama APP. The materials contained in Vlad Grama APP are protected by applicable copyright and trademark law.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              const Text(
                '2. Use License',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Permission is granted to temporarily download one copy of Vlad Grama APP per device for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• modify or copy the materials;\n• use the materials for any commercial purpose or for any public display (commercial or non-commercial);\n• attempt to decompile or reverse engineer any software contained in Vlad Grama APP;\n• remove any copyright or other proprietary notations from the materials; or\n• transfer the materials to another person or "mirror" the materials on any other server.\n\nThis license shall automatically terminate if you violate any of these restrictions and may be terminated by Vlad Grama APP at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        acceptButtonColor = GreenColor;
                        declineButtonColor = Colors.white;
                      });
                      // Handle accept button press
                    },
                    child: const Text('Accept',
                        style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: acceptButtonColor,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isPressed = !isPressed;
                      });

                      // Handle decline button press
                    },
                    child: const Text(
                      'Decline',
                      style: TextStyle(
                          // color: isPressed ? Colors.white,
                          ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPressed ? GreenColor : Colors.white,
                      // primary: declineButtonColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
