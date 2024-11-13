class Message {
  final String text;
  final bool isUser;
  final DateTime timestap;

  Message({
    required this.text,
    required this.isUser,
    DateTime? timestap,
  }) : timestap = timestap ?? DateTime.now();
}
