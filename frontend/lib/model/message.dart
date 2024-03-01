class Message {
  int id;
  int sender;
  int conversationid;
  String content;
  String sentat;

  Message({
    required this.id,
    required this.sender,
    required this.conversationid,
    required this.content,
    required this.sentat,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: json['sender'],
      conversationid: json['conversationid'],
      content: json['content'],
      sentat: json['sentat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'conversationid': conversationid,
      'content': content,
      'sentat': sentat,
    };
  }
}
