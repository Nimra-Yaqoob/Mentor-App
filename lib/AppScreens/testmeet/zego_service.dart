import 'package:flutter/material.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'meeting_service.dart';

class ZegoService {
  Future<Widget> joinMeeting(String meetingID) async {
    String userID = SessionManager.getUserId();
    String userName = SessionManager.getUserName();

    // Add participant to the meeting
    await MeetingService().addParticipant(meetingID, userID, userName);

    // Increment the session count for this meeting
    await MeetingService().incrementSessionCount(meetingID, userID);

    return ZegoUIKitPrebuiltVideoConference(
      appID: 1395657183, // Replace with your actual App ID
      appSign:
          "5fe679c86eeb5506272c446dafb4d96ad6f78f2daee430a00d9b153b6db96327", // Replace with your actual App Sign
      userID: userID,
      userName: userName,
      conferenceID: meetingID, // Use the meeting ID as the conference ID
      config:
          ZegoUIKitPrebuiltVideoConferenceConfig(), // Add a default config if required
    );
  }
}
