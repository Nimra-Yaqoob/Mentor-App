import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/constant.dart';

class ChatHome extends StatefulWidget {
  final String userName;
  final String imageUrl;
  final String currentUserId;
  final String chatId;

  ChatHome({
    required this.userName,
    required this.imageUrl,
    required this.currentUserId,
    required this.chatId,
  });

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final TextEditingController _messageController = TextEditingController();
  late Stream<QuerySnapshot> _messagesStream;

  @override
  void initState() {
    super.initState();
    _messagesStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
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
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 8.0),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.imageUrl),
              radius: 16.0,
            ),
            SizedBox(width: 8.0),
            Text(
              widget.userName,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message['senderId'] == widget.currentUserId;
                    return _buildMessageTile(
                      message['text'],
                      isMe,
                      (message['timestamp'] as Timestamp).toDate().toString(),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageTile(String message, bool isMe, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe ? chatColor : Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text(
              message,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            time,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          CircleAvatar(
            backgroundColor: primaryColor,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    // Prepare message data
    final messageData = {
      'senderId': widget.currentUserId,
      'text': _messageController.text,
      'timestamp': Timestamp.now(),
    };

    // Save message to Firestore under the specific chat document
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add(messageData);

    // Clear the message input field
    _messageController.clear();
  }
}
