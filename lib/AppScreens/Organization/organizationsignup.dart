import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mentorapp/Utils/utils.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'organizationlogin.dart';

class OrganizationSignupPage extends StatefulWidget {
  const OrganizationSignupPage({Key? key}) : super(key: key);

  @override
  _OrganizationSignupPageState createState() => _OrganizationSignupPageState();
}

class _OrganizationSignupPageState extends State<OrganizationSignupPage> {
  TextEditingController _organizationNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _registrationController = TextEditingController();
  TextEditingController _domainLinkController = TextEditingController();

  bool _isPasswordVisible = false;
  File? _selectedDocument;

  // void _submitForm() async {
  //   String organizationName = _organizationNameController.text.trim();
  //   String email = _emailController.text;
  //   String password = _passwordController.text;
  //   String registration = _registrationController.text;
  //   String domainLink = _domainLinkController.text.trim();

  //   // Check if any field is empty
  //   if (organizationName.isEmpty ||
  //       email.isEmpty ||
  //       password.isEmpty ||
  //       registration.isEmpty ||
  //       domainLink.isEmpty) {
  //     _showErrorSnackBar("Please fill in all fields.");
  //     return;
  //   }

  //   // Validation checks for organizationName
  //   if (_containsSpecialCharacters(organizationName) ||
  //       _containsNumbers(organizationName)) {
  //     _showErrorSnackBar(
  //         "Organization name can only contain alphabetic characters.");
  //     return;
  //   }

  //   if (!EmailValidator.validate(email)) {
  //     _showErrorSnackBar("Please enter a valid email address.");
  //     return;
  //   }

  //   // Check password strength
  //   if (!_isPasswordStrong(password)) {
  //     _showErrorSnackBar(
  //         "Password must be at least 8 characters long and include uppercase, lowercase, digits, and special characters.");
  //     return;
  //   }

  //   // Check domain link format
  //   if (!_isValidDomainLinkFormat(domainLink)) {
  //     _showErrorSnackBar("Please enter a valid domain link.");
  //     return;
  //   }

  //   if (_selectedDocument == null) {
  //     _showErrorSnackBar("Please attach a document.");
  //     return;
  //   }

  //   try {
  //     // Check if the organization name already exists
  //     QuerySnapshot orgNameSnapshot = await FirebaseFirestore.instance
  //         .collection('organizations')
  //         .where('organizationName', isEqualTo: organizationName)
  //         .get();

  //     if (orgNameSnapshot.docs.isNotEmpty) {
  //       _showErrorSnackBar("Organization name already exists.");
  //       return;
  //     }

  //     // Check if the email already exists
  //     QuerySnapshot emailSnapshot = await FirebaseFirestore.instance
  //         .collection('organizations')
  //         .where('email', isEqualTo: email)
  //         .get();

  //     if (emailSnapshot.docs.isNotEmpty) {
  //       _showErrorSnackBar("Email already exists.");
  //       return;
  //     }

  //     // Create a new user with email and password
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     // Obtain the user ID from the userCredential
  //     String userId = userCredential.user!.uid;

  //     // Store the user ID in your SessionManager or wherever needed
  //     SessionManager.setUserId(userId);

  //     // Upload the document to Firebase Storage
  //     String fileName =
  //         'documents/$userId/${DateTime.now().millisecondsSinceEpoch}.pdf';
  //     Reference storageReference =
  //         FirebaseStorage.instance.ref().child(fileName);
  //     UploadTask uploadTask = storageReference.putFile(_selectedDocument!);

  //     // Wait for the upload to complete
  //     TaskSnapshot snapshot = await uploadTask;
  //     String documentUrl = await snapshot.ref.getDownloadURL();

  //     // Create a map with the data
  //     Map<String, dynamic> data = {
  //       'organizationName': organizationName,
  //       'email': email,
  //       'password': password,
  //       'registrationNumber': int.parse(registration),
  //       'domainLink': domainLink,
  //       'userId': userId,
  //       'documentUrl': documentUrl,
  //     };

  //     // Add data to Firestore only if validation passes
  //     await FirebaseFirestore.instance.collection('organizations').add(data);

  //     // Show successful signup toast message
  //     Utils().toastMessage("Signup successful");

