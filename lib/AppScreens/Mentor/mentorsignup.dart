import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'mentorlogin.dart';

const int minNameLength = 2;
const int minPasswordLength = 8;

class MentorSignup extends StatefulWidget {
  const MentorSignup({Key? key}) : super(key: key);

  @override
  State<MentorSignup> createState() => _MentorSignupState();
}

class _MentorSignupState extends State<MentorSignup> {
  int currentStep = 0;

  DateTime? _date;

  List<String> items = ["Gender", "Male", "Female"];
  String dropdownValue = 'Gender';
  List<String> items2 = ["Category", "Academia", "Business"];
  String dropdownValue2 = 'Category';

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _experienceTextFieldController =
      TextEditingController();
  final TextEditingController _experienceDescriptionTextFieldController =
      TextEditingController();

  final TextEditingController _linkedinProfileLinkController =
      TextEditingController();
  final TextEditingController _domainLinkController = TextEditingController();
  final TextEditingController _inviteCodeController = TextEditingController();
  final TextEditingController _studyDetailsController = TextEditingController();

  List<String> selectedPassions = [];
  List<String> passionCategories = [
    "Blockchain",
    "Cloud",
    "AI/ML",
    "Android Development",
    "JavaScript",
    "Backend",
    "Frontend",
    "Web",
    "Graphic Designing",
    "Marketing",
  ];
  bool showPassword = false;
  bool validateCurrentStep() {
    String errorMessage = '';

    switch (currentStep) {
      case 0:
        if (_fullNameController.text.length < minNameLength) {
          errorMessage = 'Full Name must be at least $minNameLength characters';
        } else if (_emailController.text.isEmpty) {
          errorMessage = 'Email cannot be empty';
        } else if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$')
            .hasMatch(_emailController.text)) {
          errorMessage = 'Please enter a valid email address';
        } else if (_passwordController.text.length < minPasswordLength) {
          errorMessage =
              'Password must be at least $minPasswordLength characters';
        } else if (!RegExp(
                r'(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])')
            .hasMatch(_passwordController.text)) {
          errorMessage =
              'Password must contain upper and lower case letters, numbers, and special characters';
        } else if (dropdownValue == 'Gender') {
          errorMessage = 'Please select a gender';
        } else if (_date == null) {
          errorMessage = 'Please select a date of birth';
        } else {
          // Check if the selected date is at least 25 years ago
          DateTime currentDate = DateTime.now();
          DateTime minAllowedDate = DateTime(
              currentDate.year - 25, currentDate.month, currentDate.day);
          if (_date!.isAfter(minAllowedDate)) {
            errorMessage = 'You must be at least 25 years old';
          }
        }
        break;

      case 1:
        if (_experienceTextFieldController.text.isEmpty) {
          errorMessage =
              'Organization Name cannot be empty If you are not from organization just write Null in the field.';
        } else if (_experienceDescriptionTextFieldController.text.isEmpty) {
          errorMessage = 'Description cannot be empty';
        } else if (dropdownValue2 == 'Category') {
          errorMessage = 'Please select a category';
        }
        break;

      case 2:
        if (_studyDetailsController.text.isEmpty) {
          errorMessage = 'You must provide your study details';
        } else if (selectedPassions.isEmpty) {
          errorMessage = 'Please select at least one passion';
        }
        break;

      default:
        break;
    }

    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "Sign Up to MentorSpark",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light().copyWith(primary: primaryColor),
        ),
        child: Stepper(
          physics: ClampingScrollPhysics(),
          type: StepperType.horizontal,
          currentStep: currentStep,
          onStepContinue: continueStep,
          onStepCancel: cancelStep,
          onStepTapped: onStepTapped,
          controlsBuilder: controlsBuilder,
          steps: [
            Step(
              title: const Text("Profile"),
              content: Container(
                child: _buildProfilePage(),
              ),
              isActive: currentStep >= 0,
              state: currentStep >= 0 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Text("Experience"),
              content: Container(
                child: _buildExperiencePage(),
              ),
              isActive: currentStep >= 1,
              state: currentStep >= 1 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Text("Passion"),
              content: Container(
                child: _buildPassionPage(),
              ),
              state: currentStep >= 2 ? StepState.complete : StepState.disabled,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Wrap(
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const MentorLoginScreen()));
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade100,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: _getTextField(
              hint: "Full Name",
              controller: _fullNameController,
            ),
          ),
          SizedBox(height: 16),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.shade100,
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child:
                  _getTextField(hint: "Email", controller: _emailController)),
          SizedBox(height: 16),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.shade100,
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: _genderDropdown()),
          SizedBox(height: 16),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.shade100,
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: _stackedDateOfBirthTextField()),
          SizedBox(height: 16),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.shade100,
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: _getTextField(
                hint: "Password",
                controller: _passwordController,
                isPassword: true,
                showPassword: showPassword,
              )),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _getTextField({
    required String hint,
    TextEditingController? controller,
    bool showPassword = false,
    bool isEmailField = false,
    bool isPassword = false,
    int? minLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        obscureText: isPassword && !showPassword,
        keyboardType:
            isEmailField ? TextInputType.emailAddress : TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  color: Colors.grey,
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    if (isPassword) {
                      setState(() {
                        this.showPassword = !this.showPassword;
                      });
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }

  Future<void> _signUpWithEmailAndPassword() async {
    print("Sign Up button clicked");
    try {
      if (validateCurrentStep() && _passwordController.text.length >= 8) {
        String email = _emailController.text.trim();
        String password = _passwordController.text;

        // Check if user name and email already exist
        bool isUserNameUnique =
            await isUserNameAvailable(_fullNameController.text.trim());
        bool isEmailUnique = await isEmailAvailable(email);

        if (!isUserNameUnique) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Username already exists. Please choose a different one.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (!isEmailUnique) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Email already exists. Please choose a different one.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Create a new user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String userId = userCredential.user!.uid;
        CollectionReference mentorsCollection =
            FirebaseFirestore.instance.collection('mentors');

        await mentorsCollection.doc(userId).set({
          "email": email,
          "fullName": _fullNameController.text.trim(),
          "dateOfBirth": _date != null
              ? "${_date?.day}-${_date?.month}-${_date?.year}"
              : null,
          "password": password,
          "gender": dropdownValue,
          "experience": {
            "description":
                _experienceDescriptionTextFieldController.text.trim(),
            // Add other fields under experience as needed
          },
          "category": dropdownValue2,
          "organization": _experienceTextFieldController.text.trim(),
          "inviteCode": _inviteCodeController.text.trim(), // Added invite code
          "domain": _domainLinkController.text.trim(),
          "linkedinProfile": _linkedinProfileLinkController.text.trim(),
          "studyDetails":
              _studyDetailsController.text.trim(), // Added study details
          "imageUrl": "",
          "passions": selectedPassions,
          // Add other fields as needed
        });

        _fullNameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _date = null;
        _experienceTextFieldController.clear();
        _experienceDescriptionTextFieldController.clear();
        _linkedinProfileLinkController.clear();
        _domainLinkController.clear();
        _inviteCodeController.clear();
        _studyDetailsController.clear();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MentorLoginScreen(),
          ),
        );
      }
    } catch (e) {
      // Handle errors
      print("Error during sign up: $e");
    }
  }

  Future<bool> isEmailAvailable(String email) async {
    // Query Firestore to check if the email already exists
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('mentors')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    // If the query result is empty, the email is available
    return querySnapshot.docs.isEmpty;
  }

  Future<bool> isUserNameAvailable(String userName) async {
    // Query Firestore to check if the user name already exists
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('mentors')
        .where('fullName', isEqualTo: userName)
        .limit(1)
        .get();

    // If the query result is empty, the user name is available
    return querySnapshot.docs.isEmpty;
  }

  Widget _buildExperiencePage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tell us about Your Experience",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade100,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: _getTextField(
              hint: "Organization Name",
              controller: _experienceTextFieldController,
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade100,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: _getTextField(
              hint: "Invite Code",
              controller: _inviteCodeController,
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade100,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: _getTextField(
              hint: "Description",
              controller: _experienceDescriptionTextFieldController,
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade100,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: _getDropdownField(
              hint: "Category",
              value: dropdownValue2,
              items: items2,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue2 = newValue!;
                });
              },
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade100,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Domain",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              controller: _domainLinkController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your organization domain link';
                }
                RegExp regExp = RegExp(
                    r'^https?:\/\/(?:www\.)?linkedin\.com\/(?:in|pub|profile)\/[a-zA-Z0-9-]+\/?$');
                if (!regExp.hasMatch(value)) {
                  return 'Please enter a valid domain link';
                }
                return null;
              },
              keyboardType: TextInputType.url,
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade100,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "LinkedIn Profile",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              controller: _linkedinProfileLinkController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your LinkedIn profile link';
                }
                RegExp regExp = RegExp(
                    r'^https?:\/\/(?:www\.)?linkedin\.com\/(?:in|pub|profile)\/[a-zA-Z0-9-]+\/?$');
                if (!regExp.hasMatch(value)) {
                  return 'Please enter a valid LinkedIn profile link';
                }
                return null;
              },
              keyboardType: TextInputType.url,
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _getDropdownField({
    required String hint,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPassionPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Study Details",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade100,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _studyDetailsController,
              decoration: InputDecoration(
                hintText: "Enter your study details",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8.0),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null, // Allows for unlimited lines
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Areas of Interest",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: passionCategories.map((passion) {
              return FilterChip(
                label: Text(passion),
                selected: selectedPassions.contains(passion),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      selectedPassions.add(passion);
                    } else {
                      selectedPassions.remove(passion);
                    }
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _stackedDateOfBirthTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: DateTime(1999), // Default to 25 years ago from 2024
            firstDate: DateTime(1900),
            lastDate: DateTime.now()
                .subtract(Duration(days: 365 * 25)), // Limit to 25 years ago
          ).then((date) {
            setState(() {
              _date = date;
            });
          });
        },
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: _date == null
                  ? "Select Date of Birth"
                  : "${_date!.day}-${_date!.month}-${_date!.year}",
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        value: dropdownValue,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _experienceTextField(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.shade100,
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: _getTextField(hint: hint, controller: controller),
    );
  }

  Widget _experienceDescriptionTextField(
      String hint, TextEditingController controller) {
    return Container(
      height: 120, // Set a fixed height or adjust as needed
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
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: null, // Allows for unlimited lines
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }

  Widget _experienceCategoryDropdown() {
    return Container(
      height: 50,
      width: 90,
      decoration: BoxDecoration(
        color: dropdownValue2 == 'Category' ? Colors.white : primaryColor,
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
      child: Center(
        child: DropdownButton<String>(
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue2 = newValue!;
            });
          },
          value: dropdownValue2,
          underline: Container(),
          items: items2.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: dropdownValue2 == 'Category'
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  void continueStep() async {
    if (validateCurrentStep()) {
      if (currentStep < 2) {
        if (currentStep == 0) {
          // Check if the user name and email are unique before proceeding to the next step
          bool isUserNameUnique =
              await isUserNameAvailable(_fullNameController.text.trim());
          bool isEmailUnique =
              await isEmailAvailable(_emailController.text.trim());
          if (!isUserNameUnique) {
            // Show Snackbar with error message if user name is not unique
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Username already exists. Please choose a different one.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          if (!isEmailUnique) {
            // Show Snackbar with error message if email is not unique
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Email already exists. Please choose a different one.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        } else if (currentStep == 1) {
          // Check if LinkedIn profile field is empty or contains an invalid link
          String linkedinProfileLink =
              _linkedinProfileLinkController.text.trim();
          if (linkedinProfileLink.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please enter your LinkedIn profile link'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          } else {
            RegExp regExp = RegExp(
                r'^https?:\/\/(?:www\.)?linkedin\.com\/(?:in|pub|profile)\/[a-zA-Z0-9-]+\/?$');
            if (!regExp.hasMatch(linkedinProfileLink)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter a valid LinkedIn profile link'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
          }
        }
        setState(() {
          currentStep = currentStep + 1;
        });
      } else {
        // If on the last step, trigger signup process
        _signUpWithEmailAndPassword();
      }
    }
  }

  void cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep -= 1;
      });
    }
  }

  void onStepTapped(int step) {
    if (step <= currentStep) {
      setState(() {
        currentStep = step;
      });
    }
  }

  Widget controlsBuilder(context, details) {
    if (currentStep == 2) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: details.onStepContinue,
              child: Text('Confirm'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 40,
                ),
                minimumSize: Size(120, 40),
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                primary: primaryColor,
                onPrimary: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 40,
                ),
                minimumSize: Size(120, 40),
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                primary: primaryColor,
                onPrimary: Colors.white,
              ),
              onPressed: details.onStepCancel,
              child: Text('Back'),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: details.onStepContinue,
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 40,
                ),
                minimumSize: Size(120, 40),
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                primary: primaryColor,
                onPrimary: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8),
          if (currentStep != 0)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 40,
                  ),
                  minimumSize: Size(120, 40),
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  primary: primaryColor,
                  onPrimary: Colors.white,
                ),
                onPressed: details.onStepCancel,
                child: Text('Back'),
              ),
            ),
        ],
      );
    }
  }

  Widget _passionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var category in passionCategories.take(2))
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02,
            ),
            child: _passionButton(category),
          ),
      ],
    );
  }

  Widget _passionButton(String category) {
    bool isSelected = selectedPassions.contains(category);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.shade100,
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (isSelected) {
              selectedPassions.remove(category);
            } else {
              selectedPassions.add(category);
            }
          });
        },
        style: ElevatedButton.styleFrom(
          primary: isSelected ? primaryColor : Colors.white,
          onPrimary: isSelected ? Colors.white : Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding
          // Set minimum button size based on text length
          minimumSize: Size((category.length * 12).toDouble(), 50.0),
        ),
        child: Text(category),
      ),
    );
  }
}
