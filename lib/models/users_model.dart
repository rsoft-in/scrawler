class Users {
  final String userId;
  final String userEmail;
  final String userFullname;

  Users(this.userId, this.userEmail, this.userFullname);

  Users.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        userEmail = json['user_email'],
        userFullname = json['user_fullname'];
}
