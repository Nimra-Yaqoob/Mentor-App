import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:mentorapp/AppScreens/constant.dart';

import 'dashboard.dart';
import 'mentors.dart';
import 'mentees.dart';
import 'organization.dart';

class AdminPanel extends StatefulWidget {
  // const AdminPanel({Key? key}) : super(key: key);

  static const String id = "webmain";

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  Widget selectedScreen = Dashboard();

  chooseScreens(String title) {
    switch (title) {
      case "Total Users":
        setState(() {
          selectedScreen = const Dashboard();
        });
        break;
      case "Organizations":
        setState(() {
          selectedScreen = const Organization();
        });
        break;
      case "Mentors":
        setState(() {
          selectedScreen = const Mentor();
        });
        break;
      case "Mentees":
        setState(() {
          selectedScreen = const Mentee();
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Admin",
          style: TextStyle(color: Colors.white), // Set text color
        ),
        iconTheme: IconThemeData(color: Colors.white), // Set icon color
      ),
      sideBar: SideBar(
        onSelected: (item) {
          chooseScreens(item.title);
        },
        items: const [
          AdminMenuItem(
            title: "Total Users",
            route: Dashboard.id,
          ),
          AdminMenuItem(
            title: "Organizations",
            route: Organization.id,
          ),
          AdminMenuItem(
            title: "Mentors",
            route: Mentor.id,
          ),
          AdminMenuItem(
            title: "Mentees",
            route: Mentee.id,
          ),
        ],
        selectedRoute: Dashboard.id,
      ),
      body: selectedScreen,
    );
  }
}
