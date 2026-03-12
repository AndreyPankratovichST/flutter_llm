import 'package:flutter_llm/domain/entities/message.dart';

final class ChatState {
  const ChatState({
    this.messages = const [],
    this.isGenerating = false,
  });

  final List<Message> messages;
  final bool isGenerating;

  ChatState copyWith({
    List<Message>? messages,
    bool? isGenerating,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }
}
