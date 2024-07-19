import 'package:flutter/material.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:mentorapp/AppScreens/Meeting/newmeeting.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({Key? key, required String channelName}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late String userName;
  late String userID;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  void fetchUserInfo() {
    // Get current user's information using SessionManager
    userName = SessionManager.getUserName();
    userID = SessionManager.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        userName: userName,
        userID: userID,
        conferenceID: conferenceID,
        appID: 321429250,
        appSign:
            "18d2c162874d887ee9f73733a871610ab74a2561eccfad60c8a07fc1d3267e68",
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),
    );
  }
}
