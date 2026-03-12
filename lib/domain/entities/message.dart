class Message {
  Message({required this.text, required this.isUser});

  final String text;
  final bool isUser;

  Message copyWith({String? text, bool? isUser}) {
    return Message(text: text ?? this.text, isUser: isUser ?? this.isUser);
  }
}
