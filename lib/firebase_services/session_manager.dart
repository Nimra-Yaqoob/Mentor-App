class SessionController {
  static final SessionController _session = SessionController._internal();
  String? userId;
  factory SessionController() {
    return _session;
  }

  SessionController._internal() {}
}

class SessionManager {
  static String _userId = '';
  static String _userImageUrl = '';
  static String _userName = ''; // Add a variable to store the user's name
  static String _userEmail = '';

  // Method to set user ID
  static void setUserId(String userId) {
    _userId = userId;
  }

  // Method to get user ID
  static String getUserId() {
    return _userId;
  }

  // Method to set user image URL
  static void setUserImageUrl(String userImageUrl) {
    _userImageUrl = userImageUrl;
  }

  // Method to get user image URL
  static String getUserImageUrl() {
    return _userImageUrl;
  }

  // Method to set user name
  static void setUserName(String userName) {
    _userName = userName;
  }

  // Method to get user name
  static String getUserName() {
    return _userName;
  }

  // Method to set user email
  static void setUserEmail(String userEmail) {
    _userEmail = userEmail;
  }

  // Method to get user email
  static String getUserEmail() {
    return _userEmail;
  }
}
