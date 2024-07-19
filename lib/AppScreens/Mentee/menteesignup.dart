import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'menteelogin.dart';

class MenteeSignup extends StatefulWidget {
  const MenteeSignup({Key? key}) : super(key: key);

  @override
  _MenteeSignupState createState() => _MenteeSignupState();
}

class _MenteeSignupState extends State<MenteeSignup> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String email = _emailController.text;
      String password = _passwordController.text;

      // Check if the username contains spaces
      if (username.contains(' ')) {
        _showErrorSnackBar("Username cannot contain spaces.");
        return;
      }

      // Check if the username is already taken
      bool isUsernameTaken = await _isUsernameTaken(username);
      if (isUsernameTaken) {
        _showErrorSnackBar("Username is already taken. Please choose another.");
        return;
      }

      // Check if the email already exists in Firestore
      bool isEmailTaken = await _isEmailTaken(email);
      if (isEmailTaken) {
        _showErrorSnackBar(
            "This email is already registered. Please use a different email.");
        return;
      }

      // Check if the password is strong
      if (!_isPasswordStrong(password)) {
        _showErrorSnackBar(
            "Password must be at least 8 characters long and include uppercase, lowercase, digits, and special characters.");
        return;
      }

      try {
        // Create a new user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Obtain the user ID from the userCredential
        String userId = userCredential.user!.uid;

        // Add data to Firestore only if validation passes
        await FirebaseFirestore.instance.collection('mentees').doc(userId).set({
          'username': username,
          'email': email,
          'password': password,
          'userId': userId,
        });

        // Show successful signup toast message
        _showSuccessSnackBar("Signup successful");

        // Navigate to the login page after successful signup
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MenteeLoginScreen(),
          ),
        );
      } catch (e) {
        print('Error during signup: $e');
        _showErrorSnackBar(
            "An error occurred during signup. Please try again.");
      }
    }
  }

  bool _isAlpha(String value) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(value);
  }

  bool _isPasswordStrong(String password) {
    // Password must be at least 8 characters, include uppercase, lowercase, digits, and special characters
    final isValid = RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(password);
    print('Password is strong: $isValid');
    return isValid;
  }

  Future<bool> _isUsernameTaken(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('mentees')
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<bool> _isEmailTaken(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('mentees')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }

  void _showErrorSnackBar(String errorMessage) {
    // Display an error message using SnackBar
    final snackBar = SnackBar(
      content: Text(errorMessage),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showSuccessSnackBar(String message) {
    // Display a success message using SnackBar
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70),
                Text(
                  "Sign Up to MentorSpark",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const MenteeLoginScreen()));
                      },
                      child: Text(
                        "Login",
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
                buildTextField(
                  _usernameController,
                  'Username',
                  Icons.person,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    } else if (!_isAlpha(value)) {
                      return 'Enter a valid username (only alphabets)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                buildTextField(
                  _emailController,
                  'Email',
                  Icons.alternate_email,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                            r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                buildPasswordTextField(),
                SizedBox(height: 12),
                buildTextField(
                  _confirmPasswordController,
                  'Confirm Password',
                  Icons.lock,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  hintText: 'Enter your password again',
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _submitForm,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 16),
                      ),
                      textStyle: MaterialStateProperty.all(
                        TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    child: Text("Sign Up"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      IconData icon, String? Function(String?)? validator,
      {String? hintText, String? errorMessage}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey),
              SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: labelText,
                    hintText: hintText,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                  validator: validator,
                ),
              ),
            ],
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPasswordTextField() {
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
          Icon(Icons.lock_open, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: InputBorder.none,
                suffixIcon: IconButton(
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
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
          ),
        ],
      ),
    );
  }
}