  //     // Navigate to the login page after successful signup
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (context) => OrgnizationLoginScreen(),
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error during signup: $e');
  //     // Handle error
  //   }
  // }
  void _submitForm() async {
    String organizationName = _organizationNameController.text.trim();
    String email = _emailController.text;
    String password = _passwordController.text;
    String registration = _registrationController.text;
    String domainLink = _domainLinkController.text.trim();

    // Check if any field is empty
    if (organizationName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        registration.isEmpty ||
        domainLink.isEmpty) {
      _showErrorSnackBar("Please fill in all fields.");
      return;
    }

    // Validation checks for organizationName
    if (_containsSpecialCharacters(organizationName) ||
        _containsNumbers(organizationName)) {
      _showErrorSnackBar(
          "Organization name can only contain alphabetic characters.");
      return;
    }

    if (!EmailValidator.validate(email)) {
      _showErrorSnackBar("Please enter a valid email address.");
      return;
    }

    // Check password strength
    if (!_isPasswordStrong(password)) {
      _showErrorSnackBar(
          "Password must be at least 8 characters long and include uppercase, lowercase, digits, and special characters.");
      return;
    }

    // Check domain link format
    if (!_isValidDomainLinkFormat(domainLink)) {
      _showErrorSnackBar("Please enter a valid domain link.");
      return;
    }

    if (_selectedDocument == null) {
      _showErrorSnackBar("Please attach a document.");
      return;
    }

    try {
      // Check if the organization name already exists
      QuerySnapshot orgNameSnapshot = await FirebaseFirestore.instance
          .collection('organizations')
          .where('organizationName', isEqualTo: organizationName)
          .get();

      if (orgNameSnapshot.docs.isNotEmpty) {
        _showErrorSnackBar("Organization name already exists.");
        return;
      }

      // Check if the email already exists
      QuerySnapshot emailSnapshot = await FirebaseFirestore.instance
          .collection('organizations')
          .where('email', isEqualTo: email)
          .get();

      if (emailSnapshot.docs.isNotEmpty) {
        _showErrorSnackBar("Email already exists.");
        return;
      }

      // Create a new user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtain the user ID from the userCredential
      String userId = userCredential.user!.uid;

      // Store the user ID in your SessionManager or wherever needed
      SessionManager.setUserId(userId);

      // Upload the document to Firebase Storage
      String fileName =
          'documents/$userId/${DateTime.now().millisecondsSinceEpoch}.pdf';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(_selectedDocument!);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;
      String documentUrl = await snapshot.ref.getDownloadURL();

      // Create a map with the user data
      Map<String, dynamic> userData = {
        'organizationName': organizationName,
        'email': email,
        'password': password,
        'registrationNumber': int.parse(registration),
        'domainLink': domainLink,
        'userId': userId,
        'documentUrl': documentUrl,
        'status':
            'pending', // Add a status field indicating the user is pending approval
      };

      // Add user data to the pending collection
      await FirebaseFirestore.instance.collection('pending').add(userData);

      // Show successful signup toast message
      Utils().toastMessage(
          "Signup successful You have to wait for admin Approval.");

      // Navigate to the login page after successful signup
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OrgnizationLoginScreen(),
        ),
      );
    } catch (e) {
      print('Error during signup: $e');
      // Handle error
    }
  }

  bool _isPasswordStrong(String password) {
    // Password must be at least 8 characters, include uppercase, lowercase, digits, and special characters
    final isValid = RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(password);
    print('Password is strong: $isValid');
    return isValid;
  }

  bool _containsSpecialCharacters(String value) {
    // Check if the value contains special characters
    return RegExp(r'[!@#%^&*(),.?":{}|<>]').hasMatch(value);
  }

  bool _containsNumbers(String value) {
    // Check if the value contains numeric characters
    return RegExp(r'[0-9]').hasMatch(value);
  }

  bool _isValidDomainLinkFormat(String value) {
    // Check if the value is a valid domain link format
    return Uri.tryParse(value)?.isAbsolute ?? false;
  }

  void _showErrorSnackBar(String errorMessage) {
    // Display an error message using SnackBar
    final snackBar = SnackBar(
      content: Text(errorMessage),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedDocument = File(result.files.single.path!);
      });
    } else {
      _showErrorSnackBar("Please select a PDF document.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
              ),
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
                          builder: (context) =>
                              const OrgnizationLoginScreen()));
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
                _organizationNameController,
                'Organization Name',
                Icons.business,
              ),
              SizedBox(height: 12),
              buildTextField(_emailController, 'Email', Icons.alternate_email),
              SizedBox(height: 12),
              buildPasswordTextField(),
              SizedBox(height: 12),
              buildTextField(_registrationController, 'Registration Number',
                  Icons.confirmation_number),
              SizedBox(height: 12),
              buildTextField(
                _domainLinkController,
                'Domain Link',
                Icons.link,
                hintText: 'Enter your domain link',
              ),
              SizedBox(height: 12),
              Text('Documentation',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                icon: Icon(Icons.attach_file, color: Colors.grey),
                label: Text('Attach Your Document'),
                onPressed: _pickDocument,
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: secondaryColor,
                  elevation: 2,
                ),
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
    );
  }

  Widget buildTextField(
      TextEditingController controller, String labelText, IconData icon,
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
