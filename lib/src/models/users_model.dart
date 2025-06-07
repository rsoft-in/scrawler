class User {
  String userId;
  String userEmail;
  String userName;
  String userOtp;
  String userPwd;
  bool userEnabled;

  User(this.userId, this.userEmail, this.userName, this.userOtp, this.userPwd,
      this.userEnabled);

  User.empty(): this('', '', 'Guest', '', '', true);

  User.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        userEmail = json['user_email'],
        userName = json['user_name'],
        userOtp = json['user_otp'],
        userPwd = json['user_pwd'],
        userEnabled = json['user_enabled'] == '1';
}
