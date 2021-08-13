class Users {
  final String userId;
  final String userEmail;
  final String userName;

  Users(this.userId, this.userEmail, this.userName);

  Users.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        userEmail = json['user_email'],
        userName = json['user_name'];
}
