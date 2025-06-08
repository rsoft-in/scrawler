class User {
  String userId;
  String userEmail;
  String userName;
  bool userEnabled;

  User(this.userId, this.userEmail, this.userName, this.userEnabled);

  User.empty() : this('', '', 'Guest', true);

  User.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        userEmail = json['user_email'],
        userName = json['user_name'],
        userEnabled = json['user_enabled'] == '1';
}
