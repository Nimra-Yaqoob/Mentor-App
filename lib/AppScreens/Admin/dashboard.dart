import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pending.dart';
import 'users list/mentor_list.dart';
import 'users list/organization_list.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);
  static const String id = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Card(
                        elevation: 3,
                        color: Colors.lightBlue[100],
                        child: SizedBox(
                          width: 150,
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.people,
                                        size: 30, color: Colors.blue),
                                    SizedBox(width: 10),
                                    Text(
                                      'Total Users',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('mentors')
                                      .snapshots(),
                                  builder: (context, mentorsSnapshot) {
                                    if (mentorsSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    final mentorsCount =
                                        mentorsSnapshot.data!.docs.length;
                                    return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('mentees')
                                          .snapshots(),
                                      builder: (context, menteesSnapshot) {
                                        if (menteesSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        final menteesCount =
                                            menteesSnapshot.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('organizations')
                                              .snapshots(),
                                          builder:
                                              (context, organizationsSnapshot) {
                                            if (organizationsSnapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }
                                            final organizationsCount =
                                                organizationsSnapshot
                                                    .data!.docs.length;
                                            final totalUsersCount =
                                                mentorsCount +
                                                    menteesCount +
                                                    organizationsCount;
                                            return Row(
                                              children: [
                                                Icon(Icons.group,
                                                    size: 20,
                                                    color: Colors.blue),
                                                SizedBox(width: 5),
                                                Text(
                                                    totalUsersCount.toString()),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PendingOrganizationList(),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        color: Colors.lightGreen[100],
                        child: SizedBox(
                          width: 150,
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.pending,
                                        size: 30, color: Colors.green),
                                    SizedBox(width: 10),
                                    Text(
                                      'Pending Users',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('pending')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Text('0');
                                    }
                                    final pendingUsers =
                                        snapshot.data!.docs.length;
                                    return Row(
                                      children: [
                                        Icon(Icons.timer,
                                            size: 20, color: Colors.green),
                                        SizedBox(width: 5),
                                        Text(pendingUsers.toString()),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrganizationsList(),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        color: Colors.purple[100],
                        child: SizedBox(
                          width: 150,
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.business,
                                        size: 30, color: Colors.purple),
                                    SizedBox(width: 10),
                                    Text(
                                      'Organizations',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('organizations')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Text('0');
                                    }
                                    final organizationsCount =
                                        snapshot.data!.docs.length;
                                    return Row(
                                      children: [
                                        Icon(Icons.account_balance,
                                            size: 20, color: Colors.purple),
                                        SizedBox(width: 5),
                                        Text(organizationsCount.toString()),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MentorsList(),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        color: Colors.orange[100],
                        child: SizedBox(
                          width: 150,
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.school,
                                        size: 30, color: Colors.orange),
                                    SizedBox(width: 10),
                                    Text(
                                      'Mentors',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('mentors')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Text('0');
                                    }
                                    final mentorsCount =
                                        snapshot.data!.docs.length;
                                    return Row(
                                      children: [
                                        Icon(Icons.person,
                                            size: 20, color: Colors.orange),
                                        SizedBox(width: 5),
                                        Text(mentorsCount.toString()),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
