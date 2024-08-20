import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/Organization/organizationavdrawer.dart';
import 'package:mentorapp/AppScreens/Organization/organizationhome.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:mentorapp/AppScreens/startingScreens/roleselection.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';

class OrganizationSetting extends StatefulWidget {
  const OrganizationSetting({Key? key}) : super(key: key);

  @override
  _OrganizationSettingState createState() => _OrganizationSettingState();
}

class _OrganizationSettingState extends State<OrganizationSetting> {
  final auth = FirebaseAuth.instance;
  User? currentUser;
  Map<String, dynamic>? organizationData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    currentUser = auth.currentUser;
    final String userId = SessionManager.getUserId();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('organizations')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          organizationData = snapshot.data() as Map<String, dynamic>?;
        });
      } else {
        throw Exception('Organization not found.');
      }
    } catch (e) {
      print('Error fetching Organization data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu, color: Colors.white));
        }),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: GreenColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 24.0),
          child: Column(
            children: [
              // Display profile image or icon
              Stack(
                children: [
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: organizationData?['imageUrl'] != null &&
                              organizationData!['imageUrl']!.isNotEmpty
                          ? Image.network(
                              organizationData!['imageUrl']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.account_circle,
                                    size: 110, color: Colors.grey);
                              },
                            )
                          : const Icon(Icons.account_circle,
                              size: 110, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Displaying username and email
              Text(
                organizationData?['username'] ??
                    currentUser?.displayName ??
                    'N/A',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                currentUser?.email ?? organizationData?['email'] ?? 'N/A',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 15),
              ProfileMenu(
                title: 'Home',
                icon: Icons.home,
                textColor: Colors.black,
                onPress: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrganizationHome(),
                    ),
                  );
                },
              ),
              ProfileMenu(
                title: 'Privacy Policy',
                icon: Icons.privacy_tip_outlined,
                textColor: Colors.black,
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Privacy Policy'),
                        content: Container(
                          height: 300, // Set a fixed height to enable scrolling
                          child: SingleChildScrollView(
                            child: Text(
                              'When you use our social media app, we may collect certain data to enhance your experience and provide you with tailored content. This may include information such as your name, email address, location, and usage data. Rest assured, we will never sell or share your personal information with third parties without your consent, except as required by law. We use industry-standard security measures to safeguard your data and ensure its confidentiality. By using our app, you agree to the terms outlined in our privacy policy. We encourage you to review the policy regularly for updates. Your privacy is important to us, and we strive to maintain the trust you place in us.',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ProfileMenu(
                title: 'Logout',
                icon: Icons.logout_outlined,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  auth.signOut().then((value) {
                    SessionController().userId = '';
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoleSelection()));
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.black.withOpacity(.1),
        ),
        child: Icon(icon, color: GreenColor),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1?.apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(.1),
              ),
              child: const Icon(Icons.chevron_right,
                  size: 18.0, color: Colors.grey),
            )
          : null,
    );
  }
}
