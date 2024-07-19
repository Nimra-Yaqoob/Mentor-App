import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentorapp/AppScreens/Meeting/videocall.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';

class ConferenceCall extends StatefulWidget {
  const ConferenceCall({super.key});

  @override
  State<ConferenceCall> createState() => _ConferenceCallState();
}

String conferenceID = "";

class _ConferenceCallState extends State<ConferenceCall> {
  var VideoConfTextCtrl = TextEditingController(text: "Conference Id");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: VideoConfTextCtrl,
                  decoration: InputDecoration(
                    labelText: "Join by id",
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  conferenceID = VideoConfTextCtrl.text.trim();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => VideoCall(
                            channelName: '',
                          )),
                    ),
                  );
                },
                child: Text("JOin"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
