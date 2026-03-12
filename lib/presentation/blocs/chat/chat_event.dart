sealed class ChatEvent {}

final class SendMessage extends ChatEvent {
  SendMessage(this.text);

  final String text;
}

final class DisposeModel extends ChatEvent {}
