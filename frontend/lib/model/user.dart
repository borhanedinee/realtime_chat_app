class User {
  int userId;
  String userFirstName;
  String userSecondName;
  String userEmail;
  String userPassword;
  DateTime userCreatedAt;

  User({
    required this.userId,
    required this.userFirstName,
    required this.userSecondName,
    required this.userEmail,
    required this.userPassword,
    required this.userCreatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      userFirstName: json['user_firstname'],
      userSecondName: json['user_secondname'],
      userEmail: json['user_email'],
      userPassword: json['user_password'],
      userCreatedAt: DateTime.parse(json['user_created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_firstname': userFirstName,
      'user_secondname': userSecondName,
      'user_email': userEmail,
      'user_password': userPassword,
      'user_created_at': userCreatedAt.toIso8601String(),
    };
  }
}
