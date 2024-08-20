import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorapp/firebase_services/session_manager.dart';
import 'package:uuid/uuid.dart'; // For generating unique meeting IDs

class MeetingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createMeeting(String meetingTitle, String meetingID) async {
    try {
      String userID = SessionManager.getUserId();
      String userName = SessionManager.getUserName();

      await _firestore.collection('meetings').doc(meetingID).set({
        'title': meetingTitle,
        'meetingID': meetingID,
        'createdBy': userID,
        'createdByName': userName,
        'createdAt': FieldValue.serverTimestamp(),
        'participants': [
          {
            'userID': userID,
            'userName': userName,
          }
        ],
        'totalSessions': 0, // Initialize session count
        'sessionHistory': [], // Initialize session history
      });

      print("Meeting created successfully!");
    } catch (e) {
      print("Error creating meeting: $e");
    }
  }

  Future<void> addParticipant(
      String meetingID, String userID, String userName) async {
    try {
      await _firestore.collection('meetings').doc(meetingID).update({
        'participants': FieldValue.arrayUnion([
          {
            'userID': userID,
            'userName': userName,
          }
        ]),
      });

      print("Participant added successfully!");
    } catch (e) {
      print("Error adding participant: $e");
    }
  }

  Future<void> incrementSessionCount(String meetingID, String userID) async {
    try {
      DocumentSnapshot meetingDoc =
          await _firestore.collection('meetings').doc(meetingID).get();
      String mentorID = meetingDoc['createdBy']; // Mentor ID from the meeting

      // Update the meeting document
      await _firestore.collection('meetings').doc(meetingID).update({
        'totalSessions': FieldValue.increment(1),
        'sessionHistory': FieldValue.arrayUnion([
          {
            'sessionID': Uuid().v4(),
            'sessionTimestamp': FieldValue.serverTimestamp(),
          }
        ]),
      });

      // Update mentor's session count
      await _updateMentorSessionCount(mentorID, userID);

      // Update mentee's session count
      await _updateMenteeSessionCount(userID, mentorID);

      print("Session count incremented successfully!");
    } catch (e) {
      print("Error incrementing session count: $e");
    }
  }

  Future<void> _updateMentorSessionCount(
      String mentorID, String menteeID) async {
    try {
      DocumentReference mentorDoc =
          _firestore.collection('mentors').doc(mentorID);
      await mentorDoc.update({
        'sessionHistory': FieldValue.arrayUnion([
          {
            'menteeID': menteeID,
            'sessionTimestamp': FieldValue.serverTimestamp(),
          }
        ]),
      });
      print("Mentor session history updated!");
    } catch (e) {
      print("Error updating mentor session count: $e");
    }
  }

  Future<void> _updateMenteeSessionCount(
      String menteeID, String mentorID) async {
    try {
      DocumentReference menteeDoc =
          _firestore.collection('mentees').doc(menteeID);
      await menteeDoc.update({
        'sessionHistory': FieldValue.arrayUnion([
          {
            'mentorID': mentorID,
            'sessionTimestamp': FieldValue.serverTimestamp(),
          }
        ]),
        'totalSessions': FieldValue.increment(1), // Increment total sessions
      });
      print("Mentee session history updated!");
    } catch (e) {
      print("Error updating mentee session count: $e");
    }
  }
}
