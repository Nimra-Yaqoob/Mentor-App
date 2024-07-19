import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentorapp/AppScreens/constant.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        centerTitle: true,
        backgroundColor: secondaryColor,
        actions: [
          PopupMenuButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            position: PopupMenuPosition.under,
            icon: Icon(CupertinoIcons.add_circled),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "New Chat",
                  child: ListTile(
                    leading: Icon(CupertinoIcons.person_2_fill),
                    title: Text("New Chat", maxLines: 1),
                    onTap: () => ZIMKit().showDefaultNewPeerChatDialog(context),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: ZIMKitConversationListView(
        onPressed: (context, converstion, defaultAction) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ZIMKitMessageListPage(
                  conversationID: converstion.id,
                  conversationType: converstion.type,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
