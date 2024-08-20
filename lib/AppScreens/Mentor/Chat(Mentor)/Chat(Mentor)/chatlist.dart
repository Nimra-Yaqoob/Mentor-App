import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/Mentor/home%20page/mentorhomepage.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:mentorapp/AppScreens/Mentor/Chat(Mentor)/Chat(Mentor)/chathome.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';

class ChatsListPage extends StatefulWidget {
  @override
  _ChatsListPageState createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage> {
  late String currentUserId;
  late Stream<List<Map<String, dynamic>>> chatsStream;

  @override
  void initState() {
    super.initState();
    currentUserId = SessionManager.getUserId() ?? '';
    chatsStream = _fetchChats();
  }

  Stream<List<Map<String, dynamic>>> _fetchChats() {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> chats = [];
      for (var doc in snapshot.docs) {
        final chatData = doc.data() as Map<String, dynamic>;

        final recentMessageSnapshot = await FirebaseFirestore.instance
            .collection('chats')
            .doc(doc.id)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        final recentMessage = recentMessageSnapshot.docs.isNotEmpty
            ? recentMessageSnapshot.docs.first.data()['text'] ?? 'No messages'
            : 'No messages';

        // Check if mentor's name and image URL are available in chatData
        final reciverName = chatData['reciverName'] ?? 'Unknown';
        final reciverImageUrl =
            chatData['mentorImageUrl'] ?? 'https://via.placeholder.com/150';

        chats.add({
          'username': reciverName,
          'message': recentMessage,
          'imageUrl': reciverImageUrl,
          'chatId': doc.id,
        });
      }
      return chats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MentorHomePage(),
                ));
              },
            ),
            SizedBox(width: 8.0),
            Text(
              'Chats',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final chats = snapshot.data ?? [];

          return chats.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "image/message.png",
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        'Start your chat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return Dismissible(
                      key: Key(chat['chatId'] ?? ''),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _showDeleteConfirmationDialog(
                            context, chat['chatId'] ?? '');
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Material(
                          elevation: 8.0,
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.grey.shade200],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(chat['image'] ??
                                    'https://via.placeholder.com/150'),
                                radius: 25.0,
                              ),
                              title: Text(
                                chat['username'] ?? 'Unknown',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                chat['message'] ?? 'No messages',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatHome(
                                      userName: chat['username'] ?? 'Unknown',
                                      imageUrl: chat['imageUrl'] ??
                                          'https://via.placeholder.com/150',
                                      currentUserId: currentUserId,
                                      chatId: chat['chatId'] ?? '',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEmailPopup(context);
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 10.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String chatId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Chat'),
          content: Text('Do you want to delete this chat?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Handle the deletion
                await FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatId)
                    .delete();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEmailPopup(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Email'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Enter email to start chatting',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final userData = await _fetchUserDataByEmail(email);
                final currentUserId = SessionManager.getUserId() ?? '';
                final currentUserName =
                    SessionManager.getUserName() ?? 'Unknown';
                final currentUserEmail = SessionManager.getUserEmail() ?? '';

                if (userData != null) {
                  final chatId = _generateChatId(currentUserId, userData['id']);

                  // Create a new chat document with correct sender and receiver details
                  await FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatId)
                      .set({
                    'participants': [currentUserId, userData['id']],
                    'senderName': currentUserName,
                    'senderEmail': currentUserEmail,
                    'reciverName': userData[
                        'username'], // Correctly store the receiver's name
                    'reciverImageUrl': userData[
                        'imageUrl'], // Correctly store the receiver's image URL
                  });

                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatHome(
                        userName: userData['username'],
                        imageUrl: userData['imageUrl'],
                        currentUserId: currentUserId,
                        chatId: chatId,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email not found!')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _fetchUserDataByEmail(String email) async {
    // Search in the mentees collection
    final menteeQuerySnapshot = await FirebaseFirestore.instance
        .collection('mentees')
        .where('email', isEqualTo: email)
        .get();

    if (menteeQuerySnapshot.docs.isNotEmpty) {
      final userData = menteeQuerySnapshot.docs.first.data();
      return {
        'id': menteeQuerySnapshot.docs.first.id,
        'username': userData['username'] ?? 'Unknown',
        'imageUrl': userData['imageUrl'] ?? 'https://via.placeholder.com/150',
      };
    }

    // If not found, search in the organizations collection
    final organizationQuerySnapshot = await FirebaseFirestore.instance
        .collection('organizations')
        .where('email', isEqualTo: email)
        .get();

    if (organizationQuerySnapshot.docs.isNotEmpty) {
      final userData = organizationQuerySnapshot.docs.first.data();
      return {
        'id': organizationQuerySnapshot.docs.first.id,
        'username': userData['username'] ??
            'Unknown', // Assuming organizations have a 'name' field
        'imageUrl': userData['imageUrl'] ?? 'https://via.placeholder.com/150',
      };
    }

    // Return null if no match is found in either collection
    return null;
  }

  String _generateChatId(String userId1, String userId2) {
    return [userId1, userId2]
        .reduce((a, b) => a.compareTo(b) < 0 ? a + b : b + a);
  }
}
