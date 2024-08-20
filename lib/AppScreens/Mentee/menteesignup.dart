import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mentorapp/AppScreens/Mentee/Email_Verification/verify_email.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'menteelogin.dart';
import 'dart:io';

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
  File? _selectedImage; // For storing the selected image
  String? _imageUrl; // For storing the image URL

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      if (username.contains(' ')) {
        _showErrorSnackBar("Username cannot contain spaces.");
        return;
      }

      try {
        bool isUsernameTaken = await _isUsernameTaken(username);
        if (isUsernameTaken) {
          _showErrorSnackBar(
              "Username is already taken. Please choose another.");
          return;
        }

        bool isEmailTaken = await _isEmailTaken(email);
        if (isEmailTaken) {
          _showErrorSnackBar(
              "This email is already registered. Please use a different email.");
          return;
        }

        if (!_isPasswordStrong(password)) {
          _showErrorSnackBar(
              "Password must be at least 8 characters long and include uppercase, lowercase, digits, and special characters.");
          return;
        }

        if (_selectedImage == null) {
          _showErrorSnackBar("Please upload an image.");
          return;
        }

        // Create a new user
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String userId = userCredential.user!.uid;

        // Upload the image to Firebase Storage
        String imagePath = 'mentees/$userId/profile_image.png';
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child(imagePath)
            .putFile(_selectedImage!);
        TaskSnapshot storageSnapshot = await uploadTask;

        _imageUrl = await storageSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('mentees').doc(userId).set({
          'username': username,
          'email': email,
          'userId': userId,
          'imageUrl': _imageUrl,
        });

        // Send verification email
        await userCredential.user!.sendEmailVerification();

        _showSuccessSnackBar(
            "Signup successful. Please check your email for verification.");

        // Navigate to the email verification screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => VerifyEmailScreen(userId: userId),
          ),
        );
      } catch (e) {
        print('Error during signup: $e');
        _showErrorSnackBar(
            "An error occurred during signup. Please try again.");
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  bool _isAlpha(String value) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(value);
  }

  bool _isPasswordStrong(String password) {
    return RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(password);
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
    final snackBar = SnackBar(
      content: Text(errorMessage),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showSuccessSnackBar(String message) {
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
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
                _buildProfileImageSection(),
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

  Widget buildTextField(
    TextEditingController controller,
    String labelText,
    IconData icon,
    String? Function(String?)? validator, {
    String? hintText,
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
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.grey),
        ),
        validator: validator,
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
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          } else if (!_isPasswordStrong(value)) {
            return 'Password must be at least 8 characters long and include uppercase, lowercase, digits, and special characters.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        padding: EdgeInsets.all(24),
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
        child: _selectedImage == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: 38,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Upload Image',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: FileImage(_selectedImage!),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Change Image',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
