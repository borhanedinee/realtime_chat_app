class Chat {
  int id;
  String lastMessage;
  bool isLastMessageSeen;
  String lastsentat;
  int userId;
  String userCreatedAt;
  String userFirstName;
  String userSecondName;
  String userEmail;

  Chat({
    required this.id,
    required this.lastMessage,
    required this.isLastMessageSeen,
    required this.lastsentat,
    required this.userId,
    required this.userFirstName,
    required this.userSecondName,
    required this.userEmail,
    required this.userCreatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      lastMessage: json['lastmessage'],
      isLastMessageSeen: json['islastmessageseen'] == 1 ? true : false,
      userId: json['user_id'],
      userFirstName: json['user_firstname'],
      userSecondName: json['user_secondname'],
      userEmail: json['user_email'],
      lastsentat: json['lastsentat'].toString(),
      userCreatedAt: json['user_created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lastmessage'] = this.lastMessage;
    data['islastmessageseen'] = this.isLastMessageSeen ? 1 : 0;
    data['user_id'] = this.userId;
    data['user_firstname'] = this.userFirstName;
    data['user_secondname'] = this.userSecondName;
    data['user_email'] = this.userEmail;
    return data;
  }
}
