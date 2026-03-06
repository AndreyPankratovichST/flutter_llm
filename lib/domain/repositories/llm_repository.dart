import 'package:flutter_llm/domain/entities/message.dart';

abstract class LLMRepository {
  Future<void> initModel();

  Future<void> disposeModel();

  Future<void> sendMessage(Message message);

  Stream<Message> listenMessages();
}