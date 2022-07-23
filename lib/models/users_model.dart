class User {
  final String userId;
  final String userEmail;
  final String userName;
  final String userOtp;
  final String userPwd;
  final String userEnabled;

  User(this.userId, this.userEmail, this.userName, this.userOtp, this.userPwd,
      this.userEnabled);

  User.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        userEmail = json['user_email'],
        userName = json['user_name'],
        userOtp = json['user_otp'],
        userPwd = json['user_pwd'],
        userEnabled = json['user_enabled'];
}
