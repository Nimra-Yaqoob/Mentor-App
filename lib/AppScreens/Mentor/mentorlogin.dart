import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mentorapp/AppScreens/Mentee/home/Widgets/roundbutton.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:mentorapp/AppScreens/terms_conditions.dart';
import 'package:mentorapp/Utils/forgot_password.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';
import 'package:mentorapp/utils/utils.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'home page/mentorhomepage.dart';
import 'mentorsignup.dart';

class MentorLoginScreen extends StatefulWidget {
  const MentorLoginScreen({Key? key}) : super(key: key);

  @override
  _MentorLoginScreenState createState() => _MentorLoginScreenState();
}

class _MentorLoginScreenState extends State<MentorLoginScreen> {
  bool _isPasswordVisible = false;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          '690478336084-q2a77krv74gp6svh2afjeq4i314soju2.apps.googleusercontent.com');

  bool checkTheBox = false;
  check() {
    setState(() {
      checkTheBox = !checkTheBox;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> login() async {
    setState(() {
      loading = true;
    });

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('mentors')
              .where('email', isEqualTo: emailController.text)
              .where('password', isEqualTo: passwordController.text)
              .get();

      if (snapshot.docs.isNotEmpty) {
        // Fetch the user ID
        String userId = snapshot.docs.first.id;
        // String username = snapshot.docs.first.get('username');
        // Store the user ID in your SessionManager or wherever needed
        SessionManager.setUserId(userId);

        // Login to Zego ZIMKit
        await ZIMKit().connectUser(
          id: userId,
        );

        Utils().toastMessage("Login successful");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MentorHomePage()),
        );
      } else {
        Utils().toastMessage("Invalid email or password");
      }
    } catch (error) {
      print('Error logging in: $error');
      Utils().toastMessage("Error logging in: $error");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Sign In to MentorSpark",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const MentorSignup()));
                      },
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField(
                        emailController,
                        'Email',
                        Icons.alternate_email,
                        TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      buildTextField(
                        passwordController,
                        'Password',
                        Icons.lock_open,
                        TextInputType.text,
                        isPassword: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 8.0),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text('Forgot Password?'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Wrap(
                  children: [
                    Text(
                      "By signing in to MentorSpark you agree to our ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const TermsAndConditions()));
                      },
                      child: Text(
                        "terms and conditions",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String labelText,
    IconData icon,
    TextInputType keyboardType, {
    bool isPassword = false,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.shade100,
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                border: InputBorder.none,
                hintText: isPassword ? 'Enter your password' : null,
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      )
                    : null,
              ),
              keyboardType: keyboardType,
              obscureText: isPassword && !_isPasswordVisible,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter ${isPassword ? 'password' : 'email'}';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
